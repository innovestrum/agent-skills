---
name: manage-rules
description: Use when the user wants to add, edit, or remove global engineering rules that apply across all AI tools (Windsurf, Claude Code, Codex, Cursor, etc.). Activate when the user says things like "add a rule", "update our standards", "change the global rules", or "remove rule X".
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

## Managing InnoVestrum Global Rules

Global engineering rules live in a single source of truth:
```
~/github/agent-skills/AGENTS.md
```

This file is symlinked to all tools — editing it once updates everywhere:

| Tool | Symlink target |
|---|---|
| Windsurf | `~/.codeium/windsurf/memories/global_rules.md` |
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex CLI | `~/.codex/AGENTS.md` |
| Amp | `~/.config/AGENTS.md` |
| XDG standard | `~/.config/agents/AGENTS.md` |

### Add a rule

Open `~/github/agent-skills/AGENTS.md` and add to the appropriate section. If no section fits, create one. Then commit:
```bash
git -C ~/github/agent-skills add AGENTS.md && \
git -C ~/github/agent-skills commit -m "feat: add rule — <brief description>" && \
git -C ~/github/agent-skills push
```

### Edit a rule

Edit `~/github/agent-skills/AGENTS.md` directly — changes are live immediately across all tools. Then commit.

### Delete a rule

Remove the line from `~/github/agent-skills/AGENTS.md`. Then commit.

### Pull latest rules from remote

```bash
git -C ~/github/agent-skills pull
```

### Guidelines for writing rules

- State facts and boundaries, not aspirations — "always ask before hardcoding" beats "write clean code"
- Each rule should change agent behaviour in a measurable way
- Keep rules in `AGENTS.md` global and tool-agnostic; put project/domain-specific guidance in Skills
- Keep total size under 500 lines to avoid context bloat
