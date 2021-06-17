//5. Train Link Prediction model
 CALL gds.alpha.ml.linkPrediction.train(
              'cora',
              {
                trainRelationshipType: 'TRAIN',
                testRelationshipType: 'TEST',
                modelName: 'model',
                featureProperties: ['frp'],
                validationFolds: 5,
                negativeClassWeight: 1.0,
                randomSeed: 42,
                concurrency: 8,
                params: [
                  {penalty: 0.0001,  maxEpochs: 100, linkFeatureCombiner: 'HADAMARD'},
                  {penalty: 1.0,     maxEpochs: 100, linkFeatureCombiner: 'HADAMARD'},
                  {penalty: 10000.0, maxEpochs: 100, linkFeatureCombiner: 'HADAMARD'},
                  {penalty: 0.0001,  maxEpochs: 100,  linkFeatureCombiner: 'L2'},
                  {penalty: 1.0,     maxEpochs: 100, linkFeatureCombiner: 'L2'},
                  {penalty: 10000.0, maxEpochs: 100, linkFeatureCombiner: 'L2'},
                  {penalty: 0.0001,  maxEpochs: 100, linkFeatureCombiner: 'COSINE'},
                  {penalty: 1.0,     maxEpochs: 100, linkFeatureCombiner: 'COSINE'},
                  {penalty: 10000.0, maxEpochs: 100, linkFeatureCombiner: 'COSINE'}
                ]
            })
            YIELD modelInfo
            RETURN modelInfo.metrics.AUCPR.test AS test_auc, modelInfo.metrics.AUCPR.outerTrain AS train_auc, modelInfo.bestParameters AS bestParameters