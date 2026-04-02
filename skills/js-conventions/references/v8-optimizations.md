# V8 Engine Optimizations

Patterns for performance-sensitive (hot) code paths. In cold code, prefer readability.

## Object Shapes (Hidden Classes)

V8 assigns a hidden class (shape) to each object based on its property names, types, and insertion
order. Shape changes cause deoptimization.

**Rule: keep shapes stable after construction.**

**good — shape is fixed at creation**

```js
class Connection {
  constructor(host, port) {
    this.host = host;
    this.port = port;
    /**
     * placeholder, not added later
     */
    this.socket = null;
    this.connected = false;
  }
}
```

**bad — shape mutates after creation**

<!-- prettier-ignore -->
```js
const conn = { host, port };

/**
 * shape change
 */
conn.socket = net.connect(port, host);

/**
 * another shape change
 */
conn.connected = true;
```

- Initialize all fields in constructor or factory, in the same order
- Use `null` for empty reference types, `undefined` for empty primitives
- Avoid `delete obj.prop` — set to `null` or `undefined` instead
- Avoid dynamic mix-ins outside constructors/creational patterns

## Monomorphic Functions

A function is monomorphic when it always receives the same argument types and returns the same type.
V8 optimizes monomorphic call sites aggressively.

**good — always receives (number, number), returns number**

```js
const add = (a, b) => a + b;
```

**bad — polymorphic: sometimes string, sometimes number**

<!-- prettier-ignore -->
```js
/**
 * called with (1, 2) and ('a', 'b')
 */
const add = (a, b) => a + b;
```

- Keep hot functions with stable argument count, types, and return type
- Avoid reading the same property from objects with different shapes in one function
- Prefer string or number literals for status codes; avoid mixing primitives with objects

## Property Access

**good — fixed property access**

```js
const name = user.name;
```

**avoid in hot paths — dynamic key**

<!-- prettier-ignore -->
```js
const name = user[key];
```

- Prefer `obj.prop` over `obj[key]` in hot paths
- If dynamic access is needed, use `Map` instead of plain object

## Arrays

**good — dense, homogeneous**

```js
const ids = [1, 2, 3, 4, 5];
```

**bad — holey, mixed kinds**

<!-- prettier-ignore -->
```js
const data = [1, 'two', , null, { x: 3 }];
```

- Keep arrays dense — no holes (`[1, , 3]`)
- Keep element kinds consistent (all numbers OR all strings OR all objects)
- Pre-allocate with known size when possible: `new Array(n)` then fill
- Avoid array destructuring in hot loops; object destructuring is fine

## Data Structure Selection

| Need                     | Use                   | Why                               |
| ------------------------ | --------------------- | --------------------------------- |
| Dynamic key dictionary   | `Map`                 | Optimized for frequent add/delete |
| Fixed schema object      | Plain object `{}`     | V8 hidden class optimization      |
| Pure hash map (no proto) | `Object.create(null)` | No prototype chain lookups        |
| Large dynamic collection | `Set`                 | O(1) has/add/delete               |
| Small stable list        | `Array`               | Cache-friendly, low overhead      |
| Numeric/binary workload  | `TypedArray`          | No boxing, contiguous memory      |

## Loop Optimizations

**good — callback extracted, no try/catch in loop**

```js
const processItem = (item) => transform(item);

const results = [];
for (const item of items) {
  results.push(processItem(item));
}
```

**bad — inline callback recreated each iteration, try/catch inside**

<!-- prettier-ignore -->
```js
for (const item of items) {
  try {
    results.push((x) => transform(x));
  } catch (error) {
    // ...
  }
}
```

- Move reusable callbacks outside loops
- Keep `try/catch` outside hot loops (wrap the whole loop)
- Avoid spread (`...`) and rest parameters inside hot loops
- Prefer `for` or `for...of` over array methods in hot paths

## GC Pressure

- Reuse arrays, objects, and buffers instead of creating new ones each iteration
- Use object pools for frequently allocated/deallocated objects
- Avoid excessive closures in hot paths — they capture scope and prevent GC
- Use `TypedArray` for numeric workloads (no boxing overhead)
- Set references to `null` when done to help GC in long-lived scopes

## Sources

- [V8 Blog — Fast Properties](https://v8.dev/blog/fast-properties)
- [V8 Blog — Elements Kinds](https://v8.dev/blog/elements-kinds)
- [mrale.ph — What's up with Monomorphism](https://mrale.ph/blog/2015/01/11/whats-up-with-monomorphism.html)
