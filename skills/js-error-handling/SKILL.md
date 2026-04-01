---
name: js-error-handling
description: Apply error handling and recovery patterns in JavaScript/TypeScript — Node.js and browser. Use when implementing error handling, retry logic, domain errors, error boundaries, global error handlers, or error recovery/escalation.
---

# JS Error Handling

## Error classification

- **Programming errors**: Bugs (TypeError, ReferenceError, assertion failures). Fix the code; do not catch and continue
- **Operational errors**: Expected failures (network timeout, file not found, invalid input, permission denied). Handle gracefully with recovery, escalation, user notification, or logging

Only recover from operational errors. Programming errors indicate broken invariants — crashing (Node.js) or bubbling to error boundary (browser) is the correct response.

## Common conventions

- Distinguish programmer vs operational errors; only recover from operational
- Never swallow errors silently; always log or propagate
- Use structured error classes with codes for API/domain boundaries
- Prefer early return / guard clauses over deeply nested try/catch
- Keep try blocks small — wrap only the throwing call, not surrounding logic
- Rethrow unknown errors; only catch what you know how to handle

## Sync error handling

```javascript
try {
  const result = parse(input);
  return result;
} catch (error) {
  console.error({ error });
  return defaultValue;
}
```

## Async error handling

```javascript
try {
  const data = await fetchData(url);
  return data;
} catch (error) {
  if (error.code === 'ECONNREFUSED') return fallback();
  throw error;
}
```

## Custom error class

```javascript
class AppError extends Error {
  constructor(message, code, options) {
    super(message, options);
    this.name = 'AppError';
    this.code = code;
  }
}
```

## Reference files

Pattern details and code examples are in `references/`:

- `references/common-patterns.md` — retry with backoff, timeout, AbortController, error aggregation, centralized error handler
- `references/node-patterns.md` — Node.js: process handlers, graceful shutdown, streams, server error middleware
- `references/fe-patterns.md` — browser: global handlers, error boundaries (React/Vue/Svelte), fallback UI, error reporting
- `references/domain-error.md` — DomainError class, error propagation across layers, API error mapping
