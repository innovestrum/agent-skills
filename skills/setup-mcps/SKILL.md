---
name: setup-mcps
description: Guide the user through setting up InnoVestrum MCP servers (github, context7, brave-search) for their current IDE or agent tool.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Detect the user's tool first, then give the exact entry to add. Configs and wrapper shape per tool live in the `manage-mcps` skill — read it for the file paths.

| Server | Package | Token |
|---|---|---|
| `context7` | `@upstash/context7-mcp` | none |
| `brave-search` | `@anthropic/mcp-server-brave-search` | `BRAVE_API_KEY` ([brave.com/search/api](https://brave.com/search/api/)) |
| `github` | — | uses Claude Code's native OAuth; no MCP entry needed there |

**Gotchas:**

- Claude Code: `context7` + `brave-search` auto-install with the plugin. Only add manually (`claude mcp add-json ...`) if the plugin install was skipped.
- Windsurf / Cursor / Codex have no native GitHub OAuth — they need the `github` MCP entry with a PAT ([github.com/settings/tokens](https://github.com/settings/tokens)).
- Restart the tool after editing config; verify with `/mcp` (Claude Code) or the MCP panel.
