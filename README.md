# InnoVestrum Agent Skills

Portable [Agent Skills](https://agentskills.io) and global engineering rules for InnoVestrum — shared across every AI coding tool you use.

## Architecture

```mermaid
%%{init: {"theme": "base", "themeVariables": {
  "background": "#ffffff",
  "primaryColor": "#f0f4ff",
  "primaryTextColor": "#1e1e2e",
  "primaryBorderColor": "#c0c8e8",
  "lineColor": "#94a3b8",
  "clusterBkg": "#f8faff",
  "clusterBorder": "#c0c8e8",
  "titleColor": "#64748b",
  "edgeLabelBackground": "#ffffff",
  "fontFamily": "ui-sans-serif, system-ui, sans-serif",
  "fontSize": "13px"
}}}%%
flowchart TD
    classDef repo    fill:#ede9fe,stroke:#7c3aed,color:#4c1d95,font-weight:600
    classDef install fill:#f0fdf4,stroke:#16a34a,color:#14532d
    classDef tool    fill:#eff6ff,stroke:#2563eb,color:#1e3a8a
    classDef loop    fill:#fff7ed,stroke:#ea580c,color:#7c2d12

    REPO(["🗂  agent-skills · github.com/InnoVestrum"]):::repo

    subgraph INSTALL ["  ⚙  one-time install  "]
        direction LR
        I1("skills & rules"):::install
        I2("slash commands"):::install
        I3("MCPs + claude-reflect"):::install
    end

    subgraph TOOLS ["  🛠  AI tools  "]
        direction LR
        WS("Windsurf"):::tool
        CC("Claude Code"):::tool
        CX("Cursor · Codex · Copilot"):::tool
    end

    subgraph LOOP ["  🔄  self-learning loop  "]
        direction LR
        L1("auto-capture corrections"):::loop
        L2("/reflect-triage"):::loop
        L3("route & commit"):::loop
    end

    REPO -->|"git clone + install.sh"| INSTALL
    I1 --> WS & CC & CX
    I2 & I3 --> CC

    CC --> LOOP
    L1 --> L2 --> L3
    L3 -->|"git push"| REPO
```

## Compatibility

| Feature | Windsurf | Claude Code | Codex CLI | Cursor | Copilot |
|---|:---:|:---:|:---:|:---:|:---:|
| Global rules (`AGENTS.md`) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Skills (`~/.agents/skills/`) | ✅ | ✅ | ✅ | ✅ | ✅ |
| MCP servers (context7, brave-search) | 🔧 | ✅ | 🔧 | 🔧 | ➖ |
| GitHub (native OAuth) | ➖ | ✅ | ➖ | ➖ | ➖ |
| `/reflect-triage` slash command | ❌ | ✅ | ❌ | ❌ | ❌ |
| `claude-reflect` auto-capture | ❌ | ✅ | ❌ | ❌ | ❌ |

> 🔧 = guided setup via `setup-mcps` skill

## Installation

```bash
git clone https://github.com/InnoVestrum/agent-skills.git ~/.agents/agent-skills
bash ~/.agents/agent-skills/install.sh
```

Cloning is required — the self-learning loop (`/reflect-triage`) commits and pushes skill and rule changes back to this repo. A `curl | bash` approach would have no git history to push to.

**What `install.sh` does:** symlinks skills, global rules, and slash commands; creates the canonical repo symlink. It does **not** install the Claude Code plugin — that step is manual (see below).

To update: `git -C ~/.agents/agent-skills pull && bash ~/.agents/agent-skills/install.sh`

### Claude Code plugin (manual)

Open Claude Code and run:

```
/plugin marketplace add InnoVestrum/agent-skills
/plugin install innovestrum-standards@innovestrum
```

You'll be prompted for a GitHub Personal Access Token (`repo`, `read:org` from [github.com/settings/tokens](https://github.com/settings/tokens)). This interactive flow is the only supported path — the `claude plugin install` shell command cannot pass `userConfig` values, which leaves the GitHub MCP unconfigured and silently dropped.

### MCP setup for other tools

After install, ask your agent *"set up MCPs"* — it will invoke the `setup-mcps` skill.

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
