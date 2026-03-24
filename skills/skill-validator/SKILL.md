---
name: skill-validator
description:
  Validate skill directories against the Agent Skills specification. Checks SKILL.md frontmatter,
  naming conventions, field limits, and allowed properties. Use when user asks to validate, check,
  or lint skills, or mentions skill validation. Requires skill-creator at ~/.claude/skills/skill-creator.
---

Validate skills at the given path using `quick_validate.py` from skill-creator.

Validation rules follow the Agent Skills specification:
- [Documentation](https://agentskills.io) - Guides and tutorials
- [Specification](https://agentskills.io/specification) - Format details
- [Example Skills](https://github.com/anthropics/skills) - See what's possible

## Dependency

This skill depends on **skill-creator** (`~/.claude/skills/skill-creator`). Specifically, it uses
`scripts/quick_validate.py` which checks SKILL.md frontmatter against the Agent Skills spec:
name format (kebab-case, max 64 chars), description (max 1024 chars, no angle brackets),
compatibility (max 500 chars), and no unexpected frontmatter fields.

If skill-creator is not installed, stop and tell the user:
"skill-validator requires skill-creator. Install it first: https://github.com/anthropics/skills"

## Steps

1. Verify `~/.claude/skills/skill-creator/scripts/quick_validate.py` exists.

2. List subdirectories at the provided path. Each subdirectory containing `SKILL.md` is a skill to validate.

3. Run validation for each skill:
   ```bash
   python3 ~/.claude/skills/skill-creator/scripts/quick_validate.py <skill-dir>
   ```

4. Collect results and present a summary table:

   ```
   Skill               Status
   ─────────────────────────────
   commit-proposal      ✓ valid
   my-broken-skill      ✗ Missing 'description' in frontmatter
   ```

5. If all skills pass, confirm success. If any fail, list the issues.
