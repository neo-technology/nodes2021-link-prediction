// yyy. Count TEST edges
MATCH (n:Person)-[r:TEST]->(m:Person) RETURN COUNT(r)