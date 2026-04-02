# LRU Cache

Common use cases:

- **FE**: API response caching, image/asset caching, memoized selectors, component render cache
- **BE**: DB query result caching, session store, DNS resolution cache, template compilation cache

## mnemonist (preferred)

```javascript
import LRUCache from 'mnemonist/lru-cache';

const cache = new LRUCache(100);

cache.set('user:1', { name: 'Alice' });

/**
 * promotes to most-recent
 */
cache.get('user:1');

/**
 * same, but without promotion
 */
cache.peek('user:1');

/**
 * returns evicted entry if at capacity
 */
const evicted = cache.setpop('user:101', data);
```

Internally uses typed arrays as doubly-linked list pointers — zero GC pressure vs object-node
approach.

## Manual fallback (Doubly-linked list + Map)

```javascript
class DoublyLinkedList {
  #head = null;
  #tail = null;
  #length = 0;

  get length() {
    return this.#length;
  }

  pushFront(node) {
    node.prev = null;
    node.next = this.#head;

    if (this.#head) {
      this.#head.prev = node;
    } else {
      this.#tail = node;
    }

    this.#head = node;

    this.#length++;
  }

  removeLast() {
    if (!this.#tail) {
      return null;
    }

    const node = this.#tail;

    this.remove(node);

    return node;
  }

  remove(node) {
    const { prev, next } = node;

    if (prev) {
      prev.next = next;
    } else {
      this.#head = next;
    }

    if (next) {
      next.prev = prev;
    } else {
      this.#tail = prev;
    }

    node.prev = null;
    node.next = null;

    this.#length--;
  }

  moveToFront(node) {
    this.remove(node);
    this.pushFront(node);
  }

  *[Symbol.iterator]() {
    let node = this.#head;

    while (node) {
      yield node;

      node = node.next;
    }
  }
}

class LRUCache {
  #capacity;
  #map = new Map();
  #list = new DoublyLinkedList();

  constructor(capacity) {
    this.#capacity = capacity;
  }

  get(key) {
    const node = this.#map.get(key);

    if (!node) {
      return undefined;
    }

    this.#list.moveToFront(node);

    return node.value;
  }

  peek(key) {
    const node = this.#map.get(key);

    return node ? node.value : undefined;
  }

  set(key, value) {
    let node = this.#map.get(key);

    if (node) {
      node.value = value;

      this.#list.moveToFront(node);

      return;
    }

    if (this.#map.size >= this.#capacity) {
      const evicted = this.#list.removeLast();

      this.#map.delete(evicted.key);
    }

    node = { key, value, prev: null, next: null };

    this.#list.pushFront(node);
    this.#map.set(key, node);
  }
}
```
