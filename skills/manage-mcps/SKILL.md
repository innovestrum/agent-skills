---
name: manage-mcps
description: Manage InnoVestrum MCP server declarations — activate when user asks to add, update, or remove an MCP server from the plugin or tool configs.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

MCP servers are declared in two places depending on the target:

| Target | File |
|---|---|
| Claude Code plugin | `~/.agents/agent-skills/.claude-plugin/mcp-config.json` |
| Windsurf | `~/.codeium/windsurf/mcp_config.json` |
| Cursor | `~/.cursor/mcp.json` |
| Codex | `~/.codex/mcp.json` |

**Add to Claude Code plugin:**

Edit `~/.agents/agent-skills/.claude-plugin/mcp-config.json` — add an entry under `mcpServers`:
```json
"<name>": {
  "command": "npx",
  "args": ["-y", "<package>"],
  "env": { "API_KEY": "${user_config.<key>}" }
}
```
If the server needs a user token, add a corresponding entry to `userConfig` in `.claude-plugin/plugin.json`.

Then commit and push:
```bash
git -C ~/.agents/agent-skills add -A && git -C ~/.agents/agent-skills commit -m "feat: add <name> MCP" && git -C ~/.agents/agent-skills push
```

**Add to Windsurf / Cursor / Codex:**

Merge directly into the tool's config file — ask the user which tool, then add the `mcpServers` entry. For remote HTTP servers:
```json
"<name>": { "type": "http", "url": "<url>", "headers": { "Authorization": "Bearer <token>" } }
```
For stdio servers:
```json
"<name>": { "command": "npx", "args": ["-y", "<package>"], "env": { "KEY": "value" } }
```

**Remove:** delete the entry from the relevant config file. For plugin changes, commit and push.

**Verify (Claude Code):** `/mcp` lists active servers. Restart Claude Code after any plugin config change.
