// 4. Predict new links
CALL gds.alpha.ml.linkPrediction.predict.mutate('social',
  {
      relationshipTypes: ['CONNECTED'],
      modelName: 'model',
      mutateRelationshipType: 'predictedLink',
      topN: 100,
      threshold: 0.0,
      concurrency: 16
  }
)