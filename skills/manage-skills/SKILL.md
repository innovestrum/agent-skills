---
name: manage-skills
description: Use when the user wants to add, edit, rename, or delete a skill in the InnoVestrum agent-skills repository at ~/github/agent-skills. Activate when the user says things like "add a skill", "update the skill", "remove the skill", or "create a new skill for X".
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

## Managing InnoVestrum Skills

The skills repository lives at `~/github/agent-skills`. Skills are symlinked globally via `install.sh` — no reinstall needed after editing.

### Add a skill

1. Create a new directory under `skills/`:
   ```bash
   mkdir ~/github/agent-skills/skills/<skill-name>
   ```
2. Create `SKILL.md` using the template at `skills/.example/SKILL.md`:
   - Set `name`, `description` (activation trigger sentence), `metadata`
   - Write clear, actionable guidelines in the body
3. Symlink it globally:
   ```bash
   ln -s ~/github/agent-skills/skills/<skill-name> ~/.agents/skills/<skill-name>
   ```
4. Commit and push:
   ```bash
   git -C ~/github/agent-skills add skills/<skill-name> && \
   git -C ~/github/agent-skills commit -m "feat: add <skill-name> skill" && \
   git -C ~/github/agent-skills push
   ```

### Edit a skill

Edit `~/github/agent-skills/skills/<skill-name>/SKILL.md` directly — the symlink means changes are live immediately. Then commit:
```bash
git -C ~/github/agent-skills add skills/<skill-name>/SKILL.md && \
git -C ~/github/agent-skills commit -m "feat: update <skill-name> skill" && \
git -C ~/github/agent-skills push
```

### Delete a skill

```bash
rm ~/.agents/skills/<skill-name>
rm -rf ~/github/agent-skills/skills/<skill-name>
git -C ~/github/agent-skills add -A && \
git -C ~/github/agent-skills commit -m "feat: remove <skill-name> skill" && \
git -C ~/github/agent-skills push
```

### Update all skills from remote

```bash
git -C ~/github/agent-skills pull
```

### Skill quality checklist

- `description` is one sentence answering: "when should the agent activate this?"
- Body contains specific, actionable instructions — not vague principles
- No duplication with `AGENTS.md` — skills add domain depth, not global rules
