# MultiMap

Common use cases:
- **FE**: event listeners registry, tag-to-items index, keyboard shortcut groups, form field ↔ validation rules
- **BE**: HTTP headers (multiple values per key), route ↔ middleware chain, role ↔ permissions, pub/sub topic ↔ subscribers

## mnemonist (preferred)

```javascript
import MultiMap from 'mnemonist/multi-map';

const mm = new MultiMap();

mm.set('tag', 'article-1');
mm.set('tag', 'article-2');
mm.set('tag', 'article-3');

mm.get('tag');         // ['article-1', 'article-2', 'article-3']
mm.has('tag');         // true
mm.multiplicity('tag'); // 3 (number of values for this key)
mm.size;               // 3 (total number of associations)
mm.dimension;          // 1 (number of distinct keys)

// Set-based container (unique values per key)
const unique = new MultiMap(Set);
unique.set('role', 'admin');
unique.set('role', 'admin'); // ignored
unique.get('role'); // Set { 'admin' }
```

## Manual fallback

```javascript
class MultiMap {
  #map = new Map();
  #size = 0;

  get size() {
    return this.#size;
  }

  set(key, value) {
    let values = this.#map.get(key);

    if (!values) {
      values = [];
      this.#map.set(key, values);
    }

    values.push(value);
    this.#size++;
  }

  get(key) {
    return this.#map.get(key) ?? [];
  }

  has(key) {
    return this.#map.has(key);
  }

  delete(key) {
    const values = this.#map.get(key);

    if (!values) {
      return false;
    }

    this.#size -= values.length;
    this.#map.delete(key);

    return true;
  }

  *entries() {
    for (const [key, values] of this.#map) {
      for (const value of values) {
        yield [key, value];
      }
    }
  }
}
```
