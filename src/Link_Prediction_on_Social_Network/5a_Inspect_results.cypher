//5a. Inspect results
CALL gds.graph.streamRelationshipProperty('social', 'probability')
 YIELD sourceNodeId, targetNodeId, propertyValue
 WHERE sourceNodeId < targetNodeId AND gds.util.asNode(sourceNodeId).communities =
        gds.util.asNode(targetNodeId).communities
 RETURN COUNT(*)