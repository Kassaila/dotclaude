# Recommended ESLint Rules

ESLint rules recommended for addition to project configs. These are not currently in
`eslint-plugin-kassaila` but catch real bugs or enforce useful conventions. Grouped by impact.

## Bug Prevention

Rules that catch actual bugs at lint time.

| Rule                           | Setting                             | Why                                                 |
| ------------------------------ | ----------------------------------- | --------------------------------------------------- |
| `consistent-return`            | error (treatUndefinedAsUnspecified) | Prevents mixed return types in a function           |
| `no-loop-func`                 | error                               | Prevents closures over mutable loop variables       |
| `no-self-compare`              | error                               | Catches `x === x` (likely a typo)                   |
| `no-unmodified-loop-condition` | error                               | Catches infinite loops from unchanged condition     |
| `no-return-assign`             | error                               | Prevents accidental assignment in return            |
| `no-promise-executor-return`   | error                               | Catches accidental return in `new Promise` executor |
| `no-constructor-return`        | error                               | Prevents return value from constructor              |
| `no-template-curly-in-string`  | warn                                | Catches `'Hello ${name}'` (missing backticks)       |

## Code Quality

Rules that enforce cleaner patterns.

| Rule                           | Setting        | Why                                             |
| ------------------------------ | -------------- | ----------------------------------------------- |
| `object-shorthand`             | error (always) | `{ fn() {} }` over `{ fn: function() {} }`      |
| `prefer-rest-params`           | error          | `...args` instead of `arguments`                |
| `prefer-spread`                | error          | `fn(...args)` instead of `fn.apply(null, args)` |
| `logical-assignment-operators` | error (always) | `x ??= y` instead of `x = x ?? y`               |
| `no-lonely-if`                 | error          | `else if` instead of `else { if }`              |
| `no-nested-ternary`            | error          | Ban nested ternaries                            |
| `operator-assignment`          | error (always) | `x += 1` instead of `x = x + 1`                 |
| `no-else-return`               | error          | Reduce nesting: `if (...) { return; } ...`      |
| `prefer-object-has-own`        | error          | `Object.hasOwn()` over `.hasOwnProperty()`      |

## Style Consistency

Rules that improve visual consistency across the codebase.

| Rule                      | Setting           | Why                                          |
| ------------------------- | ----------------- | -------------------------------------------- |
| `arrow-body-style`        | error (as-needed) | Omit braces when body is a single expression |
| `no-useless-concat`       | error             | `'a' + 'b'` → `'ab'`                         |
| `no-useless-computed-key` | error             | `{ ['x']: 1 }` → `{ x: 1 }`                  |
| `no-useless-rename`       | error             | `{ x: x }` → `{ x }`                         |
| `no-useless-return`       | error             | Remove `return;` at end of function          |
| `no-unneeded-ternary`     | error             | `x ? true : false` → `x`                     |
| `prefer-object-spread`    | error             | `{ ...obj }` over `Object.assign({}, obj)`   |

## TypeScript-Specific

Additional typescript-eslint rules worth enabling.

| Rule                                               | Setting | Why                                        |
| -------------------------------------------------- | ------- | ------------------------------------------ |
| `@typescript-eslint/no-unnecessary-condition`      | warn    | Catches always-truthy/falsy checks         |
| `@typescript-eslint/prefer-nullish-coalescing`     | error   | `??` instead of `\|\|` for nullable values |
| `@typescript-eslint/prefer-optional-chain`         | error   | `a?.b?.c` instead of `a && a.b && a.b.c`   |
| `@typescript-eslint/strict-boolean-expressions`    | warn    | Prevents implicit boolean coercion         |
| `@typescript-eslint/switch-exhaustiveness-check`   | error   | Ensure all union members are handled       |
| `@typescript-eslint/no-unnecessary-type-assertion` | error   | Remove redundant `as` casts                |
| `@typescript-eslint/prefer-as-const`               | error   | `as const` over literal type assertion     |

## Import Rules

Additional import-related rules.

| Rule                                | Setting | Why                                         |
| ----------------------------------- | ------- | ------------------------------------------- |
| `import-x/no-self-import`           | error   | Prevents a module from importing itself     |
| `import-x/no-useless-path-segments` | error   | Removes unnecessary `./` and `../` segments |
| `import-x/newline-after-import`     | error   | Empty line after import block               |
| `import-x/first`                    | error   | Imports must come before other statements   |
| `import-x/no-mutable-exports`       | error   | Exported bindings must be `const`           |
