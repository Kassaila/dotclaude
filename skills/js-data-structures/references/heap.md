# Heap (Priority Queue)

Common use cases:

- **FE**: top-N search results, z-index layer management, drag-and-drop priority ordering,
  notification priority
- **BE**: task scheduling, Dijkstra/A\* pathfinding, merge K sorted streams, rate limiter (next
  expiry), event-driven simulation, median maintenance

## mnemonist (preferred)

```javascript
import Heap, { nsmallest, nlargest } from 'mnemonist/heap';

/**
 * min-heap (default)
 */
const min = new Heap();

min.push(5);
min.push(2);
min.push(8);

/**
 * → 2
 */
min.peek();
/**
 * → 2 (removes it)
 */
min.pop();
/**
 * → 2
 */
min.size;

/**
 * max-heap
 */
const max = Heap.maxHeap();

max.push(5);
max.push(8);

/**
 * → 8
 */
max.peek();

/**
 * custom comparator — objects by priority
 */
const pq = new Heap((a, b) => a.priority - b.priority);

pq.push({ task: 'low', priority: 10 });
pq.push({ task: 'critical', priority: 1 });

/**
 * → { task: 'critical', priority: 1 }
 */
pq.peek();

/**
 * get N smallest/largest from array without full sort — O(n log k)
 * nsmallest → [1, 3, 5]
 * nlargest → [9, 7]
 */
nsmallest(3, [9, 1, 7, 3, 5]);
nlargest(2, [9, 1, 7, 3, 5]);
```

For fixed-size "keep top N" scenarios:
`import FixedReverseHeap from 'mnemonist/fixed-reverse-heap'`.

## Manual fallback (Binary min-heap)

```javascript
class MinHeap {
  #data = [];

  get size() {
    return this.#data.length;
  }

  peek() {
    return this.#data[0];
  }

  push(value) {
    this.#data.push(value);

    this.#siftUp(this.#data.length - 1);
  }

  pop() {
    if (this.#data.length === 0) {
      return undefined;
    }

    const top = this.#data[0];
    const last = this.#data.pop();

    if (this.#data.length > 0) {
      this.#data[0] = last;
      this.#siftDown(0);
    }

    return top;
  }

  #siftUp(i) {
    while (i > 0) {
      const parent = (i - 1) >>> 1;

      if (this.#data[i] >= this.#data[parent]) {
        break;
      }

      [this.#data[i], this.#data[parent]] = [this.#data[parent], this.#data[i]];

      i = parent;
    }
  }

  #siftDown(i) {
    const n = this.#data.length;

    while (true) {
      let smallest = i;
      const left = 2 * i + 1;
      const right = 2 * i + 2;

      if (left < n && this.#data[left] < this.#data[smallest]) {
        smallest = left;
      }

      if (right < n && this.#data[right] < this.#data[smallest]) {
        smallest = right;
      }

      if (smallest === i) {
        break;
      }

      [this.#data[i], this.#data[smallest]] = [this.#data[smallest], this.#data[i]];

      i = smallest;
    }
  }
}
```
