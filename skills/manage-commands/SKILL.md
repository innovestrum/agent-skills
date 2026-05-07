---
name: manage-commands
description: Manage InnoVestrum Claude Code slash commands — activate when user asks to add, update, or remove a slash command from the agent-skills repo.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Source: `~/.agents/agent-skills/commands/<name>.md`. `install.sh` symlinks it to `~/.claude/commands/<name>.md` so Claude Code surfaces it as `/<name>`.

**Gotchas:**

- New commands need a manual `ln -sf` until the next `install.sh` run; otherwise Claude Code won't see them.
- Deleting requires removing **both** the symlink in `~/.claude/commands/` and the source file — orphan symlinks silently still work.
- The frontmatter `description` is what shows in the `/` autocomplete; missing it = invisible command.

Commit changes to the repo so other tools picking up via `install.sh` stay in sync.
