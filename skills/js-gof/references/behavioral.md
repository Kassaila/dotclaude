# Behavioral Patterns

Patterns that deal with communication between objects, defining how they interact and distribute
responsibility.

## Chain of Responsibility

Passes a request along a chain of handlers until one processes it; in JavaScript, commonly seen in
middleware pipelines (Express, Koa).

Refs: https://github.com/HowProgrammingWorks/ChainOfResponsibility

Functional pipeline:

```javascript
const createChain = (...handlers) => {
  const execute = async (context) => {
    for (const handler of handlers) {
      const result = await handler(context);

      if (result !== undefined) {
        return result;
      }
    }

    return null;
  };

  return execute;
};

const authHandler = (ctx) => {
  if (!ctx.token) {
    return { status: 401, message: 'Unauthorized' };
  }
};

const roleHandler = (ctx) => {
  if (ctx.role !== 'admin') {
    return { status: 403, message: 'Forbidden' };
  }
};

const dataHandler = (ctx) => ({ status: 200, data: ctx.payload });

const chain = createChain(authHandler, roleHandler, dataHandler);
```

Middleware-style with `next`:

```javascript
const createPipeline = (...middlewares) => {
  const execute = (context) => {
    let index = 0;

    const next = () => {
      const mw = middlewares[index++];

      if (mw) {
        return mw(context, next);
      }
    };

    return next();
  };

  return execute;
};

const logger = (ctx, next) => {
  console.log(`${ctx.method} ${ctx.url}`);

  return next();
};

const timer = (ctx, next) => {
  const start = performance.now();
  const result = next();

  console.log(`Duration: ${performance.now() - start}ms`);

  return result;
};

const handler = (ctx) => ({ status: 200, body: 'OK' });

const pipeline = createPipeline(logger, timer, handler);
```

## Command

Encapsulates a request as an object, enabling undo/redo, queuing, and logging.

Refs: https://github.com/HowProgrammingWorks/Command

```javascript
class CommandManager {
  #history = [];
  #undone = [];

  execute(command) {
    command.execute();
    this.#history.push(command);
    this.#undone.length = 0;
  }

  undo() {
    const command = this.#history.pop();

    if (!command) {
      return;
    }

    command.undo();
    this.#undone.push(command);
  }

  redo() {
    const command = this.#undone.pop();

    if (!command) {
      return;
    }

    command.execute();
    this.#history.push(command);
  }
}
```

```javascript
const createMoveCommand = (entity, dx, dy) => ({
  execute() {
    entity.x += dx;
    entity.y += dy;
  },
  undo() {
    entity.x -= dx;
    entity.y -= dy;
  },
});

const manager = new CommandManager();
const player = { x: 0, y: 0 };

manager.execute(createMoveCommand(player, 10, 5));
manager.execute(createMoveCommand(player, -3, 7));

/**
 * → { x: 7, y: 12 }
 */
console.log(player);

manager.undo();

/**
 * → { x: 10, y: 5 }
 */
console.log(player);
```

## Iterator

Provides sequential access to elements without exposing the underlying structure; JavaScript has
built-in `Symbol.iterator` and `Symbol.asyncIterator` protocols.

Refs: https://github.com/HowProgrammingWorks/Iterator

Custom iterable:

```javascript
class Range {
  #start;
  #end;

  constructor(start, end) {
    this.#start = start;
    this.#end = end;
  }

  [Symbol.iterator]() {
    let current = this.#start;
    const end = this.#end;
    return {
      next() {
        if (current <= end) {
          return { value: current++, done: false };
        }

        return { done: true };
      },
    };
  }
}

/**
 * → 1 2 3 4 5
 */
for (const n of new Range(1, 5)) {
  console.log(n);
}
```

Async iterator:

```javascript
const createPollingIterator = (fn, interval) => ({
  [Symbol.asyncIterator]() {
    return {
      async next() {
        await new Promise((r) => setTimeout(r, interval));
        const value = await fn();
        return { value, done: false };
      },
    };
  },
});

const poller = createPollingIterator(() => fetch('/api/status').then((r) => r.json()), 5000);

for await (const status of poller) {
  console.log(status);

  if (status.complete) {
    break;
  }
}
```

Generator-based:

```javascript
function* paginate(fetchPage) {
  let page = 1;
  while (true) {
    const items = fetchPage(page++);

    if (items.length === 0) {
      return;
    }
    yield* items;
  }
}
```

## Mediator

Centralizes communication between objects, reducing direct dependencies; in JavaScript, often
implemented via an event bus or message broker.

Refs: https://github.com/HowProgrammingWorks/Mediator

