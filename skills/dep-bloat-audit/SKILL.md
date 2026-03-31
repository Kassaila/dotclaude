---
name: dep-bloat-audit
description:
  Audit npm dependency tree for JavaScript bloat — outdated polyfills/ponyfills, atomic
  micro-packages, legacy runtime shims. Detects replaceable dependencies and suggests native
  alternatives or lighter replacements. Use when reviewing package.json, after adding dependencies,
  or when user asks about dependency bloat or bundle size.
allowed-tools: Read, Grep, Glob, Bash(npm ls*), Bash(npx*), Bash(cat package-lock.json*), Bash(wc*)
---

Audit the project's npm dependencies for bloat patterns based on the three pillars of JavaScript
dependency bloat.

## Background

JavaScript dependency trees accumulate bloat from three sources:

1. **Legacy runtime shims** — packages that polyfill features available in all modern engines
2. **Atomic micro-packages** — one-liner packages that should be inlined
3. **Overstayed ponyfills** — polyfill-style packages for long-supported features

Each adds install time, disk usage, version resolution overhead, and supply chain attack surface.

Package tables for each pillar are in `references/`:

- `references/legacy-runtime-shims.md` — Pillar 1
- `references/atomic-micro-packages.md` — Pillar 2
- `references/overstayed-ponyfills.md` — Pillar 3
- `references/replaceable-packages.md` — higher-level packages with lighter alternatives

## Target

Analyze `package.json` in the current directory or `$ARGUMENTS` if a path is provided.

## Audit process

1. **Read `package.json`** — collect direct `dependencies` and `devDependencies`. Note
   `engines.node` if present — use it to filter ponyfill relevance (only flag ponyfills for
   features available in the declared minimum engine version).
2. **Check dependency tree** — run `npm ls --all --json 2>/dev/null` (or read `package-lock.json`)
   to find transitive dependencies.
3. **Run e18e analysis** — execute `npx @e18e/cli analyze 2>/dev/null` to detect replaceable
   packages with community-recommended alternatives. If the command fails (not installed, no
   npm project), skip this step silently and rely on the built-in tables in `references/`.
4. **Run knip** — execute `npx knip --dependencies --no-progress 2>/dev/null` to find unused
   direct dependencies. If the command fails, skip silently. Include any findings in a separate
   "Unused Dependencies" section of the report.
5. **Classify each flagged dependency** into one of three pillars using the tables in `references/`.
6. **Detect duplication** — run `npm ls --all 2>/dev/null` and look for packages appearing in
   multiple versions (lines with `deduped` or different semver for the same name). Report
   duplicated bloat packages in a "Version Duplication" section.
7. **Detect single-consumer packages** — for each flagged atomic micro-package (Pillar 2), check
   if it has only one dependent in the tree. If so, recommend inlining into that consumer.
8. **Merge results** — combine e18e suggestions, knip findings, and built-in table matches.
   Deduplicate: if e18e and the tables both flag a package, prefer the e18e recommendation
   (it may have more current replacement info).
9. **Report** findings with replacements.

## Output format

```
## Dependency Bloat Audit

Project: <name> (<path>)
Node engines: <from package.json or "not specified">
Total dependencies: X direct, Y transitive

### Pillar 1 — Legacy Runtime Shims (Z found)

| Package | Location | What it shims | Action |
|---|---|---|---|
| is-string | transitive via X | typeof check | Remove/replace upstream |

### Pillar 2 — Atomic Micro-packages (Z found)

| Package | Location | Inline equivalent | Single consumer? | Action |
|---|---|---|---|---|
| path-key | transitive via X | 1-line ternary | Yes (cross-spawn) | Inline in consumer |

### Pillar 3 — Overstayed Ponyfills (Z found)

| Package | Location | Native since | Action |
|---|---|---|---|
| globalthis | direct | Node 12 (2019) | Replace with globalThis |

### Replaceable Packages (Z found)

| Package | Location | Replacement | Savings |
|---|---|---|---|
| chalk | direct | picocolors | ~5x smaller |

### Version Duplication

[Only if duplicated bloat packages found]

| Package | Versions in tree | Pulled by |
|---|---|---|
| is-docker | 2.2.1, 3.0.0 | execa@5, execa@8 |

### Unused Dependencies (knip)

[Only if knip ran successfully and found results]

| Package | Type | Action |
|---|---|---|
| some-unused-pkg | devDependency | Remove from package.json |

### e18e Recommendations

[Only if e18e ran successfully and found results not already covered above]

| Package | e18e suggestion | Details |
|---|---|---|
| chalk | Use native util.styleText | https://nodejs.org/docs/latest/api/util.html#utilstyletextformat-text-options |

### Summary

| Category | Count | Severity |
|---|---|---|
| Legacy shims | X | Medium — supply chain risk |
| Micro-packages | X | Low — install overhead |
| Overstayed ponyfills | X | Medium — dead weight |
| Replaceable packages | X | High — actionable now |
| Version duplication | X | Low — resolution overhead |
| Unused dependencies | X | High — safe to remove |

### Recommended actions

1. [Highest-impact actions first — direct dependencies before transitive]
2. [For transitive: suggest raising issue upstream or using overrides]
3. [For auto-migratable packages: suggest `npx @e18e/cli migrate --all`]
4. [For codemods: suggest `npx module-replacements-codemods` where applicable]

### Further investigation

- Run `npx @e18e/cli migrate --all` to auto-migrate replaceable packages
- Run codemods: https://github.com/es-tooling/module-replacements-codemods
- Visualize full tree: https://npmgraph.js.org/?q=<package-name>
- Browse replacements database: https://github.com/es-tooling/module-replacements
```

## Notes

- Only flag packages actually present in the tree — do not guess
- Mark direct dependencies separately from transitive (direct = actionable by user)
- If `engines.node` in package.json specifies a minimum, use that to filter ponyfill relevance
- For transitive dependencies, identify which direct dependency pulls them in
- Suggest `npx @e18e/cli analyze` and `npmgraph.js.org` as follow-up tools

## Source

Based on [The Three Pillars of JavaScript Bloat](https://43081j.com/posts/2026-03-12-three-pillars-of-javascript-bloat/)
by [43081j](https://github.com/43081j) (March 2026).
[Source](https://github.com/43081j/43081j.github.io/blob/master/_posts/2026-03-12-three-pillars-of-javascript-bloat.md)
