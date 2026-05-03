---
name: manage-skills
description: Manage InnoVestrum global agent skills — activate when user asks to add, update, or remove a skill from the shared InnoVestrum agent-skills repo.
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

**Writing skills:** `description` = one-sentence activation trigger. Be laconic — omit what the agent already knows. Domain depth only; global rules go in `AGENTS.md`.
