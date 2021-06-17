// yy. Count TRAIN edges
MATCH (n:Person)-[r:TRAIN]->(m:Person) RETURN COUNT(r)