// 1. Create the social graph
CALL gds.graph.create('social',
  'Person',
  {
      CONNECTED: {orientation: 'UNDIRECTED'},
      TRAIN: {orientation: 'UNDIRECTED'},
      TEST: {orientation: 'UNDIRECTED'},
      FEATURES: {type: 'TRAIN_FEATURES', orientation: 'UNDIRECTED'}
  },
  {relationshipProperties: ['label']}
)