//1. Create the graph
CALL gds.graph.create('cora', 'Paper', {CITES: {orientation: 'UNDIRECTED'}}, {nodeProperties: ['features']})