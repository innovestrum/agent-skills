# InnoVestrum Agent Skills

A collection of portable [Agent Skills](https://agentskills.io) encoding InnoVestrum's engineering standards. Compatible with **Claude Code**, **Windsurf**, **Codex**, **Cursor**, **GitHub Copilot**, and any tool that supports the [agentskills.io](https://agentskills.io) open standard.

## Skills

| Skill | Description |
|---|---|
| [`manage-skills`](./skills/manage-skills/) | Add, edit, or delete skills in this repository |
| [`manage-rules`](./skills/manage-rules/) | Add, edit, or delete global engineering rules in `AGENTS.md` |

## Installation

### All [agentskills.io](https://agentskills.io) compatible tools — one command

Symlinks all skills into `~/.agents/skills/` and installs `AGENTS.md` as global rules for all tools:

```bash
curl -fsSL https://raw.githubusercontent.com/InnoVestrum/agent-skills/main/install.sh | bash
```

**What gets installed:**
- Skills → `~/.agents/skills/` (Windsurf, Cursor, Copilot, Codex, all agentskills.io clients)
- `AGENTS.md` → `~/.config/agents/AGENTS.md`, `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.config/AGENTS.md`, `~/.codeium/windsurf/memories/global_rules.md`

To update: `git -C ~/github/agent-skills pull && bash ~/github/agent-skills/install.sh`

### Claude Code — plugin install (independent)

Claude Code supports skills via `~/.agents/skills/` **and** via its plugin system. To use the plugin approach (enables `/plugin update`, versioning, and marketplace browsing):

```
/plugin marketplace add InnoVestrum/agent-skills
/plugin install innovestrum-standards@innovestrum
```

## Skill Format

Each skill follows the [agentskills.io specification](https://agentskills.io/specification):

```
skills/
└── <skill-name>/
    ├── SKILL.md        # Required: YAML frontmatter + Markdown instructions
    ├── references/     # Optional: reference docs loaded on demand
    └── assets/         # Optional: templates, checklists
```

Skills use **progressive disclosure** — the agent loads only the `name` and `description` at startup, then reads the full `SKILL.md` only when it decides the skill is relevant. This keeps context window usage minimal.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to add or improve skills.

## License

[MIT](./LICENSE)
