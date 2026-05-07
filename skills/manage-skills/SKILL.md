---
name: manage-skills
description: Manage InnoVestrum global agent skills — activate when user asks to add, update, or remove a skill from the shared InnoVestrum agent-skills repo.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Skills live at `~/.agents/agent-skills/skills/<name>/SKILL.md`. New skills need a manual `ln -sf <source> ~/.agents/skills/<name>` until next `install.sh` run.

**Writing skills (apply the global Documentation & Authoring rule from `AGENTS.md`):**

- `description` is a one-sentence **activation trigger**, not a summary.
- Body = gaps, gotchas, pointers only. Drop generic CLI/API syntax, flag enums, restated `AGENTS.md` rules.
- After drafting, re-read and cut every line that isn't a gap, gotcha, or pointer. Under ~30 lines is usually correct.

**Gotchas:**

- Orphan symlinks in `~/.agents/skills/` keep working after the source is deleted; remove both.
- Skills are picked up at session start; restart the agent after changes.
