# Structural Patterns

Patterns that deal with object composition, creating relationships between objects to form larger
structures.

## Adapter

Converts an incompatible interface into a compatible one, enabling third-party component usage
without altering its code; can transform a function contract into an object or vice versa.

Refs: https://github.com/HowProgrammingWorks/Adapter

```javascript
const promisify =
  (fn) =>
  (...args) =>
    new Promise((resolve, reject) => {
      fn(...args, (err, data) => (err ? reject(err) : resolve(data)));
    });
```

```javascript
class ArrayToQueueAdapter {
  #array = null;

  constructor(array) {
    if (!Array.isArray(array)) {
      throw new Error('Array instance expected');
    }
    this.#array = array;
  }

  enqueue(data) {
    this.#array.push(data);
  }

  dequeue() {
    return this.#array.pop();
  }

  get count() {
    return this.#array.length;
  }
}
```

## Wrapper

Function wrapper that delegates calls and adds behavior; a specialized case of Adapter.

Refs: https://github.com/HowProgrammingWorks/Wrapper

```javascript
const withLogging =
  (fn, label) =>
  (...args) => {
    console.log(`${label} called`, args);
    const result = fn(...args);
    console.log(`${label} returned`, result);
    return result;
  };
```

Interface wrapping:

```javascript
const wrapInterface = (anInterface) => {
  const wrapped = {};
  for (const key in anInterface) {
    const fn = anInterface[key];

    wrapped[key] = wrapFunction(fn);
  }

  return wrapped;
};
```

Timeout wrapper:

```javascript
class Timeout {
  constructor(fn, msec) {
    this.function = fn;
    this.timer = setTimeout(() => {
      this.timer = null;
    }, msec);
  }

  execute(...args) {
    let result = undefined;

    if (!this.timer) {
      return result;
    }

    clearTimeout(this.timer);
    this.timer = null;
    result = this.function(...args);

    return result;
  }
}
```

## Boxing

Wraps primitives into object types to add methods or unify interfaces, e.g., narrowing `String` to
`AddressString` (Value-Object).

Refs: https://github.com/HowProgrammingWorks/ADT

```javascript
class AddressString {
  #value;

  constructor(value) {
    if (typeof value !== 'string') {
      throw new TypeError('Address must be a string');
    }
    const str = value.trim();

    if (str === '') {
      throw new TypeError('Address must be a non-empty');
    }

    this.#value = str;
  }

  get city() {
    const index = this.#value.indexOf(',');
    return this.#value.slice(0, index).trim();
  }

  toString() {
    return this.#value;
  }

  valueOf() {
    return this.#value;
  }
}

/**
 * Usage
 */
const address = new AddressString('London, 221B Baker Street');

/**
 * → 'London'
 */
address.city;
```

Value-Object with unit conversion:

```javascript
const KMH_TO_MPH = 0.621371;

class SpeedValue {
  #kmh;

  constructor(value, unit = 'kmh') {
    if (typeof value !== 'number') {
      throw new TypeError('Speed must be a number');
    }
    if (value < 0) {
      throw new TypeError('Speed must be non-negative');
    }

    if (unit !== 'kmh' && unit !== 'mph') {
      throw new TypeError('Unit must be kmh or mph');
    }

    this.#kmh = unit === 'mph' ? value / KMH_TO_MPH : value;
  }

  get kmh() {
    return this.#kmh;
  }

  get mph() {
    return this.#kmh * KMH_TO_MPH;
  }

  toString() {
    return `${this.#kmh} km/h`;
  }

  valueOf() {
    return this.#kmh;
  }
}
```

## Decorator

Dynamically extends behavior without inheritance, typically via composition and declarative syntax,
effectively adding metadata.

Refs: https://github.com/HowProgrammingWorks/Decorator

Functional decorator:

```javascript
const add = (a, b) => a + b;
const loggedAdd = withLogging(add, 'add');
```

Symbol property metadata:

```javascript
const VALIDATOR_META = Symbol('validatorMeta');

class EmailValidator {
  constructor(next) {
    this.next = next;
    this[VALIDATOR_META] = { type: 'email' };
  }
}
```

Module-local WeakMap (fully private, no shape pollution):

```javascript
const metadata = new WeakMap();

const createValidator = ({ args, meta }) => {
  const instance = new Validator(...args);
  metadata.set(instance, meta);
  return instance;
};

module.exports = { createValidator };
```

## Proxy

Controls access to an object by intercepting calls, reads, and writes; useful for lazy
initialization, caching, and security.

Refs: https://github.com/HowProgrammingWorks/Proxy

Do not use the built-in JS `Proxy` class unless a developer asks you directly because of deopts. Use
GoF Proxy instead as a container with additional behavior.

```javascript
const fs = require('node:fs');

const statistics = { bytes: 0, chunks: 0, events: {} };

