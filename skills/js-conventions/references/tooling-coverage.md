# Tooling Coverage

Mapping of conventions to the tools that enforce them. Rules marked **auto** are handled
automatically — do not flag or manually fix these, run the linter/formatter instead. Rules marked
**manual** require code review or developer discipline.

## Formatting → Prettier

All formatting rules from `references/formatting.md` are handled by Prettier.

| Convention             | Prettier setting                      | Coverage |
| ---------------------- | ------------------------------------- | -------- |
| Single quotes          | `singleQuote: true`                   | auto     |
| Semicolons             | `semi: true`                          | auto     |
| Trailing commas        | `trailingComma: "all"`                | auto     |
| Line length (100)      | `printWidth: 100`                     | auto     |
| Indentation (2 spaces) | `tabWidth: 2`                         | auto     |
| Bracket spacing        | `bracketSpacing: true`                | auto     |
| Consistent quote props | `quoteProps: "consistent"`            | auto     |
| Prose wrapping         | `proseWrap: "always"`                 | auto     |
| HTML whitespace (Vue)  | `htmlWhitespaceSensitivity: "ignore"` | auto     |

**Prettier ignore**: `dist/`, `node_modules/`

## Formatting → EditorConfig

File-level conventions from `references/formatting.md`.

| Convention                 | EditorConfig setting                      | Coverage |
| -------------------------- | ----------------------------------------- | -------- |
| UTF-8 encoding             | `charset = utf-8`                         | auto     |
| LF line endings            | `end_of_line = lf`                        | auto     |
| Final newline              | `insert_final_newline = true`             | auto     |
| Trim trailing whitespace   | `trim_trailing_whitespace = true`         | auto     |
| Markdown: keep trailing ws | `[*.md] trim_trailing_whitespace = false` | auto     |

## Formatting → ESLint (@stylistic)

Structural formatting enforced by `@stylistic/eslint-plugin`.

| Convention                     | Rule                                         | Coverage |
| ------------------------------ | -------------------------------------------- | -------- |
| Blank line before return/break | `@stylistic/padding-line-between-statements` | auto     |
| Blank line after variable decl | `@stylistic/padding-line-between-statements` | auto     |
| Blank line around blocks       | `@stylistic/padding-line-between-statements` | auto     |
| Blank line between assign/call | `@stylistic/padding-line-between-statements` | auto     |

## Formatting → ESLint (eslint-plugin-kassaila)

Comment formatting rules from `references/formatting.md`.

