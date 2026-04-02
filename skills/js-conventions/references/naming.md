# Naming Conventions

Naming rules that static analysis cannot fully enforce. Apply consistently in all new code.

## Casing Rules

| Context                         | Case             | Example                             |
| ------------------------------- | ---------------- | ----------------------------------- |
| Variables, parameters           | camelCase        | `userName`, `itemCount`             |
| Functions, methods              | camelCase        | `parseInput`, `getUserById`         |
| Classes, interfaces, types      | UpperCamelCase   | `HttpClient`, `UserService`         |
| Enums                           | UpperCamelCase   | `Direction`, `LogLevel`             |
| Enum members                    | UPPER_SNAKE_CASE | `Direction.NORTH`                   |
| Module-level constants          | UPPER_SNAKE_CASE | `MAX_RETRIES`, `DEFAULT_PORT`       |
| File names (modules)            | kebab-case       | `user-service.ts`, `http-client.ts` |
| File names (classes/components) | UpperCamelCase   | `UserService.ts`, `AppHeader.vue`   |

## Boolean Names

Always use a predicate prefix:

**good**

```js
const isActive = true;
const hasPermission = user.roles.includes('admin');
const canEdit = isActive && hasPermission;
const shouldRefresh = Date.now() - lastFetch > CACHE_TTL_MS;
```

**bad**

<!-- prettier-ignore -->
```js
const active = true;
const permission = user.roles.includes('admin');
const edit = active && permission;
```

## Function Names

Start with a verb that describes the action:

| Verb       | Use for                     | Example                  |
| ---------- | --------------------------- | ------------------------ |
| `get`      | Synchronous property access | `getName()`              |
| `fetch`    | Async data retrieval        | `fetchUsers()`           |
| `find`     | Search in collection        | `findById()`             |
| `create`   | Object/resource creation    | `createOrder()`          |
| `update`   | Modify existing resource    | `updateProfile()`        |
| `delete`   | Remove resource             | `deleteSession()`        |
| `parse`    | Transform from one format   | `parseJSON()`            |
| `format`   | Transform for display       | `formatDate()`           |
| `validate` | Check correctness           | `validateEmail()`        |
| `handle`   | Process event or callback   | `handleClick()`          |
| `on`       | Event listener registration | `onClick`, `onResize`    |
| `is/has`   | Boolean-returning check     | `isEmpty()`, `hasId()`   |
| `to`       | Conversion                  | `toString()`, `toJSON()` |

## Numeric Names with Units

Include the unit to avoid ambiguity:

**good**

```js
const timeoutMs = 5000;
const maxSizeBytes = 1024 * 1024;
const debounceDelayMs = 300;
/**
 * count — no unit suffix needed
 */
const maxRetries = 3;
const cacheTtlMs = 60_000;
```

**bad**

<!-- prettier-ignore -->
```js
/**
 * 5000 what? ms? seconds?
 */
const timeout = 5000;

/**
 * bytes? KB? MB?
 */
const maxSize = 1024;
const delay = 300;
```

Exception: options objects where the key name already implies the unit (`{ timeout: 5000 }` in a
well-documented API).

## Callback Parameter Names

| Callback length | Style       | Example                                   |
| --------------- | ----------- | ----------------------------------------- |
| Single-line     | Short names | `users.map((u) => u.name)`                |
| Multiline       | Descriptive | `users.map((user) => { ... })`            |
| Index needed    | Named       | `items.forEach((item, index) => { ... })` |

## Catch Block

Always use `error`, not `err`, `e`, or `ex`:

```js
try {
  await fetchData();
} catch (error) {
  logger.error('Fetch failed', { error });
}
```

## Collections

Singular for single entity, plural for collections:

```js
/**
 * single
 */
const user = await getUser(id);

/**
 * collection
 */
const users = await listUsers();

/**
 * collection with type suffix
 */
const orderMap = new Map();
const userSet = new Set();
```

## TypeScript Generics

| Pattern   | Use for                 | Example                        |
| --------- | ----------------------- | ------------------------------ |
| `T`       | Primary type parameter  | `Array<T>`, `Promise<T>`       |
| `K`, `V`  | Key/value pairs         | `Map<K, V>`, `Record<K, V>`    |
| `R`       | Return type             | `(...args: unknown[]) => R`    |
| `TPrefix` | Domain-specific meaning | `TInput`, `TOutput`, `TConfig` |

- Use single letters for simple, well-known patterns
- Use `T`-prefixed descriptive names when the type has domain meaning

**good — simple**

```ts
const first = <T>(items: T[]): T | undefined => items[0];
```

**good — descriptive**

```ts
const transform = <TInput, TOutput>(items: TInput[], fn: (item: TInput) => TOutput): TOutput[] =>
  items.map(fn);
```

## TypeScript Utility Types

Name custom utility types clearly to reflect the transformation:

**good — clear transformation names**

```ts
type UserUpdate = Partial<Omit<User, 'id'>>;
type UserSummary = Pick<User, 'id' | 'name'>;
type ReadonlyConfig = Readonly<Config>;
```

**bad — opaque name**

<!-- prettier-ignore -->
```ts
type UserPartial = Partial<User>;
```

## Enum Naming

**good**

```ts
enum LogLevel {
  DEBUG = 'debug',
  INFO = 'info',
  WARN = 'warn',
  ERROR = 'error',
}

enum HttpStatus {
  OK = 200,
  NOT_FOUND = 404,
  INTERNAL_ERROR = 500,
}
```

- Enum name: `UpperCamelCase`, singular noun
- Enum members: `UPPER_SNAKE_CASE`
- Prefer string values for enums used in serialization/logging
- Prefer `as const` arrays over enums for simple string unions (see TypeScript conventions)

## Vue Component Names

| Context              | Convention | Example                        |
| -------------------- | ---------- | ------------------------------ |
| Component definition | PascalCase | `AppHeader`, `UserProfile`     |
| Template usage       | PascalCase | `<AppHeader />`                |
| Props                | camelCase  | `userName`, `isVisible`        |
| Events               | camelCase  | `updateUser`, `closeModal`     |
| HTML attributes      | hyphenated | `user-name`, `is-visible`      |
| Event listeners      | hyphenated | `@update-user`, `@close-modal` |