class StatReadStream extends fs.ReadStream {
  emit(name, data) {
    if (name === 'data') {
      statistics.bytes += data.length;
      statistics.chunks++;
    }

    const counter = statistics.events[name] || 0;

    statistics.events[name] = counter + 1;
    super.emit(name, data);
  }
}

const getStatistics = () => structuredClone(statistics);

const createReadStream = (path, options) => new StatReadStream(path, options);

module.exports = { ...fs, createReadStream, getStatistics };
```

## Bridge

Separates two or more abstraction hierarchies via composition or aggregation, allowing them to
evolve independently.

Refs: https://github.com/HowProgrammingWorks/Bridge

```javascript
class CommunicationProtocol {
  sendCommand(device, command) {
    throw new Error('sendCommand() must be implemented');
  }
}

class MQTTProtocol extends CommunicationProtocol {
  sendCommand(device, command) {
    console.log(`[MQTT] Sending '${command}' to ${device}`);
  }
}

class HTTPProtocol extends CommunicationProtocol {
  sendCommand(device, command) {
    console.log(`[HTTP] Sending '${command}' to ${device}`);
  }
}

class IoTDevice {
  constructor(name, protocol) {
    this.name = name;
    this.protocol = protocol;
  }

  operate(command) {
    this.protocol.sendCommand(this.name, command);
  }
}

class SmartLight extends IoTDevice {
  turnOn() {
    this.operate('Turn On Light');
  }

  turnOff() {
    this.operate('Turn Off Light');
  }
}

class SmartThermostat extends IoTDevice {
  setTemperature(temp) {
    this.operate(`Set Temperature to ${temp}°C`);
  }
}
```

## Composite

Implements a common interface to uniformly handle individual objects and their tree structures,
e.g., DOM or file systems.

Refs: https://github.com/HowProgrammingWorks/Composite

```javascript
const calculateTotal = (order) => {
  const items = Array.isArray(order) ? order : Object.values(order);
  return items.reduce((sum, item) => {
    if (typeof item.price === 'number') {
      return sum + item.price;
    }

    return sum + calculateTotal(item);
  }, 0);
};
```

```javascript
const order = {
  electronics: {
    laptop: { price: 1200 },
    accessories: {
      mouse: { price: 25 },
      keyboard: { price: 75 },
    },
  },
  books: {
    fiction: { price: 15 },
    technical: { price: 60 },
  },
};

/**
 * → 1375
 */
calculateTotal(order);
```

## Facade

Simplifies access to a complex system, providing a unified and clear interface, hiding and
protecting internal complexity.

Refs: https://github.com/HowProgrammingWorks/Facade

```javascript
const createApi = (db, cache, logger) => ({
  async getUser(id) {
    const cached = cache.get(id);

    if (cached) {
      return cached;
    }

    const user = await db.row('User', ['*'], { id });
    cache.set(id, user);
    logger.info(`User ${id} loaded`);

    return user;
  },
});
```

```javascript
scheduler.task('name2', '2019-03-12T14:37Z', (done) => {
  setTimeout(() => {
    done(new Error('task failed'));
  }, 1100);
});
```

## Context

Exchanges state and dependencies between different components (abstractions, modules, layers) that
do not share a common environment, without tightly coupling them.

Refs: https://github.com/HowProgrammingWorks/Context

Class-based:

```javascript
class AccountService {
  constructor(context) {
    this.context = context;
  }

  getBalance(accountId) {
    const { console, accessPolicy, user } = this.context;
    console.log(`User ${user.name} requesting balance for ${accountId}`);
    if (!accessPolicy.check(user.role, 'read:balance')) {
      console.error('Access denied: insufficient permissions');

      return null;
    }

    return 15420.5;
  }
}

class AccessPolicy {
  constructor() {
    this.permissions = {
      admin: ['read:balance', 'read:transactions', 'write:transactions'],
      user: ['read:balance'],
      guest: [],
    };
  }

  check(role, permission) {
    return this.permissions[role]?.includes(permission);
  }
}

const accessPolicy = new AccessPolicy();
const user = { name: 'Marcus', role: 'admin' };
const context = { console, accessPolicy, user };

const accountService = new AccountService(context);

accountService.getBalance('Account-123');
```

Closure-based:

```javascript
const createAccountService = (context) => {
  const { console, accessPolicy, user } = context;

  const getBalance = (accountId) => {
    console.log(`User ${user.name} requesting balance for ${accountId}`);

    if (!accessPolicy.check(user.role, 'read:balance')) {
      console.error('Access denied: insufficient permissions');

      return null;
    }

    return 15420.5;
  };

  const getTransactions = (accountId) => {
    if (!accessPolicy.check(user.role, 'read:transactions')) {
      console.error('Access denied: insufficient permissions');

      return null;
    }

    console.log(`User ${user.name} reading transactions for ${accountId}`);

    return ['TR-123', 'TR-456', 'TR-789'];
  };

  return { getBalance, getTransactions };
};
```
