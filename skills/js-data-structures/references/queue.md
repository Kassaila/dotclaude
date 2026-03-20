# Queue

Common use cases:
- **FE**: analytics event batching, animation queues, sequential toast notifications, rate-limited requests
- **BE**: job/task queues, message processing, request throttling, email sending pipeline, webhook delivery

## mnemonist (preferred)

```javascript
import Queue from 'mnemonist/queue';

const q = new Queue();

q.enqueue('task-1');
q.enqueue('task-2');
q.dequeue(); // 'task-1'
q.peek();    // 'task-2'
q.size;      // 1
```

For double-ended queue with fixed capacity: `import FixedDeque from 'mnemonist/fixed-deque'`.

## Manual fallback (Array + offset)

```javascript
class Queue {
  #buffer = [];
  #offset = 0;

  enqueue(item) {
    this.#buffer.push(item);
  }

  dequeue() {
    if (this.#offset >= this.#buffer.length) {
      return undefined;
    }

    const item = this.#buffer[this.#offset];

    this.#buffer[this.#offset++] = undefined; // GC

    if (this.#offset > this.#buffer.length >>> 1) {
      this.#buffer = this.#buffer.slice(this.#offset);
      this.#offset = 0;
    }

    return item;
  }

  get size() {
    return this.#buffer.length - this.#offset;
  }

  peek() {
    if (this.#offset >= this.#buffer.length) {
      return undefined;
    }

    return this.#buffer[this.#offset];
  }

  isEmpty() {
    return this.size === 0;
  }
}
```
