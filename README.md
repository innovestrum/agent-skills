# InnoVestrum Agent Skills

Portable [Agent Skills](https://agentskills.io) and global engineering rules for InnoVestrum — shared across every AI coding tool you use.

## Architecture

```mermaid
%%{init: {"theme": "base", "themeVariables": {
  "background": "#181825",
  "primaryColor": "#313244",
  "primaryTextColor": "#cdd6f4",
  "primaryBorderColor": "#45475a",
  "lineColor": "#6c7086",
  "secondaryColor": "#1e1e2e",
  "tertiaryColor": "#1e1e2e",
  "clusterBkg": "#1e1e2e",
  "clusterBorder": "#45475a",
  "titleColor": "#cdd6f4",
  "edgeLabelBackground": "#181825",
  "fontFamily": "ui-monospace, monospace"
}}}%%
flowchart LR
    classDef repo    fill:#2a273f,stroke:#cba6f7,color:#cdd6f4,font-weight:bold
    classDef install fill:#1e2d1e,stroke:#a6e3a1,color:#a6e3a1
    classDef tool    fill:#1a2535,stroke:#89b4fa,color:#89b4fa
    classDef loop    fill:#2d1e1e,stroke:#fab387,color:#fab387

    REPO(["  agent-skills\n  github.com/InnoVestrum"]):::repo

    subgraph INSTALL ["  ⚙ one-time install  "]
        I1("skills & rules"):::install
        I2("slash commands"):::install
        I3("MCPs + claude-reflect"):::install
    end

    subgraph TOOLS ["  🛠 AI tools  "]
        CC("Claude Code"):::tool
        WS("Windsurf"):::tool
        CX("Cursor · Codex · Copilot"):::tool
    end

    subgraph LOOP ["  🔄 self-learning loop  "]
        L1("auto-capture\ncorrections"):::loop
        L2("/reflect-triage"):::loop
        L3("route & commit"):::loop
    end

    REPO -->|"install.sh"| INSTALL
    I1 --> CC & WS & CX
    I2 --> CC
    I3 --> CC
    CC --> L1 --> L2 --> L3 -->|"git push"| REPO
```

## Compatibility

| Feature | Windsurf | Claude Code | Codex CLI | Cursor | Copilot |
|---|:---:|:---:|:---:|:---:|:---:|
| Global rules (`AGENTS.md`) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Skills (`~/.agents/skills/`) | ✅ | ✅ | ✅ | ✅ | ✅ |
| MCP servers (github, context7, brave) | 🔧 | ✅ | 🔧 | 🔧 | ➖ |
| `/reflect-triage` slash command | ❌ | ✅ | ❌ | ❌ | ❌ |
| `claude-reflect` auto-capture | ❌ | ✅ | ❌ | ❌ | ❌ |

> 🔧 = guided setup via `setup-mcps` skill

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/InnoVestrum/agent-skills/main/install.sh | bash
```

Installs skills, global rules, slash commands, and — if the `claude` CLI is present — the Claude Code plugin (MCPs + `claude-reflect`) automatically.

To update: `git -C ~/.agents/agent-skills pull && bash ~/.agents/agent-skills/install.sh`

**Manual plugin install (Claude Code):**
```bash
claude plugin marketplace add InnoVestrum/agent-skills
claude plugin install innovestrum-standards@innovestrum
```
Then configure API tokens (`claude plugin config innovestrum-standards`) and restart Claude Code.

**MCP setup for other tools:** after install, ask your agent *"set up MCPs"* — it will invoke the `setup-mcps` skill.

## Self-Learning Workflow

Corrections you make during coding are automatically captured by `claude-reflect` and queued. Run `/reflect-triage` weekly to review and route each item:

- `[g]lobal` → appended to `AGENTS.md`, committed and pushed (propagates to all tools via symlink)
- `[p]roject` → written to the local `CLAUDE.md`
- `[s]kill` → new or updated skill via `manage-skills`
- `[c]ommand` → new slash command via `manage-commands` (for recurring interactive rituals)
- `[d]iscard` → dropped

> Rule of thumb: *"Would this apply to a brand-new project?"* → yes = global, no = project, procedure = skill.

## Skills

| Skill | Description |
|---|---|
| [`manage-rules`](skills/manage-rules) | Add, edit, or delete global engineering rules in `AGENTS.md` |
| [`manage-skills`](skills/manage-skills) | Add, edit, or delete skills in this repository |
| [`manage-commands`](skills/manage-commands) | Add, edit, or delete Claude Code slash commands |
| [`manage-mcps`](skills/manage-mcps) | Add, edit, or remove MCP server declarations |
| [`setup-mcps`](skills/setup-mcps) | Guided MCP setup for Windsurf, Cursor, Codex, and Claude Code |

## Slash Commands

| Command | Description |
|---|---|
| [`/reflect-triage`](commands/reflect-triage.md) | Triage the `claude-reflect` learnings queue with smart routing and human approval |

## Skill Format

Each skill follows the [agentskills.io spec](https://agentskills.io/specification) — YAML frontmatter + Markdown body in `skills/<name>/SKILL.md`. The agent loads only `name` and `description` at startup (progressive disclosure), reading the full file only when the skill is relevant.

See [CONTRIBUTING.md](./CONTRIBUTING.md) to add or improve skills.

## License

[MIT](./LICENSE)
