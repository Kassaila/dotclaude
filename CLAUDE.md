# CLAUDE.md

## Project Overview

**dotclaude** — shared Claude Code configuration repository. Contains global skills, agents, and
instructions. Individual items are symlinked to `~/.claude/` and coexist with skills installed via
`npx skills`.

## Repository Structure

```
skills/                            # Slash commands (global)
├── commit/SKILL.md                # /commit — analyze changes, propose and create commit
├── commit-proposal/SKILL.md       # /commit-proposal — suggest commit message and files
├── refactor/SKILL.md              # /refactor <target> — refactor with explanation
├── explain/SKILL.md               # /explain <target> — explain code/architecture
├── feature/SKILL.md               # /feature <name> — start feature workflow
├── memory-leak-audit/             # /memory-leak-audit — audit for leak patterns
│   ├── SKILL.md
│   └── references/                # 3 guides (leak patterns, framework patterns, fix reference)
├── skill-validator/SKILL.md       # /skill-validator — validate skills against spec
├── dep-bloat-audit/               # /dep-bloat-audit — audit npm deps for JS bloat
│   ├── SKILL.md
│   └── references/                # 4 package tables (shims, micro-pkgs, ponyfills, replacements)
├── js-error-handling/             # /js-error-handling — JS/TS error handling & recovery patterns
│   ├── SKILL.md
│   └── references/                # 4 guides (common, node, frontend, domain errors)
├── js-conventions/                # /js-conventions — JS/TS code conventions (auto-trigger)
│   ├── SKILL.md
│   └── references/                # 9 guides (naming, formatting, async, modules, typescript, etc.)
├── js-gof/                        # /js-gof — Gang of Four design patterns in JS/TS
│   ├── SKILL.md
│   └── references/                # 3 guides (creational, structural, behavioral)
└── js-data-structures/            # /js-data-structures — JS data structures (auto-trigger)
    ├── SKILL.md
    └── references/                # 13 structure guides (queue, stack, heap, trie, graph, etc.)
agents/                            # Subagents (global)
├── code-reviewer.md               # Code review agent
└── docs-updater.md                # Documentation updater agent
mcp/                               # MCP server configurations
└── global-servers.json            # Global MCP servers (context7, playwright)
external-skills.json               # External skills registry (for install-external)
bin/                               # Executable scripts
├── install.sh                     # Symlink skills, agents, and config to ~/.claude/
├── install-mcp.sh                 # Merge global MCP servers into ~/.claude/settings.json
├── install-external.sh            # Install external skills from external-skills.json
├── uninstall.sh                   # Remove dotclaude symlinks from ~/.claude/
└── status.sh                      # Show dotclaude and external skills status
CLAUDE.md                          # Project-specific instructions (this repo only)
global-claude.md                   # Global instructions (symlinked to ~/.claude/CLAUDE.md)
Makefile                           # make install / install-external / uninstall / status
commitlint.config.ts               # Commitlint configuration (conventional commits)
package.json                       # Dev dependencies (prettier, husky, lint-staged, commitlint)
```

## Usage

```bash
make install            # Symlink skills, agents, and config to ~/.claude/
make install-mcp        # Merge global MCP servers into ~/.claude/settings.json
make install-external   # Install external skills from external-skills.json
make uninstall          # Remove dotclaude symlinks from ~/.claude/
make status             # Show dotclaude and external skills status
```

- `make install` symlinks each skill, agent, and global-claude.md individually (not the whole
  directory)
- `make install-external` installs skills listed in `external-skills.json` via `npx skills`
- Project-level `.claude/` overrides global config for same-named skills/agents
