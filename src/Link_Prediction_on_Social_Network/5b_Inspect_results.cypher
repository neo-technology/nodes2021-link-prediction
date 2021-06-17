//5b. Inspect results
CALL gds.graph.streamRelationshipProperty('social', 'probability')
 YIELD sourceNodeId, targetNodeId, propertyValue
 RETURN sourceNodeId, targetNodeId,
        gds.util.asNode(sourceNodeId).communities as sourceCommunities,
        gds.util.asNode(targetNodeId).communities as targetCommunities,
        propertyValue as probability
ORDER BY probability DESC