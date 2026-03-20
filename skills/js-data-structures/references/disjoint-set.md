# Disjoint Set (Union-Find)

Common use cases:
- **FE**: pixel flood fill, drag-to-group UI elements, connected node selection in graph editors, undo grouping
- **BE**: connected components, cycle detection, Kruskal's MST, social network clustering, equivalence classes, network partition detection

## mnemonist (preferred)

```javascript
import StaticDisjointSet from 'mnemonist/static-disjoint-set';

// fixed-size: elements are integers 0..N-1
const ds = new StaticDisjointSet(6);

ds.union(0, 1);
ds.union(2, 3);
ds.union(1, 3);

ds.find(0) === ds.find(3); // true — same component
ds.find(0) === ds.find(4); // false — different components

ds.connected(0, 2); // true
ds.dimension;        // 3 (number of distinct sets: {0,1,2,3}, {4}, {5})
```

## Manual fallback (Path compression + union by rank)

```javascript
class DisjointSet {
  #parent;
  #rank;

  constructor(size) {
    this.#parent = Array.from({ length: size }, (_, i) => i);
    this.#rank = new Uint8Array(size);
  }

  find(x) {
    if (this.#parent[x] !== x) {
      this.#parent[x] = this.find(this.#parent[x]); // path compression
    }

    return this.#parent[x];
  }

  union(a, b) {
    const rootA = this.find(a);
    const rootB = this.find(b);

    if (rootA === rootB) {
      return false;
    }

    // union by rank
    if (this.#rank[rootA] < this.#rank[rootB]) {
      this.#parent[rootA] = rootB;
    } else if (this.#rank[rootA] > this.#rank[rootB]) {
      this.#parent[rootB] = rootA;
    } else {
      this.#parent[rootB] = rootA;
      this.#rank[rootA]++;
    }

    return true;
  }

  connected(a, b) {
    return this.find(a) === this.find(b);
  }

  get dimension() {
    const roots = new Set();

    for (let i = 0; i < this.#parent.length; i++) {
      roots.add(this.find(i));
    }

    return roots.size;
  }
}
```
