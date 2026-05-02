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

### Windsurf (workspace)

```bash
cp -r skills/* .windsurf/skills/
```

### Windsurf (global — all workspaces)

```bash
cp -r skills/* ~/.codeium/windsurf/skills/
```

### Claude Code (workspace)

```bash
cp -r skills/* .claude/skills/
```

### Claude Code (global)

```bash
cp -r skills/* ~/.claude/skills/
```

### Codex (workspace)

```bash
cp -r skills/* .agents/skills/
```

### All tools at once (workspace)

```bash
mkdir -p .windsurf/skills .claude/skills .agents/skills
cp -r skills/* .windsurf/skills/
cp -r skills/* .claude/skills/
cp -r skills/* .agents/skills/
```

Or use symlinks to stay in sync with updates from this repo:

```bash
ln -s /path/to/agent-skills/skills/coding-standards .windsurf/skills/coding-standards
ln -s /path/to/agent-skills/skills/coding-standards .claude/skills/coding-standards
# repeat for each skill
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
