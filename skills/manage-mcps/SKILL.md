---
name: manage-mcps
description: Manage InnoVestrum MCP server declarations — activate when user asks to add, update, or remove an MCP server from the plugin or tool configs.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

| Target | File | Wrapper |
|---|---|---|
| Claude Code plugin | `~/.agents/agent-skills/.mcp.json` | **flat** (`{"name": {...}}`) |
| Windsurf | `~/.codeium/windsurf/mcp_config.json` | `{"mcpServers": {...}}` |
| Cursor | `~/.cursor/mcp.json` | `{"mcpServers": {...}}` |
| Codex | `~/.codex/mcp.json` | `{"mcpServers": {...}}` |

**Gotchas:**

- The plugin file is the **only** flat-shape one. Pasting a `mcpServers`-wrapped block there silently no-ops.
- Plugin servers needing user tokens require a matching `userConfig` entry in `.claude-plugin/plugin.json` (`${user_config.<key>}` template).
- Tool restart required after edits. Verify with `/mcp` (Claude Code) or the tool's MCP panel.
