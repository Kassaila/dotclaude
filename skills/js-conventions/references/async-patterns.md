# Async Patterns

Conventions for asynchronous code in JavaScript and TypeScript. Apply to both Node.js and browser
environments.

## Prefer async/await

- Use `async`/`await` over raw `.then()`/`.catch()` chains
- Exception: simple one-liner transforms where `.then()` is clearer

**good**

```js
const fetchUser = async (id) => {
  const response = await fetch(`/api/users/${id}`);
  const user = await response.json();

  return user;
};
```

**bad — unnecessary chaining**

<!-- prettier-ignore -->
```js
const fetchUser = (id) =>
  fetch(`/api/users/${id}`)
    .then((response) => response.json())
    .then((user) => user);
```

**acceptable — simple transform**

```js
const fetchUserName = (id) => fetchUser(id).then((user) => user.name);
```

## Error Handling

- Always handle errors from async operations — unhandled promise rejections crash Node.js
- Use `try`/`catch` at the appropriate scope — not inside every function
- Re-throw or wrap errors with context when catching in intermediate layers

**good — catch at the boundary**

```js
const loadDashboard = async () => {
  try {
    const user = await fetchUser(userId);
    const stats = await fetchStats(user.id);

    return { user, stats };
  } catch (error) {
    logger.error('Dashboard load failed', { error, userId });

    throw error;
  }
};
```

**bad — silently swallowing errors**

<!-- prettier-ignore -->
```js
const loadDashboard = async () => {
  try {
    const user = await fetchUser(userId);

    return { user };
  } catch (error) {
    return null;
  }
};
```

## Floating Promises

- Every promise must be awaited, returned, or explicitly voided
- Use `void` prefix for fire-and-forget promises (when intentional)

**good**

```js
await sendAnalytics(event);
```

**good — explicit fire-and-forget**

```js
void sendAnalytics(event);
```

**bad — floating promise**

<!-- prettier-ignore -->
```js
sendAnalytics(event);
```

## Sequential vs Parallel

- Use sequential `await` when operations depend on each other
- Use `Promise.all` when operations are independent
- Use `Promise.allSettled` when you need all results regardless of individual failures

**good — parallel, independent**

```js
const [users, products] = await Promise.all([fetchUsers(), fetchProducts()]);
```

**good — sequential, dependent**

```js
const user = await fetchUser(id);
const orders = await fetchOrders(user.accountId);
```

**bad — sequential when parallel is possible**

<!-- prettier-ignore -->
```js
const users = await fetchUsers();
const products = await fetchProducts();
```

## Promise.all Error Handling

- `Promise.all` rejects on first failure — use when all-or-nothing is needed
- `Promise.allSettled` when partial results are acceptable

```js
/**
 * all-or-nothing
 */
const [users, config] = await Promise.all([fetchUsers(), fetchConfig()]);

/**
 * partial results acceptable
 */
const results = await Promise.allSettled([
  fetchPrimaryData(),
  fetchSecondaryData(),
  fetchOptionalData(),
]);

const succeeded = results.filter((r) => r.status === 'fulfilled').map((r) => r.value);
```

## AbortController

- Use `AbortController` for cancellable operations (fetch, timers, streams)
- Pass `signal` through the call chain — do not create new controllers at each level
- Clean up abort controllers to avoid memory leaks

**good — cancellable fetch**

```js
const fetchWithTimeout = async (url, timeoutMs) => {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url, { signal: controller.signal });

    return await response.json();
  } finally {
    clearTimeout(timeoutId);
  }
};
```

**good — pass signal through**

```js
const loadData = async (signal) => {
  const response = await fetch('/api/data', { signal });

  return response.json();
};
```

## Async Iteration

- Use `for await...of` for async iterables (streams, async generators)
- Do not mix `for await` with synchronous iterables

**good**

```js
const processStream = async (stream) => {
  for await (const chunk of stream) {
    await handleChunk(chunk);
  }
};
```

## Top-Level Await

- Top-level `await` is allowed in ES modules (`.mjs`, or `.js` with `"type": "module"`)
- Use for module initialization: config loading, DB connection, cache warm-up
- Keep top-level await minimal — long-running operations delay module loading

**good — module initialization**

```js
const config = await loadConfig();
const db = await connectDatabase(config.dbUrl);

export { config, db };
```

## Misused Promises

- Do not pass async functions where a sync callback is expected (unless the caller handles it)
- Array methods (`.map`, `.filter`, `.forEach`) do not await async callbacks

**good — explicit Promise.all**

```js
const results = await Promise.all(
  items.map(async (item) => {
    const data = await fetchData(item.id);

    return transform(data);
  }),
);
```

**bad — forEach does not await**

<!-- prettier-ignore -->
```js
items.forEach(async (item) => {
  await processItem(item);
});
```

**good — for...of for sequential async**

```js
for (const item of items) {
  await processItem(item);
}
```
