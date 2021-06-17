//7. Inspect results
CALL gds.graph.streamRelationshipProperty('cora', 'probability')
 YIELD sourceNodeId, targetNodeId, propertyValue
 WITH sourceNodeId as sourceNodeId, targetNodeId as targetNodeId, propertyValue as propertyValue, ['Neural Networks', 'Rule Learning', 'Reinforcement Learning', 'Probabilistic Methods', 'Theory', 'Genetic Algorithms', 'Case Based'] as lookup
 RETURN sourceNodeId, targetNodeId,
        lookup[gds.util.asNode(sourceNodeId).subject] as sourceSubject,
        lookup[gds.util.asNode(targetNodeId).subject] as targetSubject,
        propertyValue as probability