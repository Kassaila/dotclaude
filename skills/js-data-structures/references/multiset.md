# MultiSet (Bag / Counter)

Common use cases:
- **FE**: vote/reaction tallying, poll results, filter tag counts, shopping cart item quantities
- **BE**: word frequency counting, log level histogram, inventory tracking, anagram detection, API usage metering per key

## mnemonist (preferred)

```javascript
import MultiSet from 'mnemonist/multi-set';

const bag = new MultiSet();

bag.add('apple');
bag.add('apple');
bag.add('banana');

bag.multiplicity('apple'); // 2
bag.multiplicity('banana'); // 1
bag.count('cherry');        // 0
bag.size;                   // 3 (total count)
bag.dimension;              // 2 (distinct elements)

bag.remove('apple');        // decrements count
bag.remove('apple');        // removes entirely

// from iterable
const counter = MultiSet.from('abracadabra');
counter.multiplicity('a');  // 5

// top-k
counter.top(3); // [['a', 5], ['b', 2], ['r', 2]]
```

## Manual fallback

```javascript
class MultiSet {
  #counts = new Map();
  #size = 0;

  get size() {
    return this.#size;
  }

  get dimension() {
    return this.#counts.size;
  }

  add(item, count = 1) {
    const current = this.#counts.get(item) ?? 0;

    this.#counts.set(item, current + count);
    this.#size += count;
  }

  remove(item, count = 1) {
    const current = this.#counts.get(item);

    if (current === undefined) {
      return;
    }

    const next = current - count;

    if (next <= 0) {
      this.#size -= current;
      this.#counts.delete(item);
    } else {
      this.#size -= count;
      this.#counts.set(item, next);
    }
  }

  count(item) {
    return this.#counts.get(item) ?? 0;
  }

  multiplicity(item) {
    return this.count(item);
  }

  has(item) {
    return this.#counts.has(item);
  }

  *[Symbol.iterator]() {
    for (const [item, count] of this.#counts) {
      for (let i = 0; i < count; i++) {
        yield item;
      }
    }
  }
}
```