| Convention                   | Rule                           | Coverage |
| ---------------------------- | ------------------------------ | -------- |
| JSDoc block comments (no //) | `kassaila/jsdoc-comment-style` | auto     |
| No inline comments           | `kassaila/jsdoc-comment-style` | auto     |
| Multiline JSDoc format       | `kassaila/jsdoc-comment-style` | auto     |
| TODO: format                 | `kassaila/jsdoc-comment-style` | auto     |

## Formatting — Manual

| Convention                              | Reference                  | Coverage                             |
| --------------------------------------- | -------------------------- | ------------------------------------ |
| File section order                      | `references/formatting.md` | manual                               |
| Vue block order (script→template→style) | `references/formatting.md` | auto (via `vue/block-order`)         |
| Vue macro order                         | `references/formatting.md` | auto (via `vue/define-macros-order`) |

## Practices → ESLint (built-in)

Rules from `references/practices.md`.

| Convention             | Rule                         | Coverage |
| ---------------------- | ---------------------------- | -------- |
| Prefer const           | `prefer-const`               | auto     |
| No var                 | `no-var`                     | auto     |
| Strict equality        | `eqeqeq` (null: ignore)      | auto     |
| No implicit coercion   | `no-implicit-coercion`       | auto     |
| Curly braces (all)     | `curly`                      | auto     |
| Prefer arrow callback  | `prefer-arrow-callback`      | auto     |
| Default case in switch | `default-case`               | auto     |
| Default case last      | `default-case-last`          | auto     |
| No console.log         | `no-console` (warn/error ok) | auto     |

## Practices → ESLint (eslint-plugin-kassaila)

| Convention                | Rule                                 | Coverage |
| ------------------------- | ------------------------------------ | -------- |
| Arrow functions (no this) | `kassaila/prefer-arrow-without-this` | auto     |
| Switch case braces        | `kassaila/switch-case-braces`        | auto     |

## Practices — Manual

| Convention                     | Reference                 | Coverage |
| ------------------------------ | ------------------------- | -------- |
| Small single-purpose functions | `references/practices.md` | manual   |
| No input mutation              | `references/practices.md` | manual   |
| Decompose long expressions     | `references/practices.md` | manual   |
| No nested ternaries            | `references/practices.md` | manual   |
| Consistent return types        | `references/practices.md` | manual   |
| Self-documenting code          | `references/practices.md` | manual   |
| forEach vs for...of            | `references/practices.md` | manual   |

## Naming — Manual

All naming conventions from `references/naming.md` are manual — the linter cannot fully enforce
naming semantics.

| Convention                    | Coverage |
| ----------------------------- | -------- |
| camelCase variables/functions | manual   |
| UpperCamelCase classes/types  | manual   |
| UPPER_SNAKE_CASE constants    | manual   |
| Boolean prefixes (is/has/can) | manual   |
| Verb-first function names     | manual   |
| Units in numeric names        | manual   |
| error in catch blocks         | manual   |
| Singular/plural collections   | manual   |

**Vue naming** — partially automated:

| Convention                 | Rule                                    | Coverage |
| -------------------------- | --------------------------------------- | -------- |
| PascalCase component names | `vue/component-definition-name-casing`  | auto     |
| PascalCase in templates    | `vue/component-name-in-template-casing` | auto     |
| camelCase props            | `vue/prop-name-casing`                  | auto     |
| camelCase events           | `vue/custom-event-name-casing`          | auto     |
| Hyphenated attributes      | `vue/attribute-hyphenation`             | auto     |

## TypeScript → typescript-eslint

Rules from `references/typescript-conventions.md`.

| Convention                | Rule                                | Coverage |
| ------------------------- | ----------------------------------- | -------- |
| Prefer interface          | `consistent-type-definitions`       | auto     |
| Type imports (inline)     | `consistent-type-imports`           | auto     |
| Array type (array-simple) | `array-type`                        | auto     |
| No floating promises      | `no-floating-promises` (ignoreVoid) | auto     |
| No misused promises       | `no-misused-promises`               | auto     |
| Unused vars (^\_ pattern) | `no-unused-vars`                    | auto     |
| No explicit any           | `no-explicit-any` (warn)            | auto     |
| No non-null assertion     | `no-non-null-assertion` (warn)      | auto     |

## TypeScript — Manual

| Convention                     | Reference                              | Coverage |
| ------------------------------ | -------------------------------------- | -------- |
| Generic naming (T, TInput)     | `references/typescript-conventions.md` | manual   |
| Type narrowing over assertions | `references/typescript-conventions.md` | manual   |
| Utility types usage            | `references/typescript-conventions.md` | manual   |
| Const assertions               | `references/typescript-conventions.md` | manual   |
| unknown over any               | `references/typescript-conventions.md` | manual   |

## Module Structure → eslint-plugin-import-x

Rules from `references/module-structure.md`.

| Convention               | Rule                     | Coverage |
| ------------------------ | ------------------------ | -------- |
| No duplicate imports     | `import-x/no-duplicates` | auto     |
| No circular dependencies | `import-x/no-cycle`      | auto     |

## Module Structure — Manual

| Convention              | Reference                        | Coverage |
| ----------------------- | -------------------------------- | -------- |
| Import ordering         | `references/module-structure.md` | manual   |
| Barrel file usage       | `references/module-structure.md` | manual   |
| Module boundaries       | `references/module-structure.md` | manual   |
| File naming conventions | `references/module-structure.md` | manual   |

## Async Patterns — Manual

All async conventions from `references/async-patterns.md` are manual except:

| Convention           | Rule                                      | Coverage |
| -------------------- | ----------------------------------------- | -------- |
| No floating promises | `@typescript-eslint/no-floating-promises` | auto     |
| No misused promises  | `@typescript-eslint/no-misused-promises`  | auto     |

## V8 Optimizations — Manual

All V8 optimization patterns from `references/v8-optimizations.md` are manual — no linter rule can
enforce engine-level performance patterns.

## Conflict Resolution

`eslint-config-prettier` is included in both `tsConfig` and `vueConfig` to disable ESLint formatting
rules that conflict with Prettier. This ensures:

- Prettier handles all formatting
- ESLint handles only structural and logical rules
- No conflicting auto-fix loops
