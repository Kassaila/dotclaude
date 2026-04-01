# Node.js Error Patterns

## Four error delivery mechanisms

1. **Exceptions** — synchronous `throw` / `try-catch`
2. **Error-first callbacks** — `callback(err, result)` convention
3. **Promise rejections** — `.catch()` or `try-catch` with `await`
4. **EventEmitter 'error'** — unhandled `'error'` event crashes the process; always attach a listener

```javascript
const emitter = new EventEmitter();
emitter.on('error', (err) => console.error('Emitter error:', err));
```

## Process-level handlers

Register both at application entry point. `uncaughtException` means corrupted state — log and exit.
Do not attempt complex recovery; let process monitors (systemd, Kubernetes, Docker) handle restarts.

```javascript
process.on('uncaughtException', (error) => {
  console.error('Uncaught:', error);
  server.close(() => process.exit(1));
  setTimeout(() => process.abort(), 1000).unref();
});

process.on('unhandledRejection', (reason) => {
  console.error('Unhandled rejection:', reason);
});
```

`unhandledRejection` is a bug to fix but does not necessarily corrupt state. Both events should trigger
logging and alerting.

## Custom error classes

Use `isOperational` flag to distinguish recoverable errors from bugs at the handler level.

```javascript
class AppError extends Error {
  constructor(message, { code, isOperational = true, cause } = {}) {
    super(message, { cause });
    this.name = this.constructor.name;
    this.code = code;
    this.isOperational = isOperational;
  }
}

class ValidationError extends AppError {
  constructor(message, cause) {
    super(message, { code: 'EVALIDATION', cause });
  }
}
```

## Graceful shutdown

Stop accepting connections → drain in-flight requests → release resources → exit.

```javascript
const shutdown = () => {
  server.close(() => {
    freeResources(); // DB pools, brokers, file handles
    process.exit(0);
  });

  // Node.js 18.2+: close idle keep-alive sockets immediately
  server.closeIdleConnections();

  // Force exit after grace period
  setTimeout(() => {
    server.closeAllConnections();
    process.exit(1);
  }, 10_000).unref();
};

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
```

Key points:
- `server.closeIdleConnections()` (Node.js 18.2+) destroys idle keep-alive sockets while preserving active requests
- `server.closeAllConnections()` — forceful fallback after timeout
- Node.js 19+: `server.close()` handles idle connections automatically
- Always set a force-exit timeout to prevent indefinite hangs

## Express/Fastify error middleware

Express — error middleware must have 4 parameters. Place after all routes.

```javascript
// Express
app.use((err, req, res, next) => {
  console.error(err);
  const status = err.isOperational ? (err.status ?? 400) : 500;
  res.status(status).json({ error: err.message });
});

// Fastify — setErrorHandler scopes to plugin context
fastify.setErrorHandler((error, request, reply) => {
  request.log.error(error);
  reply.status(error.statusCode ?? 500).send({ error: error.message });
});
```

## Stream errors

Unhandled stream errors crash the process. Use `pipeline()` — it propagates errors and cleans up
automatically.

```javascript
import { pipeline } from 'node:stream/promises';

try {
  await pipeline(readable, transform, writable);
} catch (error) {
  console.error('Stream pipeline failed:', error);
}
```

## Sources

- [A Comprehensive Guide to Error Handling in Node.js — Honeybadger](https://www.honeybadger.io/blog/errors-nodejs/) — four error delivery mechanisms, custom error classes, EventEmitter errors
- [Don't Just Pull the Plug: The Art of Graceful Shutdown — Node Vibe](https://nodevibe.substack.com/p/dont-just-pull-the-plug-the-art-of) — closeIdleConnections, connection draining, resource cleanup ordering
- [Let It Crash: Best Practices for Handling Node.js Errors on Shutdown — Heroku](https://www.heroku.com/blog/best-practices-nodejs-errors/) — let-it-crash philosophy, process monitors, when to exit vs continue
- [Node.js Best Practices — Yoni Goldberg](https://github.com/goldbergyoni/nodebestpractices) — centralized error handling, isOperational pattern
- [Node.js Errors documentation](https://nodejs.org/api/errors.html)
- [Express — Error handling](https://expressjs.com/en/guide/error-handling.html)
- [Fastify Error Handlers — Manuel Spigolon](https://dev.to/eomm/fastify-error-handlers-53ol) — setErrorHandler scoping, plugin error encapsulation
- [Node.js Stream API — pipeline](https://nodejs.org/api/stream.html#streampipelinesource-transforms-destination-callback)
