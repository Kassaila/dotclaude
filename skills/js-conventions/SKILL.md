---
name: js-conventions
description:
  Apply JavaScript/TypeScript code conventions. Use when writing or editing .js, .mjs, .ts, .vue
  files, reviewing code style, or when the user asks about naming, formatting, or code quality
  patterns.
allowed-tools: Read, Grep, Glob
---

# JavaScript / TypeScript Conventions

This skill defines code conventions for JavaScript, TypeScript, and Vue projects. Conventions are
organized into abstract rules (Layer 1) and tooling coverage (Layer 2).

- **Layer 1 — Conventions**: how code should look and behave, independent of tooling
- **Layer 2 — Tooling**: which tools enforce which rules, and what remains manual

## Tooling

All formatting and mechanical style rules are enforced by `eslint-plugin-kassaila` and Prettier. Do
not manually fix what the tooling already covers — run the linter instead.

- **`eslint-plugin-kassaila`** — custom ESLint plugin with three auto-fixable rules and two
  shareable configs (`tsConfig`, `vueConfig`)
- **Prettier** — formatting (quotes, semicolons, indentation, line width)
- **EditorConfig** — file-level conventions (encoding, line endings, trailing whitespace)
- Before and after code changes: run `npm run lint` and `npm test`
- Use `npm run fix` or equivalent to auto-fix when possible

## Formatting

Code and file formatting conventions: indentation (2 spaces), single quotes, semicolons, trailing
commas, line length (100), bracket spacing, empty lines between semantic blocks, JSDoc block
comments, file encoding (UTF-8, LF), EditorConfig, formatter vs linter separation.

Full reference — see `references/formatting.md`.

## Naming

Naming conventions for readability: `camelCase` for variables/functions, `UpperCamelCase` for
classes/types, `UPPER_SNAKE_CASE` for constants/enum members. Boolean prefixes (`is`, `has`, `can`,
`should`), verb-first function names, units in numeric names (`timeoutMs`), `error` in catch blocks,
TypeScript generic naming (`T`, `TInput`), Vue component naming (PascalCase).

Full reference — see `references/naming.md`.

## Practices

Code quality patterns: prefer `const`, arrow functions, no input mutation, small single-purpose
functions, expression decomposition, strict equality, curly braces for all control flow, switch/case
braces, `.map`/`.filter` for transforms, `for...of` for side effects, self-documenting code.

Full reference — see `references/practices.md`.

## Async Patterns

Async/await conventions: prefer `async`/`await` over `.then()` chains, `Promise.all` for parallel
operations, `AbortController` for cancellation, no floating promises, `void` for fire-and-forget,
proper error propagation, `for...of` for sequential async iteration.

Full reference — see `references/async-patterns.md`.

## Module Structure

File organization: import ordering (types → side-effects → builtins → external → internal →
relative), inline type imports, no duplicate imports, no circular dependencies, barrel files for
public API boundaries, kebab-case file names, named exports preferred.

Full reference — see `references/module-structure.md`.

## TypeScript

TypeScript-specific conventions: prefer `interface` for object shapes, `type` for unions/mapped,
generic naming, `array-simple` notation, type narrowing over assertions, utility types, const
assertions, `unknown` over `any`, unused vars prefixed with `_`.

Full reference — see `references/typescript-conventions.md`.

## Engine Optimizations

V8-level patterns for performance-sensitive code. Apply in hot paths; in cold code readability takes
priority. Stable object shapes, monomorphic functions, fixed property access, dense arrays, Map/Set
for dynamic collections, extracted callbacks, no try/catch in hot loops, GC pressure reduction.

Full reference — see `references/v8-optimizations.md`.

## Project-Specific Config

The tooling supports project-specific configurations:

- **TypeScript projects** — use `tsConfig` from `eslint-plugin-kassaila/configs/ts`
- **Vue projects** — use `vueConfig` from `eslint-plugin-kassaila/configs/vue`
- Project-level `.prettierrc` and `eslint.config.js` override global defaults
- When a project has its own config, defer to it over these conventions

## Convention References

Load the relevant reference based on the task at hand:

- **Formatting code or files?** — see `references/formatting.md`. Indentation, quotes, semicolons,
  commas, comments, file encoding, EditorConfig, formatter vs linter.
- **Naming a variable, function, or type?** — see `references/naming.md`. Casing rules, boolean
  prefixes, verb tables, generics, Vue naming.
- **Writing or reviewing code logic?** — see `references/practices.md`. Variable declarations, arrow
  functions, immutability, control flow, iteration patterns.
- **Working with async code?** — see `references/async-patterns.md`. await vs .then(), parallel
  execution, error handling, AbortController, async iteration.
- **Organizing files or imports?** — see `references/module-structure.md`. Import ordering, type
  imports, barrel files, circular deps, file naming.
- **Writing TypeScript?** — see `references/typescript-conventions.md`. Type vs interface, generics,
  array types, narrowing, utility types.
- **Optimizing a hot path?** — see `references/v8-optimizations.md`. Object shapes, monomorphism,
  arrays, data structures, GC pressure.

## Tooling References

- **What does the tooling auto-fix?** — see `references/tooling-coverage.md`. Complete mapping of
  convention rules to Prettier, EditorConfig, ESLint, and plugin rules. Shows what is automated and
  what requires manual review.
- **Which ESLint rules to add?** — see `references/recommended-rules.md`. Curated list of ESLint
  rules not yet in `eslint-plugin-kassaila` — candidates for project configs.

## Sources

- [eslint-plugin-kassaila](https://github.com/Kassaila/eslint-plugin-kassaila) — custom ESLint
  plugin (rules, tsConfig, vueConfig)
- [V8 Blog — Fast Properties](https://v8.dev/blog/fast-properties)
- [V8 Blog — Elements Kinds](https://v8.dev/blog/elements-kinds)
- [mrale.ph — What's up with Monomorphism](https://mrale.ph/blog/2015/01/11/whats-up-with-monomorphism.html)
