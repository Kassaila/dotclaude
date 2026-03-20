# dotclaude

Shared Claude Code configuration — global skills, agents, and instructions

## Structure

```
skills/
├── commit-proposal/SKILL.md       # /commit-proposal — suggest commit message and files
├── refactor/SKILL.md              # /refactor <target> — refactor with explanation
├── explain/SKILL.md               # /explain <target> — explain code/architecture
├── feature/SKILL.md               # /feature <name> — start feature workflow
├── memory-leak-audit/SKILL.md     # /memory-leak-audit — audit for leak patterns
├── skill-validator/SKILL.md       # /skill-validator — validate skills against spec
└── js-data-structures/            # JS data structures reference (auto-trigger)
    ├── SKILL.md
    └── references/                # 12 structure guides (heap, queue, trie, etc.)
agents/
├── code-reviewer.md               # Code review agent (sonnet)
└── docs-updater.md                # Documentation updater agent (sonnet)
external-skills.json               # External skills registry (for install-external)
bin/
├── install.sh                     # Symlink skills, agents, and config to ~/.claude/
├── install-external.sh            # Install external skills from external-skills.json
├── uninstall.sh                   # Remove dotclaude symlinks from ~/.claude/
└── status.sh                      # Show dotclaude and external skills status
Makefile
```

## Usage

```bash
make install            # Symlink skills, agents, and config to ~/.claude/
make install-external   # Install external skills from external-skills.json
make uninstall          # Remove dotclaude symlinks from ~/.claude/
make status             # Show dotclaude and external skills status
```

## Adding Skills

Create `skills/<skill-name>/SKILL.md` with frontmatter:

```markdown
---
name: <skill-name>
description: Short description. When to trigger.
allowed-tools: Read, Grep, Glob
---

Prompt and instructions for the skill.
```

Then run `make install` to symlink it to `~/.claude/skills/`.

## Adding Agents

Create `agents/<agent-name>.md` with frontmatter:

```markdown
---
name: <agent-name>
description: Short description. When to use.
tools: Read, Grep, Glob
model: sonnet
---

System prompt for the agent.
```

Then run `make install` to symlink it to `~/.claude/agents/`.

## External Skills

Skills from [skills.sh](https://skills.sh/) are managed via `external-skills.json`.

Add an entry to the `skills` array:

```json
{
  "source": "<org>/<repo>",
  "name": "<skill-name>"
}
```

Then run `make install-external` to install via `npx skills`.

## Notes

Project-level `.claude/` overrides global config for same-named skills/agents.
