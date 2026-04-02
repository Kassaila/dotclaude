# Circular Buffer

Common use cases:

- **FE**: canvas trail effects (last N positions), real-time charts (last N data points), FPS/memory
  sampling, input history (undo ring)
- **BE**: rolling log buffer, metrics sliding window, connection pool round-robin, streaming data
  ingestion (last N events)

## mnemonist (preferred)

```javascript
import CircularBuffer from 'mnemonist/circular-buffer';

/**
 * overwrites oldest on overflow (ideal for sampling/streaming)
 */
const buf = new CircularBuffer(Array, 100);

buf.push('a');
buf.push('b');

/**
 * shift → 'a'
 * peekFirst → 'b'
 */
buf.shift();
buf.peekFirst();

/**
 * for numeric data — use typed arrays for better performance
 */
const samples = new CircularBuffer(Float64Array, 1000);
```

For strict capacity (throws on overflow): `import FixedDeque from 'mnemonist/fixed-deque'`.

## Manual fallback (Ring buffer, uses write/read instead of push/shift)

```javascript
class CircularBuffer {
  #buffer;
  #capacity;
  #count = 0;
  #readIdx = 0;
  #writeIdx = 0;

  constructor(capacity) {
    this.#capacity = capacity;
    this.#buffer = new Array(capacity);
  }

  get length() {
    return this.#count;
  }

  isFull() {
    return this.#count === this.#capacity;
  }

  isEmpty() {
    return this.#count === 0;
  }

  write(item) {
    if (this.isFull()) {
      throw new RangeError('Buffer is full');
    }

    this.#buffer[this.#writeIdx] = item;

    this.#writeIdx = (this.#writeIdx + 1) % this.#capacity;
    this.#count++;
  }

  forceWrite(item) {
    if (this.isFull()) {
      this.read();
    }

    this.write(item);
  }

  read() {
    if (this.isEmpty()) {
      return undefined;
    }

    const item = this.#buffer[this.#readIdx];

    this.#buffer[this.#readIdx] = undefined;

    this.#readIdx = (this.#readIdx + 1) % this.#capacity;
    this.#count--;

    return item;
  }

  peek() {
    return this.isEmpty() ? undefined : this.#buffer[this.#readIdx];
  }
}
```
