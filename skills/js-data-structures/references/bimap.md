# BiMap (Bidirectional Map)

Common use cases:

- **FE**: keybinding ↔ action mapping, locale code ↔ language name, theme token ↔ CSS variable, tab
  ID ↔ route
- **BE**: enum/code bidirectional lookups, ID ↔ slug, MIME type ↔ extension, user ID ↔ socket ID,
  short URL ↔ full URL

## mnemonist (preferred)

```javascript
import BiMap from 'mnemonist/bi-map';

const bm = new BiMap();

bm.set('ua', 'Ukraine');
bm.set('us', 'United States');

/**
 * get('ua') → 'Ukraine'
 * inverse.get('Ukraine') → 'ua'
 */
bm.get('ua');
bm.inverse.get('Ukraine');

bm.delete('ua');

/**
 * → 1
 */
bm.size;
```

## Manual fallback (Two Maps)

```javascript
class BiMap {
  #forward = new Map();
  #inverse = new Map();

  get size() {
    return this.#forward.size;
  }

  set(key, value) {
    if (this.#forward.has(key)) {
      this.#inverse.delete(this.#forward.get(key));
    }

    if (this.#inverse.has(value)) {
      this.#forward.delete(this.#inverse.get(value));
    }

    this.#forward.set(key, value);
    this.#inverse.set(value, key);
  }

  get(key) {
    return this.#forward.get(key);
  }

  getKey(value) {
    return this.#inverse.get(value);
  }

  delete(key) {
    if (!this.#forward.has(key)) {
      return false;
    }

    this.#inverse.delete(this.#forward.get(key));
    this.#forward.delete(key);

    return true;
  }

  has(key) {
    return this.#forward.has(key);
  }

  hasValue(value) {
    return this.#inverse.has(value);
  }
}
```
