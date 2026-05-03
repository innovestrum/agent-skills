---
name: manage-rules
description: Manage InnoVestrum global engineering rules — activate when user asks to add, update, or remove a rule from the shared InnoVestrum standards applied across all AI tools.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Single source: `~/.agents/agent-skills/AGENTS.md` — symlinked to Windsurf, Claude Code, Codex, Amp, and XDG path. Edit once, applies everywhere.

If `~/.agents/agent-skills` doesn't exist, clone it first:
```bash
git clone https://github.com/InnoVestrum/agent-skills.git ~/.agents/agent-skills
```

**Add/Edit/Delete:** modify `~/.agents/agent-skills/AGENTS.md` directly, then commit.
```bash
git -C ~/.agents/agent-skills add AGENTS.md && git -C ~/.agents/agent-skills commit -m "feat: update rules" && git -C ~/.agents/agent-skills push
```

**Rules:** boundaries over aspirations ("always ask before hardcoding" not "write clean code"). Tool-agnostic only; domain depth goes in Skills.
