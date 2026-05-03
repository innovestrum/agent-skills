---
name: manage-skills
description: Add, edit, or delete a skill in the InnoVestrum agent-skills repo.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Repo: `~/github/agent-skills`. Skills are symlinked — edits are live instantly.

**Add:** create `skills/<name>/SKILL.md` (frontmatter: `name`, `description`; body: actionable guidelines), then symlink + commit.
```bash
mkdir -p ~/github/agent-skills/skills/<name>
# write SKILL.md
ln -s ~/github/agent-skills/skills/<name> ~/.agents/skills/<name>
git -C ~/github/agent-skills add -A && git -C ~/github/agent-skills commit -m "feat: add <name> skill" && git -C ~/github/agent-skills push
```

**Edit:** modify `skills/<name>/SKILL.md` directly, then commit.

**Delete:**
```bash
rm ~/.agents/skills/<name>
rm -rf ~/github/agent-skills/skills/<name>
git -C ~/github/agent-skills add -A && git -C ~/github/agent-skills commit -m "feat: remove <name> skill" && git -C ~/github/agent-skills push
```

**Rules:** `description` = one-sentence activation trigger. Skills add domain depth; global rules go in `AGENTS.md`.
