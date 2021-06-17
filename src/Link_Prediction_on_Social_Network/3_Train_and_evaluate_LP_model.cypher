// 3. Train and evaluate LP model
CALL gds.alpha.ml.linkPrediction.train(
              'social',
              {
                trainRelationshipType: 'TRAIN',
                testRelationshipType: 'TEST',
                modelName: 'model',
                featureProperties: ['frp'],
                validationFolds: 5,
                negativeClassWeight: 1.0,
                randomSeed: 42,
                concurrency: 16,
                params: [
                  {patience: 3, penalty: 0.0001,     batchSize: 10, maxEpochs: 100, linkFeatureCombiner: 'HADAMARD'},
                  {patience: 3, penalty: 0.0001,     batchSize: 10, maxEpochs: 100, linkFeatureCombiner: 'L2'},
                  {patience: 3, penalty: 0.0001,     batchSize: 10, maxEpochs: 100, linkFeatureCombiner: 'COSINE'}
                ]
            })
            YIELD modelInfo
            RETURN modelInfo.metrics.AUCPR.test AS test_auc, modelInfo.metrics.AUCPR.outerTrain AS train_auc, modelInfo.bestParameters AS bestParameters