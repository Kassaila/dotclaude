# Bloom Filter

Common use cases:

- **FE**: username availability pre-check, "already seen" content filtering, local spell-check
  pre-filter
- **BE**: deduplication at scale (seen URLs, processed IDs), cache existence check before expensive
  DB lookup, email spam filtering, crawler visited-URL tracking

A probabilistic set: `.has()` can return false positives but never false negatives. Space-efficient
— uses bits instead of storing actual values.

## mnemonist (preferred)

```javascript
import BloomFilter from 'mnemonist/bloom-filter';

/**
 * auto-sized: expected items + desired error rate
 */
const filter = BloomFilter.from(['user:1', 'user:2', 'user:3'], { errorRate: 0.01 });

/**
 * test('user:1') → true (definitely added)
 * test('user:999') → false (definitely not added)
 * test('user:42') → may be false positive (never false negatives)
 */
filter.test('user:1');
filter.test('user:999');
filter.test('user:42');

/**
 * manual capacity (1000 bits)
 */
const f = new BloomFilter(1000);
f.add('item');
f.test('item');
```

## Manual fallback

```javascript
class BloomFilter {
  #bits;
  #size;
  #hashCount;

  constructor(expectedItems, errorRate = 0.01) {
    this.#size = Math.ceil(-(expectedItems * Math.log(errorRate)) / Math.log(2) ** 2);
    this.#hashCount = Math.ceil((this.#size / expectedItems) * Math.log(2));
    this.#bits = new Uint8Array(Math.ceil(this.#size / 8));
  }

  add(value) {
    for (const pos of this.#positions(value)) {
      this.#bits[pos >>> 3] |= 1 << (pos & 7);
    }
  }

  test(value) {
    for (const pos of this.#positions(value)) {
      if ((this.#bits[pos >>> 3] & (1 << (pos & 7))) === 0) {
        return false;
      }
    }

    return true;
  }

  *#positions(value) {
    const str = String(value);
    let h1 = 0x811c9dc5;
    let h2 = 0x6b8b4567;

    for (let i = 0; i < str.length; i++) {
      const c = str.charCodeAt(i);

      h1 ^= c;
      h1 = Math.imul(h1, 0x01000193);

      h2 = Math.imul(h2 ^ c, 0x5bd1e995);
      h2 ^= h2 >>> 13;
    }

    /**
     * ensure h2 is never zero — fallback to a derived value
     */
    if (h2 === 0) {
      h2 = h1 | 1;
    }

    for (let i = 0; i < this.#hashCount; i++) {
      yield Math.abs((h1 + i * h2) % this.#size);
    }
  }
}
```
