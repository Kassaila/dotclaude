# Creational Patterns

Patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to
the situation.

## Abstract Factory

Creates related objects belonging to one family without specifying their concrete classes, e.g., UI
components for different platforms.

Refs: https://github.com/HowProgrammingWorks/AbstractFactory

```javascript
const dataAccess = {
  fs: {
    createDatabase: (...args) => new FileStorage(...args),
    createCursor: (...args) => new FileLineCursor(...args),
  },
  minio: {
    createDatabase: (...args) => new MinioStorage(...args),
    createCursor: (...args) => new MinioCursor(...args),
  },
};

/**
 * Usage — switch implementation by key
 */
const accessLayer = dataAccess.fs;
const storage = accessLayer.createDatabase('./storage.dat');
const cursor = accessLayer.createCursor({ city: 'Roma' }, storage);
for await (const record of cursor) {
  console.dir(record);
}
```

## Builder

Step-by-step assembly of a complex configurable object, often using chaining, e.g., Query Builder or
Form Generator.

Refs: https://github.com/HowProgrammingWorks/Builder

```javascript
class QueryBuilder {
  #options;

  constructor(table) {
    this.#options = { table, where: {}, limit: null, order: null };
  }

  where(cond) {
    Object.assign(this.#options.where, cond);
    return this;
  }

  order(field) {
    this.#options.order = field;
    return this;
  }

  limit(n) {
    this.#options.limit = n;
    return this;
  }

  build() {
    return { ...this.#options };
  }
}
```

```javascript
const query = new QueryBuilder('User').where({ active: true }).order('name').limit(10).build();
```

Alternatively, use a declarative structure:

```javascript
const query = await new QueryBuilder({
  entity: 'User',
  where: { active: true },
  order: 'name',
  limit: 10,
});
```

## Factory

Function or method that creates objects using different techniques: assembling from literals and
methods, mixins, `setPrototypeOf`.

Refs: https://github.com/HowProgrammingWorks/Factory

```javascript
const createUser = (name, role) => ({ name, role, createdAt: Date.now() });
const createAdmin = (name) => createUser(name, 'admin');
```

```javascript
class Connection {
  constructor(url) {
    /* implementation */
  }
}

const factory = (() => {
  let index = 0;

  return () => new Connection(`http://10.0.0.1/${index++}`);
})();
```

## Factory Method

Chooses the correct abstraction to create an instance; in JavaScript, this can be implemented using
`if`, `switch`, or selection from a collection (dictionary).

Refs: https://github.com/HowProgrammingWorks/FactoryMethod

```javascript
class Person {
  constructor(name) {
    this.name = name;
  }

  static factory(name) {
    return new Person(name);
  }
}
```

```javascript
class Product {
  constructor(value) {
    this.field = value;
  }
}

class Creator {
  factoryMethod(...args) {
    return new Product(...args);
  }
}
```

## Prototype

Creates objects by cloning a prepared instance to save resources (not to be confused with
prototype-based programming, which is closer to Flyweight).

Refs: https://github.com/HowProgrammingWorks/PrototypePattern

```javascript
const proto = { type: 'widget', color: 'blue' };
const clone = () => ({ ...proto });
```

Class-based with deep clone:

```javascript
class Point {
  #x;
  #y;

  constructor(x, y) {
    this.#x = x;
    this.#y = y;
  }

  move(x, y) {
    this.#x += x;
    this.#y += y;
  }

  clone() {
    return new Point(this.#x, this.#y);
  }
}

class Line {
  #start;
  #end;

  constructor(start, end) {
    this.#start = start;
    this.#end = end;
  }

  move(x, y) {
    this.#start.move(x, y);
    this.#end.move(x, y);
  }

  clone() {
    const start = this.#start.clone();
    const end = this.#end.clone();
    return new Line(start, end);
  }
}
```

Closure-based:

```javascript
const point = (x, y) => {
  const move = (dx, dy) => {
    x += dx;
    y += dy;
  };
  const clone = () => point(x, y);
  return { move, clone };
};
```

## Flyweight

Saves memory allocation by sharing common state among multiple instances.

Refs: https://github.com/HowProgrammingWorks/Flyweight

```javascript
const flyweightPool = new Map();

const getFlyweight = (shared) => {
  const { char, font, size } = shared;
  const key = `${char}:${font}:${size}`;
  let flyweight = flyweightPool.get(key);

  if (!flyweight) {
    flyweight = Object.freeze({ ...shared });
    flyweightPool.set(key, flyweight);
  }

  return flyweight;
};

const createChar = (char, font, size, row, col) => {
  const intrinsic = getFlyweight({ char, font, size });
  return { intrinsic, row, col };
};

const a1 = createChar('A', 'Arial', 12, 0, 0);
const a2 = createChar('A', 'Arial', 12, 0, 5);

/**
 * → true (shared intrinsic state)
 */
console.log(a1.intrinsic === a2.intrinsic);
```

## Singleton

Provides global access to a single instance; often considered an anti-pattern, easiest implemented
via ESM/CJS module caching exported refs.

Refs: https://github.com/HowProgrammingWorks/Singleton

Module-level shared state (preferred in JavaScript):

```javascript
const connections = new Map();
module.exports = { connections };
```

Class with static instance:

```javascript
class Singleton {
  static #instance;

  constructor() {
    const instance = Singleton.#instance;

    if (instance) {
      return instance;
    }

    Singleton.#instance = this;
  }
}
```

Closure-based:

```javascript
const singleton = (() => {
  const instance = {};
  return () => instance;
})();
```

## Object Pool

Reuses pre-created objects to save resources during frequent creation and destruction.

Refs: https://github.com/HowProgrammingWorks/Pool

```javascript
class Pool {
  #available = [];
  #factory = null;

  constructor(factory, size) {
    this.#factory = factory;
    for (let i = 0; i < size; i++) {
      this.#available.push(factory());
    }
  }

  acquire() {
    return this.#available.pop() || this.#factory();
  }

  release(obj) {
    this.#available.push(obj);
  }
}
```
