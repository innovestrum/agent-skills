---
name: manage-skills
description: Manage InnoVestrum global agent skills — activate when user asks to add, update, or remove a skill from the shared InnoVestrum agent-skills repo.
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

**Add:** create `skills/<name>/SKILL.md` (frontmatter: `name`, `description`; body: actionable guidelines), then symlink + commit.
```bash
mkdir -p ~/.agents/agent-skills/skills/<name>
# write SKILL.md
ln -sf ~/.agents/agent-skills/skills/<name> ~/.agents/skills/<name>
git -C ~/.agents/agent-skills add -A && git -C ~/.agents/agent-skills commit -m "feat: add <name> skill" && git -C ~/.agents/agent-skills push
```

**Edit:** modify `~/.agents/agent-skills/skills/<name>/SKILL.md` directly, then commit.

**Delete:**
```bash
rm ~/.agents/skills/<name>
rm -rf ~/.agents/agent-skills/skills/<name>
git -C ~/.agents/agent-skills add -A && git -C ~/.agents/agent-skills commit -m "feat: remove <name> skill" && git -C ~/.agents/agent-skills push
```

**Writing skills:** `description` = one-sentence activation trigger. Domain depth only; global rules go in `AGENTS.md`.

**Keep only what the agent can't infer.** Before writing each line, ask: *would a competent agent already know this?* If yes, drop it. Specifically drop:

- Generic CLI/API syntax, flag enumerations, standard usage examples
- Obvious patterns (loops, retries, basic shell idioms)
- Restated rules from `AGENTS.md`

**Keep:** gaps (what's *not* available where the agent would expect it), gotchas (silent failures, paywalls, auto-behaviors, exit-code lies), and pointers (use X here, not Y).

A good skill reads like a senior engineer's terse handover note, not a tutorial. After drafting, re-read and cut every line that isn't a gap, gotcha, or pointer. If it shrinks below ~30 lines, that's usually correct.
