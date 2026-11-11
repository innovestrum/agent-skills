# InnoVestrum Agent Skills

One plugin for Claude Code and Codex: the InnoVestrum engineering standards ([`AGENTS.md`](AGENTS.md)) loaded into every session and subagent, plus a few skills.

## Install

**Claude Code**

```bash
claude plugin marketplace add InnoVestrum/agent-skills
claude plugin install innovestrum-standards@innovestrum
```

**Codex**

```bash
codex plugin marketplace add InnoVestrum/agent-skills
```

Then `/plugins` → install **innovestrum-standards**, and `/hooks` → review and trust its hooks. Codex skips a plugin's hooks until you trust them, so before that the skills work but the standards don't load. An update that changes the hook script needs the trust again.

## Upgrading from the symlink installer

> TODO(v1-migration): delete this section once no machine still carries the `install.sh` / `install.ps1` links.

The old installer linked this repo into each tool's global paths. Remove those links before installing the plugin, or the standards load twice:

```bash
find ~/.agents/skills ~/.claude/commands ~/.claude/CLAUDE.md ~/.codex/AGENTS.md ~/.config/AGENTS.md ~/.config/agents/AGENTS.md ~/.codeium/windsurf/memories/global_rules.md -maxdepth 1 -type l -lname '*agent-skills*' -delete 2>/dev/null
```

Then delete the old clone, `~/.agents/agent-skills` by default. On Windows the same links sit under `%USERPROFILE%`.

## Update

| Tool | Command |
|---|---|
| Claude Code | `claude plugin update innovestrum-standards@innovestrum`, or turn on auto-update for the marketplace in `/plugin` |
| Codex | `codex plugin marketplace upgrade innovestrum` |

## What's inside

**Standards.** A hook prints `AGENTS.md` at `SessionStart` and `SubagentStart`, so the main session and every subagent get the rules. A plugin has no other always-on channel: a `CLAUDE.md` inside one isn't loaded. The hook is a POSIX `sh` script, so on Windows it needs Git Bash.

**Skills**

| Skill | Use it when |
|---|---|
| [`research-an-idea`](skills/research-an-idea) | Researching an idea, market or open question before a decision: brief → parallel cited tracks → red team → synthesis |
| [`github-admin-ops`](skills/github-admin-ops) | A GitHub change needs `gh api` / `gh project` — org teams, branch protection, Projects v2 — and their gotchas |
| [`mark-deferred-work`](skills/mark-deferred-work) | Scope narrows mid-task and the follow-up needs a `TODO` marker with its why and re-visit trigger |
| [`refine-project-memory`](skills/refine-project-memory) | Auditing an agent's project memory: promote what still bites into canonical docs, delete the rest |

## Contributing

- A skill is `skills/<name>/SKILL.md`. Its `description` is the activation trigger; the body holds gaps, gotchas and pointers only (`AGENTS.md` § Documentation & Authoring). Leave out what a competent agent already knows: every description costs tokens in every session.
- `.claude-plugin/plugin.json` has no `version` on purpose, so installs track commits. Add one and every user stays on their cached copy until it changes.
- Keep `AGENTS.md` under 10,000 characters. Past that, Claude Code hands the model a file path and a 2,000-character preview instead of the rules.
- Codex loads this repo through its Claude-compatible paths (`.claude-plugin/marketplace.json`, `.claude-plugin/plugin.json`), so there is one manifest to maintain, not two.
- Run `claude plugin validate .` before pushing; its "No version specified" warning is the point above, not a defect. To try a change without installing: `claude --plugin-dir .`

## License

[MIT](LICENSE)
