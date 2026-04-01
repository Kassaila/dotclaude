# Common Patterns

Patterns applicable to both Node.js and browser environments.

## Retry with exponential backoff

Use for transient failures: network errors, rate limits, DB connection timeouts.
Do not retry on 4xx (client errors) — they will fail again.

```javascript
const retry = async (fn, { attempts = 3, delay = 1000 } = {}) => {
  for (let i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === attempts - 1) throw error;
      await new Promise((r) => setTimeout(r, delay * 2 ** i));
    }
  }
};
```

## Timeout wrapper

Prevent hanging on calls that never resolve.

```javascript
const withTimeout = (promise, ms) =>
  Promise.race([
    promise,
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error(`Timeout after ${ms}ms`)), ms)
    ),
  ]);
```

## AbortController for cancellation

Cancel fetch, streams, or custom async operations. Works in Node.js 16+ and all modern browsers.

```javascript
const controller = new AbortController();
const timeout = setTimeout(() => controller.abort(), 5000);

try {
  const res = await fetch(url, { signal: controller.signal });
  return await res.json();
} catch (error) {
  if (error.name === 'AbortError') return fallback();
  throw error;
} finally {
  clearTimeout(timeout);
}
```

## Error aggregation

When running parallel operations, collect all errors instead of failing on first.

```javascript
const results = await Promise.allSettled(tasks.map(fn));

const errors = results
  .filter((r) => r.status === 'rejected')
  .map((r) => r.reason);

if (errors.length) throw new AggregateError(errors, 'Partial failure');
```

## Centralized error handler

Single place for logging, reporting, and user-facing messages. Avoids scattered error logic.

```javascript
class ErrorHandler {
  constructor(options = {}) {
    this.logger = options.logger || console;
    this.onError = options.onError;
  }

  handle(error, context = {}) {
    this.logger.error('Error:', { message: error.message, ...context });
    this.onError?.(error, context);
    return this.getUserMessage(error);
  }

  getUserMessage(error) {
    if (error instanceof APIError) {
      const messages = {
        404: 'The requested resource was not found',
        401: 'Please log in to continue',
        403: 'You do not have permission to access this',
        500: 'Server error — please try again later',
      };
      return messages[error.status] || error.message || 'Something went wrong';
    }
    if (error.code === 'NETWORK_ERROR') return 'Network connection failed';
    return 'An unexpected error occurred';
  }
}
```

## Sources

- [Error Handling — Frontend Patterns](https://frontendpatterns.dev/error-handling/) — centralized handler, retry, timeout, graceful degradation
- [MDN — AbortController](https://developer.mozilla.org/en-US/docs/Web/API/AbortController)
- [MDN — Promise.allSettled](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled)
- [MDN — AggregateError](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AggregateError)
