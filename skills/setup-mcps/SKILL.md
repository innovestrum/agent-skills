---
name: setup-mcps
description: Guide the user through setting up InnoVestrum MCP servers (github, context7, brave-search) for their current IDE or agent tool.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

Detect the user's tool, then give the exact install command for each MCP.

**Plugin Servers (auto-installed):**
| Name | Package | Token needed |
|---|---|---|
| `context7` | `@upstash/context7-mcp` | No |
| `brave-search` | `@anthropic/mcp-server-brave-search` | Brave API key |

**GitHub** — uses Claude Code's native OAuth (no plugin setup needed)

**Claude Code** — `context7` and `brave-search` auto-install with the plugin. If missing:
```bash
claude mcp add-json context7 '{"command":"npx","args":["-y","@upstash/context7-mcp"]}'
claude mcp add-json brave-search '{"command":"npx","args":["-y","@anthropic/mcp-server-brave-search"],"env":{"BRAVE_API_KEY":"YOUR_KEY"}}'
```

GitHub tools work via native OAuth — no manual MCP setup needed.

**Windsurf** — merge into `~/.codeium/windsurf/mcp_config.json`:
```json
{ "mcpServers": { "context7": { "command": "npx", "args": ["-y", "@upstash/context7-mcp"] } } }
```
Add `github` and `brave-search` entries the same way with their env tokens.

**Cursor** — merge into `~/.cursor/mcp.json` (same JSON shape as Windsurf).

**Codex** — merge into `~/.codex/mcp.json` (same JSON shape as Windsurf).

After editing any config, restart the tool. Verify with `/mcp` (Claude Code) or the MCP panel in Windsurf/Cursor.

Token links: [GitHub PAT](https://github.com/settings/tokens) · [Brave API](https://brave.com/search/api/)
