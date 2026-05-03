---
name: manage-rules
description: Manage InnoVestrum global engineering rules — activate when user asks to add, update, or remove a rule from the shared InnoVestrum standards applied across all AI tools.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Single source: `~/github/agent-skills/AGENTS.md` — symlinked to Windsurf, Claude Code, Codex, Amp, and XDG path. Edit once, applies everywhere.

**Add/Edit/Delete:** modify `AGENTS.md` directly, then commit.
```bash
git -C ~/github/agent-skills add AGENTS.md && git -C ~/github/agent-skills commit -m "feat: update rules" && git -C ~/github/agent-skills push
```

**Rules:** boundaries over aspirations ("always ask before hardcoding" not "write clean code"). Tool-agnostic only; domain depth goes in Skills.
