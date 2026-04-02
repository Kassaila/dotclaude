# MultiSet (Bag / Counter)

Common use cases:

- **FE**: vote/reaction tallying, poll results, filter tag counts, shopping cart item quantities
- **BE**: word frequency counting, log level histogram, inventory tracking, anagram detection, API
  usage metering per key

## mnemonist (preferred)

```javascript
import MultiSet from 'mnemonist/multi-set';

const bag = new MultiSet();

bag.add('apple');
bag.add('apple');
bag.add('banana');

/**
 * multiplicity('apple') → 2
 * multiplicity('banana') → 1
 * count('cherry') → 0
 * size → 3 (total count)
 * dimension → 2 (distinct elements)
 */
bag.multiplicity('apple');
bag.multiplicity('banana');
bag.count('cherry');
bag.size;
bag.dimension;

/**
 * remove — decrements count, removes entirely when 0
 */
bag.remove('apple');
bag.remove('apple');

/**
 * from iterable
 */
const counter = MultiSet.from('abracadabra');

/**
 * → 5
 */
counter.multiplicity('a');

/**
 * top-k → [['a', 5], ['b', 2], ['r', 2]]
 */
counter.top(3);
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
