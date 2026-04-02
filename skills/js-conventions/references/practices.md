# Code Practices

Patterns and rules that improve code quality beyond what formatting covers. Apply in all new code
and refactors.

## Variable Declarations

- Prefer `const` for all bindings — use `let` only when reassignment is necessary
- Never use `var`
- Declare variables as close to first use as possible

**good**

```js
const items = fetchItems();
const count = items.length;

let index = 0;

while (index < count) {
  processItem(items[index]);
  index += 1;
}
```

**bad**

<!-- prettier-ignore -->
```js
var items = fetchItems();
/**
 * never reassigned — should be const
 */
let count = items.length;
```

## Arrow Functions

- Prefer arrow functions for all function expressions
- Use regular `function` only for: class/prototype methods, constructors, generators, and default
  exports
- Single-expression arrows: omit braces and `return`
- Multi-statement arrows: use block body

**good**

```js
const double = (x) => x * 2;

const process = (items) => {
  const filtered = items.filter((item) => item.active);

  return filtered.map((item) => item.value);
};
```

**bad — function expression without this**

<!-- prettier-ignore -->
```js
const double = function (x) {
  return x * 2;
};
```

**bad — unnecessary block body**

<!-- prettier-ignore -->
```js
const double = (x) => {
  return x * 2;
};
```

### Arrow Parens

Always use parentheses around arrow function parameters, even for a single parameter:

**good**

```js
const getName = (user) => user.name;
```

**bad**

<!-- prettier-ignore -->
```js
const getName = user => user.name;
```

## Immutability

- Do not mutate input parameters — clone or create new objects
- Avoid `arguments` — use rest parameters (`...args`)

**good**

```js
const addDefaults = (config) => ({
  timeout: 5000,
  retries: 3,
  ...config,
});
```

**bad — mutates input**

<!-- prettier-ignore -->
```js
const addDefaults = (config) => {
  config.timeout = config.timeout || 5000;
  config.retries = config.retries || 3;

  return config;
};
```

## Function Design

- Keep functions small and single-purpose
- Keep return types consistent within a function — do not return different types from different
  branches

**good — always returns a User or throws**

```js
const getUser = (id) => {
  const user = db.find(id);

  if (!user) {
    throw new Error(`User ${id} not found`);
  }

  return user;
};
```

**bad — returns User or undefined or null**

<!-- prettier-ignore -->
```js
const getUser = (id) => {
  if (!id) {
    return null;
  }

  return db.find(id);
};
```

## Expression Decomposition

- Decompose long or complex expressions into intermediate variables with descriptive names
- Avoid nested ternaries

**good**

```js
const isEligible = age >= 18 && hasConsent;
const discount = isEligible ? ELIGIBLE_DISCOUNT : DEFAULT_DISCOUNT;
const finalPrice = basePrice * (1 - discount);
```

**bad**

<!-- prettier-ignore -->
```js
const finalPrice = basePrice * (1 - (age >= 18 && hasConsent ? 0.2 : 0));
```

## Equality and Coercion

- Always use strict equality (`===`, `!==`)
- Exception: `== null` is allowed (checks both `null` and `undefined`)
- No implicit type coercion — use explicit conversion functions

**good**

```js
if (value === '') { ... }
if (value == null) { ... }
const count = Number(input);
```

**bad**

<!-- prettier-ignore -->
```js
if (value == '') { ... }
/**
 * falsy check when you mean empty string
 */
if (!value) { ... }
const count = +input;
```

## Control Flow

### Curly Braces

Always use curly braces for all control flow statements — no single-line exceptions:

**good**

```js
if (ready) {
  start();
}
```

**bad**

<!-- prettier-ignore -->
```js
if (ready) start();
```

### Switch/Case Braces

Every `case` and `default` clause must be wrapped in braces to prevent scope issues with
`let`/`const`:

**good**

```js
switch (action) {
  case 'start': {
    const timer = createTimer();
    timer.start();

    break;
  }
  default: {
    log('unknown action');
  }
}
```

**bad**

<!-- prettier-ignore -->
```js
switch (action) {
  case 'start':
    const timer = createTimer();
    timer.start();
    break;
}
```

### Default Case

Switch statements must include a `default` case, placed last.

## Iteration

- Use `.map`, `.filter`, `.reduce` when they improve readability and produce a value
- Avoid `.forEach` when the callback operates on outer context — use `for...of` instead
- Prefer explicit loops (`for`, `for...of`) in performance-sensitive paths

**good — transform produces a value**

```js
const names = users.map((user) => user.name);
const active = users.filter((user) => user.isActive);
```

**good — side effect, use for...of**

```js
for (const user of users) {
  await sendNotification(user);
}
```

**bad — forEach with side effects on outer scope**

<!-- prettier-ignore -->
```js
let total = 0;

users.forEach((user) => {
  total += user.balance;
});
```

## Self-Documenting Code

- Write code that is clear without comments
- Do not add obvious comments that restate the code
- Comments should explain _why_, not _what_
- Use descriptive names instead of comments

**good — name explains intent**

```js
const isExpired = expiresAt < Date.now();
```

**bad — comment restates code**

<!-- prettier-ignore -->
```js
/**
 * Check if expired
 */
const isExpired = expiresAt < Date.now();
```

## Console Usage

- `console.log` triggers a warning — use it only for debugging, remove before commit
- `console.warn` and `console.error` are allowed for legitimate runtime warnings and errors
