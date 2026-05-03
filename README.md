# InnoVestrum Agent Skills

A collection of portable [Agent Skills](https://agentskills.io) encoding InnoVestrum's engineering standards.

## Compatibility

| Feature | Windsurf | Claude Code | Codex CLI | Cursor | Copilot |
|---|:---:|:---:|:---:|:---:|:---:|
| Global rules (`AGENTS.md`) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Skills (`~/.agents/skills/`) | ✅ | ✅ | ✅ | ✅ | ✅ |
| MCP servers (github, context7, brave) | 🔧 | ✅ | 🔧 | 🔧 | ➖ |
| `/reflect-triage` slash command | ❌ | ✅ | ❌ | ❌ | ❌ |
| `claude-reflect` auto-capture | ❌ | ✅ | ❌ | ❌ | ❌ |

## Skills

| Skill | Description |
|---|---|
| [`manage-skills`](skills/manage-skills) | Add, edit, or delete skills in this repository |
| [`manage-rules`](skills/manage-rules) | Add, edit, or delete global engineering rules in `AGENTS.md` |
| [`setup-mcps`](skills/setup-mcps) | Guided MCP server setup for Windsurf, Cursor, Codex, and Claude Code |

Both skills are invoked automatically by `/reflect-triage` when routing learnings, but you can also call them directly in any chat.

## Slash Commands

Custom Claude Code slash commands that work alongside the skills.

| Command | Description |
|---|---|
| [`/reflect-triage`](commands/reflect-triage.md) | Process the [claude-reflect](https://github.com/BayramAnnakov/claude-reflect) learnings queue with smart routing — global rules go into `AGENTS.md`, procedural learnings become skills, project-specific rules stay in the project's `CLAUDE.md`. Each routing decision requires explicit human approval. |

## Installation

### Step 1 — Universal base install (all tools)

Installs skills and global rules for every agentskills.io-compatible tool:

```bash
curl -fsSL https://raw.githubusercontent.com/InnoVestrum/agent-skills/main/install.sh | bash
```

**What gets installed:**
- Skills → `~/.agents/skills/`
- `AGENTS.md` → `~/.config/agents/AGENTS.md`, `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.config/AGENTS.md`, `~/.codeium/windsurf/memories/global_rules.md`
- Repo symlink → `~/.agents/agent-skills` (canonical path used by all skills)

To update: `git -C ~/.agents/agent-skills pull && bash ~/.agents/agent-skills/install.sh`

### Step 2a — Claude Code: plugin install

Adds MCP servers (github, context7, brave-search), `/reflect-triage` command, and `claude-reflect` on top of the base install:

```
/plugin marketplace add InnoVestrum/agent-skills
/plugin install innovestrum-standards@innovestrum
```

Configure API tokens when prompted (or `/plugin config innovestrum-standards`), then **restart Claude Code**.

Verify:
```
/plugin list   → innovestrum-standards, claude-reflect
/mcp           → github, context7, brave-search
/reflect       → reflect-triage (autocomplete)
```

### Step 2b — Windsurf / Cursor / Codex: guided MCP setup

After the base install, ask your agent: *"set up MCPs"* — it will invoke the `setup-mcps` skill and walk you through the exact config for your tool.

## Self-Learning Workflow

This repo combines three primitives to capture engineering preferences as you work:

```
chat correction      →  claude-reflect  →  ~/.claude/learnings-queue.json
                            (hooks)

weekly ritual        →  /reflect-triage  →  routes each item to:
                                                ├─ AGENTS.md (global)
                                                ├─ ./CLAUDE.md (project)
                                                ├─ skills/ (procedural)
                                                └─ discard

global writes        →  symlink propagates to all tools, then commit & push
```

### How it works

1. **Capture (automatic).** While you work, when you correct Claude (`"no, use X"`, `"actually..."`, `"remember:..."`), the claude-reflect plugin's hooks detect the pattern and queue the learning at `~/.claude/learnings-queue.json` with a confidence score.

2. **Triage (weekly, manual).** Run `/reflect-triage` inside Claude Code. For each queued learning the command:
   - shows the captured correction and a suggested route,
   - waits for your decision (`[g]lobal` / `[p]roject` / `[s]kill` / `[d]iscard`),
   - hands the write off to the matching skill (`manage-rules` for global, `manage-skills` for skill changes),
   - shows the diff inside this repo and prompts you to commit & push.

3. **Distribute.** Because `install.sh` symlinks `AGENTS.md` to every tool's global rules path, your push immediately makes the new rule available across Claude Code, Codex, Cursor, Windsurf, and Copilot — no per-tool sync needed.

### Decision criterion

When triaging, the rule of thumb is: *"If I deleted my current project tomorrow and started a new one, would this rule still apply?"*

- **Yes** → global (lands in `AGENTS.md`, gets committed to this repo)
- **No** → project (stays in the project's local `CLAUDE.md`)
- **It's a procedure, not a declaration** → skill

### Setup checklist

After running `install.sh`:

1. Restart Claude Code (required to activate the plugin).
2. Verify the plugin: `/plugin list` should show `claude-reflect`.
3. Verify the command: typing `/reflect` should show `reflect-triage` as an option.
4. (Optional but recommended) Extend session retention so historical scans work — add to `~/.claude/settings.json`:

   ```json
   { "sessionRetentionDays": 90 }
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
