from collections import defaultdict
import numpy as np
from neo4j import GraphDatabase

node_count = 5000
communities_per_node = 1
communities = 50
# densities = [np.random.uniform(0.0, 1.0) for i in range(communities)]
densities = [1.0 for i in range(communities)]
density_history = []
link_rejection_probability = 0.98    # each time a connection because of a shared community would be formed it can be rejected. repeated for each community and node pair
density_change_factor = 1.0          # how much density grows or shrinks for a community if it changes at all
density_update_probability = 1.0     # how likely the density of a community is to change at a time step
timesteps = 3
memberships = defaultdict(set)       # node -> set of communities it belongs to. does not change.
nodes_in_communities = defaultdict(set)    # community -> set of nodes in community
adjacency = {}                       # time -> positive links formed at that time
negative_adjacency = {}              # time -> negative links formed at that time
global_adjacency = defaultdict(set)  # all links so far

def select(probability):
    return np.random.choice([True, False], p=[probability, 1-probability])

def assign_clusters(memberships, nodes_in_communities, densities, node_count, communities_per_node, communities):
    for node in range(node_count):
        for community in np.random.choice(range(communities), size=communities_per_node):
            memberships[node].add(community)
            nodes_in_communities[community].add(node)

def add_edges(global_adjacency, adjacency, memberships, nodes_in_communities, densities, node_count, link_rejection_probability, time):
    print("Add edges")
    edges_created = 0
    adjacency_for_time = defaultdict(set)
    for community in nodes_in_communities.keys(): 
        for node1 in nodes_in_communities[community]:
            for node2 in nodes_in_communities[community]:
                if node1 >= node2 or node2 in global_adjacency[node1]:
                    continue
                probability = (1 - link_rejection_probability) * densities[community]
                if select(probability):
                    adjacency_for_time[node1].add(node2)
                    global_adjacency[node1].add(node2)
                    edges_created += 1
                    print(f"Dude[tte] {node1} connected to Dude[tte] {node2} because both belong to community {community} at time {time}.")
    adjacency[time] = adjacency_for_time
    print(f"At time {time}, there were {edges_created} edges created.")
    return edges_created

def add_negative_edges(edges_created, negative_adjacency, memberships, nodes_in_communities, densities, node_count, link_rejection_probability, time):
    print("Add negative edges")
    negative_adjacency_for_time = defaultdict(set)
    remaining = edges_created
    while remaining > 0:
        if remaining % 10 == 0:
            print(f"Remaining negative edges: {remaining}")
        node1 = np.random.choice(range(node_count))
        node2 = np.random.choice(range(node_count))
        if node1 == node2:
            continue
        # if len(memberships[node1].intersection(memberships[node2])) > 0:
        # only works for 1 community per node
        if memberships[node1].intersection(memberships[node2]) == set():
            negative_adjacency_for_time[node1].add(node2)
            remaining -= 1
    negative_adjacency[time] = negative_adjacency_for_time

def update_densities(communities, density_update_probability, density_change_factor, densities, density_history):
    density_history.append([d for d in densities])
    for community in range(communities):
        if select(density_update_probability):
            if select(0.5):
                densities[community] *= density_change_factor
                if densities[community] > 1.0:
                    densities[community] = 1.0
            else:
                densities[community] /= density_change_factor

def write_to_neo4j(session, adj, time, label):
    feature_query = "MERGE (n)-[:FEATURES {label: $label}]->(m)"
    train_query = "MERGE (n)-[:TRAIN {label: $label}]->(m)"
    test_query = "MERGE (n)-[:TEST {label: $label}]->(m)"
    rel_queries = ["MERGE (n)-[:CONNECTED {time: $time, label: $label}]->(m)"]
    if time == 1:
        rel_queries.append(feature_query)
    if time == 2:
        rel_queries.append(train_query)
    if time == 3:
        rel_queries.append(test_query)
    query_end = ' '.join(rel_queries)
    query = "MATCH (n:Person), (m:Person) WHERE n.extId = $source_ext_id AND m.extId = $target_ext_id " + query_end
    queries_executed = 0
    for node1 in adj.keys():
        for node2 in adj[node1]:
            session.run(query, {"source_ext_id": int(node1), "target_ext_id": int(node2), "time": time, "label": label})
            queries_executed += 1
            if queries_executed % 10 == 0:
                print(f"Executed {queries_executed} write queries")

assign_clusters(memberships, nodes_in_communities, densities, node_count, communities_per_node, communities)

with GraphDatabase.driver("neo4j://localhost", auth=("neo4j", "123")) as driver:
    with driver.session() as session:
        for node in range(node_count):
            query = "CREATE (n:Person {extId: $extId, communities: $communities})"
            session.run(query, {"extId": node, "communities": list([int(m) for m in memberships[node]])})
        for time in range(1, 1 + timesteps):
           edges_created = add_edges(global_adjacency, adjacency, memberships, nodes_in_communities, densities, node_count, link_rejection_probability, time)
           add_negative_edges(edges_created, negative_adjacency, memberships, nodes_in_communities, densities, node_count, link_rejection_probability, time)
           update_densities(communities, density_update_probability, density_change_factor, densities, density_history)
           for community in range(communities):
               query = "CREATE (c:Community {time: $time, density: $density, communityId: $communityId})"
               session.run(query, {"communityId": community, "density": density_history[time - 1][community], "time": time})
           write_to_neo4j(session, adjacency[time], time, 1.0)
           write_to_neo4j(session, negative_adjacency[time], time, 0.0)
           time += 1
