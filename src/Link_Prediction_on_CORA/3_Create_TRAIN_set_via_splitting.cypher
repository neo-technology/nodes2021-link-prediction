//3. Create TRAIN set via splitting
CALL gds.alpha.ml.splitRelationships.mutate(
                        'cora',
                        {
                          relationshipTypes: ['OUTER_TRAIN'],
                          remainingRelationshipType: 'EMBEDDING_GRAPH',
                          holdoutRelationshipType: 'TRAIN',
                          holdoutFraction: 0.1,
                          negativeSamplingRatio: 1.0,
                          randomSeed: 42
                        }
                      )