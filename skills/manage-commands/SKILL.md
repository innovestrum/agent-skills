---
name: manage-commands
description: Manage InnoVestrum Claude Code slash commands — activate when user asks to add, update, or remove a slash command from the agent-skills repo.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Canonical repo: `~/.agents/agent-skills` (symlink created by `install.sh`, or cloned directly).

If `~/.agents/agent-skills` doesn't exist, clone it first:
```bash
git clone https://github.com/InnoVestrum/agent-skills.git ~/.agents/agent-skills
```

Commands live in `~/.agents/agent-skills/commands/` and are symlinked to `~/.claude/commands/` by `install.sh`. Claude Code picks them up as `/command-name`.

**Add:**
```bash
# Create commands/<name>.md with YAML frontmatter: description field
# install.sh re-run will symlink it, or symlink manually:
ln -sf ~/.agents/agent-skills/commands/<name>.md ~/.claude/commands/<name>.md
git -C ~/.agents/agent-skills add -A && git -C ~/.agents/agent-skills commit -m "feat: add <name> command" && git -C ~/.agents/agent-skills push
```

**Edit:** modify `~/.agents/agent-skills/commands/<name>.md` directly, then commit.

**Delete:**
```bash
rm ~/.claude/commands/<name>.md
rm ~/.agents/agent-skills/commands/<name>.md
git -C ~/.agents/agent-skills add -A && git -C ~/.agents/agent-skills commit -m "feat: remove <name> command" && git -C ~/.agents/agent-skills push
```

**Command format:** YAML frontmatter with a `description` field, then Markdown body with the full agent instruction. The description shows in Claude Code's autocomplete when typing `/`.
