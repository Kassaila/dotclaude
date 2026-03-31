# Replaceable Higher-Level Packages

Common packages with lighter alternatives or native replacements. These are the highest-impact
findings because they are usually direct dependencies — actionable immediately by the user.

| Package | Replacement | Reason |
|---|---|---|
| `chalk` | `picocolors` or native `util.styleText` (Node 20.12+) | ~5x smaller |
| `find-up` | `empathic/find` | No deep dependency chain (find-up pulls ~6 packages) |
| `rimraf` | `fs.rmSync(p, { recursive: true })` (Node 14.14+) | Native |
| `mkdirp` | `fs.mkdirSync(p, { recursive: true })` | Native since Node 10 |
| `which` | Native or `empathic/which` | Lighter |
| `left-pad` | `String.prototype.padStart()` | Native since 2017 |
| `underscore` / `lodash` (full) | Cherry-pick or native | Tree-shake or inline |
| `uuid` | `crypto.randomUUID()` | Native since Node 20 LTS |

## Resources

- [module-replacements](https://github.com/es-tooling/module-replacements) — community database of
  replaceable packages with recommended alternatives
- [module-replacements-codemods](https://github.com/es-tooling/module-replacements-codemods) —
  automated codemods to migrate from flagged packages to their replacements
