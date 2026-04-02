# Formatting

Formatting rules for JavaScript, TypeScript, and Vue files. These conventions define how code and
files should look — independent of which tool enforces them.

## Indentation

- 2 spaces, no tabs
- No mixed indentation within a file
- Continuation lines aligned or indented by one extra level

<!-- prettier-ignore -->
```js
/**
 * good
 */
const result = longFunctionName(
  firstArgument,
  secondArgument,
  thirdArgument,
);

/**
 * bad
 */
const result = longFunctionName(
    firstArgument,
	  secondArgument,
);
```

## Line Length

- Maximum 100 characters per line
- URLs in comments may exceed the limit — do not break them
- Import paths may exceed the limit when unavoidable

## Quotes

- Single quotes for strings in JS/TS
- Backticks only when template interpolation or multiline is needed
- Consistent quote style for object property names within a single object

<!-- prettier-ignore -->
```js
/**
 * good
 */
const name = 'Alice';
const greeting = `Hello, ${name}`;

/**
 * bad
 */
const name = "Alice";
const greeting = "Hello, " + name;
```

## Semicolons

- Always use semicolons at statement ends
- No reliance on ASI (Automatic Semicolon Insertion)

## Trailing Commas

- Always use trailing commas in multiline:
  - Array literals
  - Object literals
  - Function parameters
  - Function arguments
  - Import/export lists
  - Destructuring assignments

<!-- prettier-ignore -->
```js
/**
 * good
 */
const config = {
  host: 'localhost',
  port: 3000,
  debug: true,
};

/**
 * bad
 */
const config = {
  host: 'localhost',
  port: 3000,
  debug: true
};
```

## Braces and Spacing

- `bracketSpacing: true` — spaces inside object braces: `{ key: value }`
- Curly braces required for all control flow blocks — even single-line `if`/`else`/`for`/`while`
- Opening brace on the same line as the statement

<!-- prettier-ignore -->
```js
/**
 * good
 */
if (condition) {
  doSomething();
}

/**
 * bad
 */
if (condition) doSomething();

if (condition)
{
  doSomething();
}
```

## Empty Lines and Padding

Keep one empty line between semantic blocks. Specific padding rules:

- Empty line before `return` and `break`
- Empty line after variable declarations (consecutive declarations may be grouped)
- Empty line before and after block statements (`if`, `for`, `while`, `switch`, `try`)
- Empty line between assignment expressions and call expressions

<!-- prettier-ignore -->
```js
/**
 * good
 */
const host = getHost();
const port = getPort();

const server = createServer({ host, port });

if (server.ready) {
  server.listen();

  return server;
}

/**
 * bad
 */
const host = getHost();
const port = getPort();
const server = createServer({ host, port });
if (server.ready) {
  server.listen();
  return server;
}
```

## HTML Whitespace (Vue)

- `htmlWhitespaceSensitivity: ignore` — whitespace in Vue templates is not significant for
  formatting decisions

## Comments

### Block Comments (JSDoc Style)

All comments must use JSDoc-style block syntax `/** ... */`. Line comments (`//`) are not allowed
except for tool directives.

Single-line JSDoc comments must use multiline format:

<!-- prettier-ignore -->
```js
/**
 * good
 */
/**
 * Parse the input string into a structured object.
 */
const parseInput = (raw) => { ... };

/**
 * TODO: Refactor to use streaming parser
 */

/**
 * bad
 */
// Parse the input string
const parseInput = (raw) => { ... };

/**
 * Parse the input string
 */
const parseInput = (raw) => { ... };
```

### Inline Comments

Inline comments (on the same line as code) are forbidden. Move the comment above the code:

<!-- prettier-ignore -->
```js
/**
 * good
 */
/**
 * Increment retry counter
 */
retries += 1;

/**
 * bad
 */
retries += 1; // increment
```

### Allowed Exceptions

The following are not subject to the JSDoc-style requirement:

- ESLint directives: `// eslint-disable-next-line`, `// eslint-disable`, `// eslint-enable`
- TypeScript directives: `// @ts-expect-error`, `// @ts-ignore`, `// @ts-nocheck`
- Triple-slash references: `/// <reference ... />`
- Separator lines: `// ═══════`, `// ------`, `// ******`

### TODO Format

TODO comments must follow the format `TODO: description` (uppercase, with colon and space):

<!-- prettier-ignore -->
```js
/**
 * good
 */
/**
 * TODO: Extract validation logic into a separate module
 */

/**
 * bad
 */
/**
 * todo - extract validation
 * Todo: extract validation
 * TODO extract validation
 */
```

## File-Level Conventions

### Encoding and Line Endings

- File encoding: UTF-8
- Line endings: LF (`\n`) — no CRLF
- Final newline: always insert a trailing newline at end of file
- Trailing whitespace: trim from all lines

### Markdown Exception

- Markdown files (`.md`): do not trim trailing whitespace (two trailing spaces = `<br>`)

### Prettier Ignore

Exclude from Prettier formatting:

- `dist/` — build output
- `node_modules/` — dependencies

## File Section Order

### JavaScript / TypeScript Modules

Recommended section order within a file:

1. Type imports (`import type { ... }`)
2. Side-effect imports (`import 'module'`)
3. External package imports
4. Internal/project imports
5. Constants and configuration
6. Type definitions (interfaces, types)
7. Main implementation (classes, functions)
8. Exports (if not inline)

### Vue Single-File Components

Block order in `.vue` files:

1. `<script>` (or `<script setup>`)
2. `<template>`
3. `<style>`

Macro order inside `<script setup>`:

1. `defineOptions`
2. `defineProps`
3. `defineEmits`
4. `defineSlots`

## EditorConfig

EditorConfig provides baseline file conventions for all editors. Settings:

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true
max_line_length = 100

[*.md]
trim_trailing_whitespace = false
```

## Formatter vs Linter

- **Formatter (Prettier)** handles mechanical formatting: quotes, semicolons, indentation, line
  wrapping, trailing commas, bracket spacing
- **Linter (ESLint)** handles structural rules: padding lines, curly braces, comment style, import
  order
- Formatting rules in ESLint are disabled via `eslint-config-prettier` to avoid conflicts
- Run Prettier first, then ESLint — or use an integrated command (`npm run fix`)
