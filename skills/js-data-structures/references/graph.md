# Graph

Common use cases:

- **FE**: relationship UIs (social networks, org charts), dependency visualization, knowledge graph
  explorers, interactive graph editors (sigma.js)
- **BE**: shortest path / routing, community detection (Louvain), topological sort for DAGs,
  centrality / PageRank, connected components, cycle detection

## graphology (preferred)

```javascript
import Graph from 'graphology';

const graph = new Graph();

/**
 * nodes
 */
graph.addNode('alice', { role: 'admin' });
graph.addNode('bob', { role: 'user' });
graph.addNode('carol', { role: 'user' });

/**
 * edges
 */
graph.addEdge('alice', 'bob', { weight: 1 });
graph.addEdge('bob', 'carol', { weight: 3 });
graph.addEdge('alice', 'carol', { weight: 2 });

/**
 * query
 * order → 3 (node count)
 * size → 3 (edge count)
 * hasNode → true
 * neighbors → ['alice', 'carol']
 * degree → 2
 */
graph.order;
graph.size;
graph.hasNode('alice');
graph.neighbors('bob');
graph.degree('alice');

/**
 * traverse
 */
graph.forEachNode((node, attrs) => console.log(node, attrs.role));
graph.forEachEdge((edge, attrs, source, target) =>
  console.log(`${source} -> ${target} (${attrs.weight})`),
);

/**
 * update — mergeNode/mergeEdge add or update if already exists
 */
graph.mergeNode('dave', { role: 'user' });
graph.mergeEdge('dave', 'alice');
graph.updateNodeAttribute('alice', 'role', (r) => r.toUpperCase());
```

For typed graphs: `import { DirectedGraph, UndirectedGraph } from 'graphology'`.

### Algorithm modules

Install individually or all at once via `graphology-library`.

| Package                          | What it does                                                    |
| -------------------------------- | --------------------------------------------------------------- |
| `graphology-shortest-path`       | Dijkstra, A\* — find cheapest/fastest route between nodes       |
| `graphology-traversal`           | BFS, DFS — walk the graph in breadth-first or depth-first order |
| `graphology-communities-louvain` | Louvain clustering — detect groups of densely connected nodes   |
| `graphology-components`          | Connected components — find isolated subgraphs (strong/weak)    |
| `graphology-metrics`             | Centrality, density, modularity — measure node/graph importance |
| `graphology-dag`                 | Topological sort, cycle detection — for directed acyclic graphs |
| `graphology-operators`           | Union, intersection, reverse — combine or transform graphs      |

```javascript
/**
 * shortest path — find route between two nodes
 */
import { dijkstra } from 'graphology-shortest-path';

dijkstra.bidirectional(graph, 'alice', 'carol');

/**
 * community detection — assign cluster labels to nodes
 */
import louvain from 'graphology-communities-louvain';

louvain.assign(graph);

/**
 * traversal — walk graph breadth-first from a starting node
 */
import { bfsFromNode } from 'graphology-traversal';

bfsFromNode(graph, 'alice', (node, attrs, depth) => {
  console.log(node, depth);
});
```

## Manual fallback (Adjacency list)

```javascript
class Graph {
  #adj = new Map();

  addNode(node) {
    if (!this.#adj.has(node)) {
      this.#adj.set(node, new Map());
    }
  }

  addEdge(from, to, weight = 1) {
    this.addNode(from);
    this.addNode(to);
    this.#adj.get(from).set(to, weight);
    this.#adj.get(to).set(from, weight);
  }

  neighbors(node) {
    return [...(this.#adj.get(node)?.keys() ?? [])];
  }

  hasNode(node) {
    return this.#adj.has(node);
  }

  hasEdge(from, to) {
    return this.#adj.get(from)?.has(to) ?? false;
  }

  get order() {
    return this.#adj.size;
  }

  *bfs(start) {
    const visited = new Set([start]);
    const queue = [start];

    while (queue.length > 0) {
      const node = queue.shift();
      yield node;

      for (const neighbor of this.neighbors(node)) {
        if (!visited.has(neighbor)) {
          visited.add(neighbor);

          queue.push(neighbor);
        }
      }
    }
  }

  *dfs(start, visited = new Set()) {
    visited.add(start);
    yield start;

    for (const neighbor of this.neighbors(start)) {
      if (!visited.has(neighbor)) {
        yield* this.dfs(neighbor, visited);
      }
    }
  }
}
```
