# DomainError & Error Propagation

## DomainError class

Structured business errors with codes for the API layer. Separates domain logic errors from
infrastructure errors.

```javascript
class DomainError extends Error {
  constructor(code, message, options) {
    super(message ?? code, options);
    this.name = 'DomainError';
    this.code = code;
  }
}
```

## Usage in API methods

Domain layer throws plain errors; API layer translates to DomainError with known codes.

```javascript
({
  method: async ({ email }) => {
    const user = await domain.user.findByEmail(email);
    if (!user) return new DomainError('ENOTFOUND', 'User not found');
    return user;
  },
  errors: {
    ENOTFOUND: { status: 404, message: 'User not found' },
    ECONFLICT: { status: 409, message: 'Already exists' },
    EFORBIDDEN: { status: 403, message: 'Access denied' },
  },
});
```

## Error propagation across layers

```
domain throws Error → API catches → returns DomainError(code) → client gets structured error
```

- Domain layer: throw standard errors, no HTTP concepts
- API/transport layer: catch domain errors, map to DomainError codes or HTTP status
- Client layer: receive structured `{ error: { code, message } }` — never raw stack traces

## Error mapping pattern

Centralized error-to-response mapping avoids scattered status code logic.

```javascript
const ERROR_MAP = {
  ENOTFOUND: { status: 404 },
  ECONFLICT: { status: 409 },
  EVALIDATION: { status: 422 },
  EFORBIDDEN: { status: 403 },
  EUNAUTHORIZED: { status: 401 },
};

const toResponse = (error) => {
  if (error instanceof DomainError) {
    const mapped = ERROR_MAP[error.code] ?? { status: 500 };
    return { status: mapped.status, body: { error: { code: error.code, message: error.message } } };
  }
  console.error('Unexpected error:', error);
  return { status: 500, body: { error: { code: 'EINTERNAL', message: 'Internal error' } } };
};
```

Do not expose internal error details to clients; map to known error codes or generic messages.

## Sources

- [Node.js — Errors documentation](https://nodejs.org/api/errors.html) — error codes convention
- [Error Handling — Frontend Patterns](https://frontendpatterns.dev/error-handling/) — APIError class pattern
