# TypeScript Conventions

TypeScript-specific rules and patterns. These conventions extend the base JavaScript conventions for
typed code.

## Type vs Interface

- Prefer `interface` for object shapes — it is the default enforced by the linter
- Use `type` for: unions, intersections, mapped types, conditional types, primitives, tuples

**good**

```ts
/**
 * object shape
 */
interface User {
  id: string;
  name: string;
  email: string;
}

/**
 * union type
 */
type Status = 'active' | 'inactive' | 'suspended';

/**
 * intersection
 */
type AdminUser = User & { permissions: Permission[] };
```

**bad — type for plain object shape**

<!-- prettier-ignore -->
```ts
type User = {
  id: string;
  name: string;
};
```

## Type Imports

- Use `import type` for type-only imports — this is enforced by the linter
- Prefer inline type imports when mixing value and type imports

**good**

```ts
import type { Config } from './config';
import { createApp, type AppOptions } from './app';
```

**bad — type imported as regular import**

<!-- prettier-ignore -->
```ts
import { Config } from './config';
```

## Generics

### Naming

- Single-letter generics for simple, well-understood cases: `T`, `K`, `V`, `R`
- Descriptive generics when the type parameter has a specific domain meaning

| Convention | Use for                 | Example                                 |
| ---------- | ----------------------- | --------------------------------------- |
| `T`        | Primary type parameter  | `Array<T>`, `Promise<T>`                |
| `K`        | Key type                | `Record<K, V>`                          |
| `V`        | Value type              | `Map<K, V>`                             |
| `R`        | Return type             | `(...args: unknown[]) => R`             |
| `TItem`    | Specific domain meaning | `Collection<TItem>`                     |
| `TInput`   | Input of a transform    | `transform<TInput, TOutput>`            |
| `TConfig`  | Configuration type      | `createApp<TConfig extends BaseConfig>` |

**good — simple generic**

```ts
const first = <T>(items: T[]): T | undefined => items[0];
```

**good — descriptive generics**

```ts
const transform = <TInput, TOutput>(items: TInput[], fn: (item: TInput) => TOutput): TOutput[] =>
  items.map(fn);
```

**bad — ambiguous single letters for complex case**

<!-- prettier-ignore -->
```ts
const transform = <A, B>(items: A[], fn: (item: A) => B): B[] => items.map(fn);
```

### Constraints

- Use `extends` to constrain generics — be as specific as needed
- Prefer interface constraints over inline object types

**good**

```ts
interface HasId {
  id: string;
}

const findById = <T extends HasId>(items: T[], id: string): T | undefined =>
  items.find((item) => item.id === id);
```

**bad — unconstrained**

<!-- prettier-ignore -->
```ts
const findById = <T>(items: T[], id: string): T | undefined =>
  items.find((item) => (item as { id: string }).id === id);
```

## Array Type

- Use `T[]` for simple element types
- Use `Array<T>` for complex element types (unions, intersections, generics)

**good**

```ts
const ids: string[] = [];
const entries: Array<[string, number]> = [];
const handlers: Array<(event: Event) => void> = [];
```

**bad**

<!-- prettier-ignore -->
```ts
const ids: Array<string> = [];
const entries: [string, number][] = [];
```

## Type Narrowing

- Prefer type guards and discriminated unions over type assertions
- Use `unknown` instead of `any` for values that need runtime checking
- Assertions (`as`) are a last resort

**good — discriminated union**

```ts
interface Success {
  status: 'success';
  data: User;
}

interface Failure {
  status: 'error';
  error: string;
}

type Result = Success | Failure;

const handle = (result: Result) => {
  if (result.status === 'success') {
    return result.data;
  }

  throw new Error(result.error);
};
```

**good — type guard**

```ts
const isUser = (value: unknown): value is User =>
  typeof value === 'object' && value !== null && 'id' in value && 'name' in value;
```

**bad — assertion**

<!-- prettier-ignore -->
```ts
const user = response.data as User;
```

## Utility Types

Use built-in utility types instead of manual definitions:

| Type            | Use for                        |
| --------------- | ------------------------------ |
| `Partial<T>`    | All properties optional        |
| `Required<T>`   | All properties required        |
| `Pick<T, K>`    | Subset of properties           |
| `Omit<T, K>`    | Exclude properties             |
| `Record<K, V>`  | Dictionary with known key type |
| `Readonly<T>`   | Immutable version              |
| `ReturnType<T>` | Infer function return type     |
| `Parameters<T>` | Infer function parameter types |
| `Awaited<T>`    | Unwrap Promise type            |

**good**

```ts
type UserUpdate = Partial<Omit<User, 'id'>>;
type UserSummary = Pick<User, 'id' | 'name'>;
```

**bad — manual partial**

<!-- prettier-ignore -->
```ts
interface UserUpdate {
  name?: string;
  email?: string;
}
```

## Const Assertions

- Use `as const` for literal values that should not widen
- Prefer `as const` over manual readonly types for fixed data

**good**

```ts
const DIRECTIONS = ['north', 'south', 'east', 'west'] as const;
type Direction = (typeof DIRECTIONS)[number];

const CONFIG = {
  maxRetries: 3,
  timeoutMs: 5000,
} as const;
```

**bad — manual enum for simple literals**

<!-- prettier-ignore -->
```ts
enum Direction {
  North = 'north',
  South = 'south',
  East = 'east',
  West = 'west',
}
```

## Any and Unknown

- `any` triggers a warning — minimize usage
- Non-null assertions (`!`) trigger a warning — prefer explicit checks
- Use `unknown` for values from external boundaries (API responses, user input, parsed JSON)
- Narrow `unknown` with type guards before use

**good**

```ts
const parseResponse = (raw: unknown): User => {
  if (!isUser(raw)) {
    throw new Error('Invalid user data');
  }

  return raw;
};
```

**bad**

<!-- prettier-ignore -->
```ts
const parseResponse = (raw: any): User => raw;
```

## Unused Variables

- Unused variables and parameters are errors
- Prefix intentionally unused names with underscore: `_unusedParam`, `_`

**good**

```ts
const handler = (_event: Event, data: Data) => {
  process(data);
};
```

**bad**

<!-- prettier-ignore -->
```ts
const handler = (event: Event, data: Data) => {
  process(data);
};
```

## Promises

- Floating promises (unawaited, unreturned) are errors
- Use `void` operator for intentional fire-and-forget: `void sendAnalytics()`
- Avoid passing async functions as callbacks to interfaces that expect sync return (`void`)

**good**

```ts
await saveUser(user);
void logAnalytics(event);
```

**bad — floating promise**

<!-- prettier-ignore -->
```ts
saveUser(user);
```
