# Module Structure

Conventions for file organization, imports, exports, and module boundaries.

## Import Ordering

Group imports in the following order, separated by empty lines:

1. **Type imports** — `import type { ... } from '...'`
2. **Side-effect imports** — `import '...'` (no bindings)
3. **Node.js built-ins** — `import { readFile } from 'node:fs/promises'`
4. **External packages** — `import express from 'express'`
5. **Internal aliases** — `import { db } from '@/lib/db'`
6. **Relative imports** — `import { helper } from './helper'`

```js
/**
 * good
 */
import type { User, Config } from '@/types';

import 'reflect-metadata';

import { readFile } from 'node:fs/promises';

import express from 'express';

import { db } from '@/lib/db';

import { validate } from './validate';
```

## Type Imports

- Use `import type` for type-only imports
- Prefer inline type imports when mixing value and type imports from the same module

```ts
/**
 * good — inline type import
 */
import { createUser, type UserOptions } from './user';

/**
 * good — standalone type import
 */
import type { Config } from './config';

/**
 * bad — type imported as value
 */
import { Config } from './config';
```

## No Duplicate Imports

- Do not import from the same module in multiple statements
- Merge into a single import with inline type specifiers where needed

```ts
/**
 * good
 */
import { createUser, type UserOptions } from './user';

/**
 * bad — duplicate source
 */
import { createUser } from './user';
import type { UserOptions } from './user';
```

## Circular Dependencies

- Circular imports are forbidden — the linter reports them as errors
- Break cycles by extracting shared code into a third module
- Move types to a dedicated types file if the cycle is type-only

```
/**
 * bad — circular
 */
user.ts → order.ts → user.ts

/**
 * good — extract shared dependency
 */
user.ts → types.ts
order.ts → types.ts
```

## Barrel Files (Re-Exports)

- Use `index.ts` barrel files for public API boundaries of packages and major modules
- Do not use barrel files for internal module directories — import directly
- Keep barrel files thin: only `export { ... } from './...'`, no logic

```ts
/**
 * good — package public API
 */
export { createApp } from './app';
export { createRouter } from './router';
export type { AppConfig } from './types';

/**
 * bad — logic in barrel file
 */
export const VERSION = '1.0.0';
export const createApp = () => { ... };
```

## File Naming

| Content              | Convention     | Example                           |
| -------------------- | -------------- | --------------------------------- |
| General modules      | kebab-case     | `user-service.ts`                 |
| Classes / Components | UpperCamelCase | `UserService.ts`, `AppHeader.vue` |
| Test files           | match source   | `user-service.test.ts`            |
| Type-only files      | kebab-case     | `api-types.ts`                    |
| Constants / config   | kebab-case     | `default-config.ts`               |

## File Size

- Keep files focused on a single responsibility
- When a file exceeds ~300 lines, consider splitting into smaller modules
- Split by responsibility, not by arbitrary line count

## Export Style

- Prefer named exports over default exports
- Default exports are acceptable for: main app entry, page components, config files
- Do not mix default and named exports in the same module

```ts
/**
 * good — named exports
 */
export const createUser = (name) => ({ name });
export const deleteUser = (id) => db.delete(id);

/**
 * acceptable — component default export
 */
export default defineComponent({ ... });

/**
 * bad — mixed
 */
export default createApp;
export const config = { ... };
```

## Module Boundaries

- Each major feature or domain should have a clear public API (barrel file or facade)
- Internal modules should not be imported from outside their boundary
- Keep the dependency graph acyclic and shallow

```
/**
 * good — clear boundaries
 */
features/
  auth/
    index.ts          ← public API
    login.ts          ← internal
    session.ts        ← internal
  billing/
    index.ts          ← public API
    invoice.ts        ← internal

/**
 * import from boundary
 */
import { login } from '@/features/auth';

/**
 * bad — reaching into internals
 */
import { validateToken } from '@/features/auth/session';
```
