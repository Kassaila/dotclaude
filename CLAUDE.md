# CLAUDE.md

## Project Overview

**dotclaude** — shared Claude Code configuration repository. Contains global skills, agents, and
instructions. Individual items are symlinked to `~/.claude/` and coexist with skills installed via
`npx skills`.

## Repository Structure

```
skills/                            # Slash commands (global)
├── commit-proposal/SKILL.md       # /commit-proposal — suggest commit message and files
├── refactor/SKILL.md              # /refactor <target> — refactor with explanation
├── explain/SKILL.md               # /explain <target> — explain code/architecture
├── feature/SKILL.md               # /feature <name> — start feature workflow
└── memory-leak-audit/SKILL.md     # /memory-leak-audit — audit for leak patterns
agents/                            # Subagents (global)
├── code-reviewer.md               # Code review agent
└── docs-updater.md                # Documentation updater agent
external-skills.json               # External skills registry (for install-external)
bin/                               # Executable scripts
├── install.sh                     # Symlink skills, agents, and config to ~/.claude/
├── install-external.sh            # Install external skills from external-skills.json
├── uninstall.sh                   # Remove dotclaude symlinks from ~/.claude/
└── status.sh                      # Show dotclaude and external skills status
Makefile                           # make install / install-external / uninstall / status
```

## Rules

- Never create commits — only suggest commit messages and files to stage
- Technical, concise responses
- Conventional commits format for commit messages

## Usage

```bash
make install            # Symlink skills, agents, and config to ~/.claude/
make install-external   # Install external skills from external-skills.json
make uninstall          # Remove dotclaude symlinks from ~/.claude/
make status             # Show dotclaude and external skills status
```

- `make install` symlinks each skill, agent, and CLAUDE.md individually (not the whole directory)
- `make install-external` installs skills listed in `external-skills.json` via `npx skills`
- Project-level `.claude/` overrides global config for same-named skills/agents