```javascript
class Mediator {
  #channels = new Map();

  subscribe(channel, handler) {
    if (!this.#channels.has(channel)) {
      this.#channels.set(channel, new Set());
    }

    this.#channels.get(channel).add(handler);

    return () => this.#channels.get(channel).delete(handler);
  }

  publish(channel, data) {
    const handlers = this.#channels.get(channel);

    if (!handlers) {
      return;
    }

    for (const handler of handlers) {
      handler(data);
    }
  }
}

const mediator = new Mediator();

const unsubscribe = mediator.subscribe('order:created', (order) => {
  console.log(`Inventory updated for order ${order.id}`);
});

mediator.subscribe('order:created', (order) => {
  console.log(`Email sent for order ${order.id}`);
});

mediator.publish('order:created', { id: 'ORD-001', total: 99.9 });

unsubscribe();
```

## Memento

Captures and restores an object's state without exposing its internals; useful for undo, snapshots,
and time-travel debugging.

Refs: https://github.com/HowProgrammingWorks/Memento

```javascript
class Editor {
  #content = '';

  type(text) {
    this.#content += text;
  }

  getContent() {
    return this.#content;
  }

  save() {
    return Object.freeze({ content: this.#content });
  }

  restore(memento) {
    this.#content = memento.content;
  }
}
```

```javascript
class History {
  #snapshots = [];

  push(memento) {
    this.#snapshots.push(memento);
  }

  pop() {
    return this.#snapshots.pop();
  }
}

const editor = new Editor();
const history = new History();

editor.type('Hello');
history.push(editor.save());

editor.type(' World');
history.push(editor.save());

editor.type('!!!');

/**
 * → 'Hello World!!!'
 */
editor.getContent();

editor.restore(history.pop());

/**
 * → 'Hello World'
 */
editor.getContent();
```

## Observer

Notifies dependents of state changes; JavaScript has built-in `EventEmitter` (Node.js) and
`EventTarget` (browser) implementations.

Refs: https://github.com/HowProgrammingWorks/Observer

Using EventEmitter:

```javascript
const { EventEmitter } = require('node:events');

class Store extends EventEmitter {
  #state;

  constructor(initial) {
    super();
    this.#state = initial;
  }

  getState() {
    return this.#state;
  }

  setState(updater) {
    const prev = this.#state;
    this.#state = typeof updater === 'function' ? updater(prev) : updater;
    this.emit('change', this.#state, prev);
  }
}

const store = new Store({ count: 0 });

store.on('change', (state, prev) => {
  console.log(`Changed: ${prev.count} → ${state.count}`);
});

store.setState((s) => ({ count: s.count + 1 }));
```

Using EventTarget (platform-agnostic):

```javascript
class StateEvent extends Event {
  constructor(state) {
    super('change');
    this.state = state;
  }
}

class ObservableStore extends EventTarget {
  #state;

  constructor(initial) {
    super();
    this.#state = initial;
  }

  getState() {
    return this.#state;
  }

  setState(value) {
    this.#state = value;
    this.dispatchEvent(new StateEvent(value));
  }
}
```

Minimal implementation without inheritance:

```javascript
const createObservable = (initial) => {
  let state = initial;
  const listeners = new Set();
  return {
    getState: () => state,
    setState(value) {
      state = value;

      for (const fn of listeners) {
        fn(state);
      }
    },
    subscribe(fn) {
      listeners.add(fn);
      return () => listeners.delete(fn);
    },
  };
};
```

## State

Alters behavior when internal state changes, avoiding conditional branching; implemented via
object/Map lookup or separate state objects.

Refs: https://github.com/HowProgrammingWorks/State

Map-based dispatch:

```javascript
const states = {
  idle: {
    start: (ctx) => {
      ctx.timer = performance.now();
      return 'running';
    },
  },
  running: {
    pause: () => 'paused',
    stop: (ctx) => {
      ctx.elapsed = performance.now() - ctx.timer;
      return 'idle';
    },
  },
  paused: {
    resume: () => 'running',
    stop: (ctx) => {
      ctx.elapsed = performance.now() - ctx.timer;
      return 'idle';
    },
  },
};

class StateMachine {
  #state;
  #context;

  constructor(initial, context = {}) {
    this.#state = initial;
    this.#context = context;
  }

  get state() {
    return this.#state;
  }

  transition(action) {
    const handler = states[this.#state]?.[action];

    if (!handler) {
      throw new Error(`Invalid: ${action} in state ${this.#state}`);
    }

    this.#state = handler(this.#context);

    return this.#state;
  }
}

const machine = new StateMachine('idle');

machine.transition('start');

/**
 * → 'running'
 */
machine.state;

machine.transition('pause');

/**
 * → 'paused'
 */
