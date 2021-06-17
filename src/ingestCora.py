from neo4j import GraphDatabase

cora_content = "../data/cora.content"
cora_cites = "../data/cora.cites"

subject_to_id = {
        "Neural_Networks": 0,
        "Rule_Learning": 1,
        "Reinforcement_Learning": 2,
        "Probabilistic_Methods": 3,
        "Theory": 4,
        "Genetic_Algorithms": 5,
        "Case_Based": 6
}
id_to_subject = {v: k for k, v in subject_to_id.items()}

def readlines(path):
    with open(path, 'r') as f:
        return list(map(lambda line: line.strip(), f.readlines()))


def loadNodes(session):
    for line in readlines(cora_content):
        tokens = line.split(',')
        ext_id = int(tokens[0])
        subject_text = tokens[1]
        subject = subject_to_id[subject_text]
        features = list(map(int, tokens[2:]))
        query = "CREATE (n:Paper {extId: $extId, subject: $subject, features: $features})"
        session.run(query, {"extId": ext_id, "subject": subject, "features": features})

def loadRelationships(session):
    for line in readlines(cora_cites):
        tokens = line.split(',')
        source_ext_id = int(tokens[0])
        target_ext_id = int(tokens[1])
        query = "MATCH (n:Paper), (m:Paper) WHERE n.extId = $source_ext_id AND m.extId = $target_ext_id MERGE (n)-[:CITES]->(m)"
        session.run(query, {"source_ext_id": source_ext_id, "target_ext_id": target_ext_id})

with GraphDatabase.driver("neo4j://localhost", auth=("neo4j", "cora")) as driver:
    with driver.session() as session:
        loadNodes(session)
        loadRelationships(session)



