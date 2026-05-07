---
name: manage-rules
description: Manage InnoVestrum global engineering rules — activate when user asks to add, update, or remove a rule from the shared InnoVestrum standards applied across all AI tools.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Single source: `~/.agents/agent-skills/AGENTS.md`. Symlinked into Windsurf / Claude Code / Codex / Amp / XDG paths by `install.sh` — edit once, applies everywhere.

**Pointers:**

- Rules are **boundaries**, not aspirations: "always ask before hardcoding", not "write clean code". If it can't be checked, it doesn't belong here.
- Tool-agnostic only. Anything tool- or domain-specific goes in a Skill, not here.
- Project-specific rules belong in the project's own `AGENTS.md`, not the global one.
