# DefaultMap

Common use cases:
- **FE**: grouping UI elements by category, form validation error collection, component registry by type
- **BE**: grouping items by key, counting occurrences, building adjacency lists, log aggregation by level, request grouping by endpoint

## mnemonist (preferred)

```javascript
import DefaultMap from 'mnemonist/default-map';

// group items — factory returns a new array for each missing key
const groups = new DefaultMap(() => []);

groups.get('frontend').push('React');
groups.get('frontend').push('Vue');
groups.get('backend').push('Express');

groups.get('frontend'); // ['React', 'Vue']

// count occurrences
const counter = new DefaultMap(() => 0);

for (const word of words) {
  counter.set(word, counter.get(word) + 1);
}

// adjacency list
const graph = new DefaultMap(() => []);

graph.get('a').push('b');
graph.get('a').push('c');
graph.get('b').push('a');
```

## Manual fallback

```javascript
class DefaultMap extends Map {
  #factory;

  constructor(factory, entries) {
    super(entries);
    this.#factory = factory;
  }

  get(key) {
    if (!this.has(key)) {
      this.set(key, this.#factory(key));
    }

    return super.get(key);
  }
}
```
