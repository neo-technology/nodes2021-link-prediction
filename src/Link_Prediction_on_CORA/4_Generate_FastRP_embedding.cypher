//4. Generate FastRP embedding
 CALL gds.beta.fastRPExtended.mutate(
                        'cora',
                        {
                          relationshipTypes: ['EMBEDDING_GRAPH'],
                          mutateProperty: 'frp',
                          embeddingDimension: 512,
                          propertyDimension: 256,
                          randomSeed: 42,
                          featureProperties: ['features']
                        }
                      )