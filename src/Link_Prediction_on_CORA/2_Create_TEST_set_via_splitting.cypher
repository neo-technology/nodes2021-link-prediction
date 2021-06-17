//2. Create TEST set via splitting
CALL gds.alpha.ml.splitRelationships.mutate(
                        'cora',
                        { 
                          remainingRelationshipType: 'OUTER_TRAIN',
                          holdoutRelationshipType: 'TEST',
                          holdoutFraction: 0.1,
                          negativeSamplingRatio: 1.0,
                          randomSeed: 42
                        }
                      )