machine.state;
```

## Strategy

Defines interchangeable algorithms selected at runtime; in JavaScript, use object/Map lookup or pass
functions directly.

Refs: https://github.com/HowProgrammingWorks/Strategy

Object lookup:

```javascript
const compressionStrategies = {
  gzip: (data) => gzipCompress(data),
  brotli: (data) => brotliCompress(data),
  none: (data) => data,
};

const compress = (data, algorithm = 'gzip') => {
  const strategy = compressionStrategies[algorithm];

  if (!strategy) {
    throw new Error(`Unknown algorithm: ${algorithm}`);
  }

  return strategy(data);
};
```

Function injection:

```javascript
const createSorter = (comparator) => (items) => [...items].sort(comparator);

const byName = (a, b) => a.name.localeCompare(b.name);
const byDate = (a, b) => a.date - b.date;
const byPriority = (a, b) => a.priority - b.priority;

const sortByName = createSorter(byName);
const sortByDate = createSorter(byDate);
```

Map-based with dynamic registration:

```javascript
const validators = new Map();

validators.set('email', (value) => /^[^@]+@[^@]+\.[^@]+$/.test(value));
validators.set('phone', (value) => /^\+?\d{10,15}$/.test(value));
validators.set('url', (value) => URL.canParse(value));

const validate = (type, value) => {
  const validator = validators.get(type);

  if (!validator) {
    throw new Error(`No validator for: ${type}`);
  }

  return validator(value);
};
```

## Template Method

Defines an algorithm skeleton with customizable steps; in JavaScript, prefer composition with
callbacks or configuration objects over class inheritance.

Refs: https://github.com/HowProgrammingWorks/TemplateMethod

Composition-based:

```javascript
const createDataPipeline = ({ fetch, transform, validate, save }) => {
  const execute = async (source) => {
    const raw = await fetch(source);
    const data = transform(raw);

    if (!validate(data)) {
      throw new Error('Validation failed');
    }

    return save(data);
  };
  return execute;
};

const userPipeline = createDataPipeline({
  fetch: (url) => fetch(url).then((r) => r.json()),
  transform: (data) => data.map(({ name, email }) => ({ name, email })),
  validate: (users) => users.every((u) => u.email),
  save: (users) => db.insert('users', users),
});
```

Class-based with hook methods:

```javascript
class Report {
  generate() {
    const data = this.fetchData();
    const formatted = this.format(data);

    return this.output(formatted);
  }

  /**
   * override in subclass
   */
  fetchData() {
    throw new Error('fetchData() must be implemented');
  }

  format(data) {
    return data;
  }

  output(content) {
    return content;
  }
}

class SalesReport extends Report {
  fetchData() {
    return db.query('SELECT * FROM sales');
  }

  format(data) {
    return data.map((row) => `${row.product}: $${row.total}`).join('\n');
  }
}
```

## Visitor

Adds operations to objects without modifying their classes; in JavaScript, use a dispatch table
keyed by type.

Refs: https://github.com/HowProgrammingWorks/Visitor

Dispatch table:

```javascript
const visitors = {
  text: (node) => node.content.length,
  image: (node) => node.width * node.height,
  video: (node) => node.duration,
};

const visit = (node) => {
  const visitor = visitors[node.type];

  if (!visitor) {
    throw new Error(`No visitor for: ${node.type}`);
  }

  return visitor(node);
};

const nodes = [
  { type: 'text', content: 'Hello World' },
  { type: 'image', width: 800, height: 600 },
  { type: 'video', duration: 120 },
];

const results = nodes.map(visit);

/**
 * → [11, 480000, 120]
 */
console.log(results);
```

Composable visitors:

```javascript
const createVisitor = (handlers) => (node) => {
  const handler = handlers[node.type];

  if (!handler) {
    throw new Error(`Unhandled type: ${node.type}`);
  }

  return handler(node);
};

const sizeVisitor = createVisitor({
  file: (node) => node.size,
  directory: (node) => node.children.reduce((sum, c) => sum + visit(c), 0),
});
```

## Revealing Constructor

Exposes privileged capabilities only during construction; the constructor receives a callback that
has access to internals not available after creation. The canonical example is `Promise`.

```javascript
class SecureChannel {
  #send;
  #close;

  constructor(executor) {
    this.#send = (data) => {
      console.log('Sending:', data);
    };

    this.#close = () => {
      console.log('Channel closed');
      this.#send = () => {
        throw new Error('Channel is closed');
      };
    };

    executor(this.#send, this.#close);
  }
}

/**
 * send and close are only available inside the executor
 */
const channel = new SecureChannel((send, close) => {
  send('Hello');
  setTimeout(() => close(), 5000);
});
```

Promise is the canonical example:

```javascript
const deferred = () => {
  let resolve, reject;

  const promise = new Promise((res, rej) => {
    resolve = res;
    reject = rej;
  });

  return { promise, resolve, reject };
};
```
