//yyyy. Count FEATURES edges
MATCH (n:Person)-[r:TRAIN_FEATURES]->(m:Person) RETURN COUNT(r)