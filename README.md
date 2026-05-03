# InnoVestrum Agent Skills

A collection of portable [Agent Skills](https://agentskills.io) encoding InnoVestrum's engineering standards. Compatible with **Claude Code**, **Windsurf**, **Codex**, **Cursor**, **GitHub Copilot**, and any tool that supports the [agentskills.io](https://agentskills.io) open standard.

## Skills

| Skill | Description |
|---|---|
| [`coding-standards`](./skills/coding-standards/) | Clean-code, DRY, KISS, YAGNI principles |
| [`oop-architecture`](./skills/oop-architecture/) | OOP, SOLID, GRASP, dependency injection & IoC |
| [`cloud-native`](./skills/cloud-native/) | 12-factor, Docker/Alpine, env config, observability |
| [`code-quality`](./skills/code-quality/) | Cyclomatic/cognitive complexity, coupling, maintainability |

## Installation

> **Private repo** — clone first, then install. All methods below require you to have read access to `InnoVestrum/agent-skills`.

### Step 1 — Clone once (all tools)

```bash
git clone https://github.com/InnoVestrum/agent-skills.git ~/github/agent-skills
```

### Step 2a — Claude Code plugin (recommended)

Add the marketplace and install — Claude Code fetches directly from GitHub via HTTPS:

```
/plugin marketplace add InnoVestrum/agent-skills
/plugin install innovestrum-standards@innovestrum
```

Or use the local clone (no network required after clone):

```bash
claude --plugin-dir ~/github/agent-skills
```

Update anytime:
```bash
git -C ~/github/agent-skills pull
/plugin update innovestrum-standards@innovestrum
```

### Step 2b — Windsurf / Codex / Cursor

Run the install script from the cloned repo:

```bash
bash ~/github/agent-skills/install.sh
```

This symlinks all skills into global skill dirs for Windsurf, Claude Code, and Codex. Re-run after `git pull` to pick up updates.

#### Manual (single tool, workspace scope)

```bash
# Windsurf
cp -r ~/github/agent-skills/skills/* .windsurf/skills/

# Claude Code
cp -r ~/github/agent-skills/skills/* .claude/skills/

# Codex
cp -r ~/github/agent-skills/skills/* .agents/skills/
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
