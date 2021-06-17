//6. Run Link Prediction model
CALL gds.alpha.ml.linkPrediction.predict.mutate('cora', {modelName: 'model', mutateRelationshipType: 'predictedLink', topN: 100, threshold: 0.0})