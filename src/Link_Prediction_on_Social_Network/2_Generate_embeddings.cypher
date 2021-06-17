// 2. Generate embeddings
CALL gds.fastRP.mutate(
                        'social',
                        {
                          relationshipTypes: ['FEATURES'],
                          mutateProperty: 'frp',
                          embeddingDimension: 512,
                          randomSeed: 42,
                          concurrency: 16,
                          iterationWeights: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0]
                        }
                      )