# Pillar 1 — Legacy Runtime Shims

Packages that exist for ES3/ES5 compatibility, global mutation protection, or cross-realm support.
The vast majority of projects don't need any of this — they run modern Node/browsers, don't pass
values across realms, and don't need protection from global namespace mutation.

Flag if found anywhere in the dependency tree.

| Package | What it shims | Native since |
|---|---|---|
| `is-string` | `typeof x === 'string'` | Always |
| `is-number` | `typeof x === 'number'` | Always |
| `is-boolean` | `typeof x === 'boolean'` | Always |
| `is-symbol` | `typeof x === 'symbol'` | ES2015 |
| `is-callable` | `typeof x === 'function'` | Always |
| `is-array` | `Array.isArray()` | ES5 (2009) |
| `is-regex` | `x instanceof RegExp` | Always |
| `is-date-object` | `x instanceof Date` | Always |
| `hasown` | `Object.hasOwn()` | ES2022 |
| `has` | `Object.prototype.hasOwnProperty` | ES3 |
| `function-bind` | `Function.prototype.bind` | ES5 (2009) |
| `call-bind` | `Function.prototype.call/apply` wrappers | Always |
| `math-intrinsics` | `Math.*` re-exports | Always |
| `get-intrinsic` | Internal intrinsics accessor | N/A (anti-mutation) |
| `es-define-property` | `Object.defineProperty` wrapper | ES5 (2009) |
| `define-properties` | `Object.defineProperties` wrapper | ES5 (2009) |
| `gopd` | `Object.getOwnPropertyDescriptor` | ES5 (2009) |
| `set-function-length` | Sets `.length` on functions | Niche |
| `es-errors` | Custom error subclasses | Always |
| `safe-regex-test` | `RegExp.prototype.test` wrapper | Always |
| `safe-array-concat` | `Array.prototype.concat` wrapper | Always |
