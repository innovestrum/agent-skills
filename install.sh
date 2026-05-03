#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
COMMANDS_DIR="$REPO_DIR/commands"
AGENTS_MD="$REPO_DIR/AGENTS.md"
TARGET_DIR="$HOME/.agents/skills"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

install_skills() {
  mkdir -p "$TARGET_DIR"
  for skill_path in "$SKILLS_DIR"/*/; do
    skill_name="$(basename "$skill_path")"
    link="$TARGET_DIR/$skill_name"
    [ -L "$link" ] && rm "$link"
    ln -s "$skill_path" "$link"
    echo "  linked $skill_name"
  done
  echo "✓ Skills → $TARGET_DIR"
}

install_agents_md() {
  # Ordered: most-standard path first (proposed XDG standard), then per-tool paths
  declare -a paths=(
    "$HOME/.config/agents/AGENTS.md"                  # proposed XDG standard (issue #91)
    "$HOME/.codex/AGENTS.md"                          # Codex CLI
    "$HOME/.claude/CLAUDE.md"                         # Claude Code
    "$HOME/.config/AGENTS.md"                         # Amp
    "$HOME/.codeium/windsurf/memories/global_rules.md" # Windsurf global rules
  )
  for dest in "${paths[@]}"; do
    mkdir -p "$(dirname "$dest")"
    [ -L "$dest" ] && rm "$dest"
    ln -s "$AGENTS_MD" "$dest"
    echo "  linked $(basename "$dest") → $dest"
  done
  echo "✓ AGENTS.md → global tool paths"
}

install_commands() {
  # Symlink Claude Code slash commands from commands/ into ~/.claude/commands/
  if [ ! -d "$COMMANDS_DIR" ]; then
    echo "  (no commands/ directory found — skipping)"
    return 0
  fi

  mkdir -p "$CLAUDE_COMMANDS_DIR"
  local count=0
  for cmd_path in "$COMMANDS_DIR"/*.md; do
    [ -e "$cmd_path" ] || continue
    cmd_name="$(basename "$cmd_path")"
    link="$CLAUDE_COMMANDS_DIR/$cmd_name"
    [ -L "$link" ] && rm "$link"
    ln -s "$cmd_path" "$link"
    echo "  linked /${cmd_name%.md}"
    count=$((count + 1))
  done

  if [ "$count" -gt 0 ]; then
    echo "✓ Slash commands → $CLAUDE_COMMANDS_DIR"
  else
    echo "  (no .md files in commands/ — skipping)"
  fi
}

install_mcps() {
  # Merges MCP server definitions into each tool's config file.
  # Requires jq. Skips gracefully if jq is not installed.
  if ! command -v jq >/dev/null 2>&1; then
    echo "  ⚠ jq not found — skipping MCP config merge"
    echo "    Install jq (brew install jq) then re-run to add MCP servers."
    return 0
  fi

  local MCP_SRC
  MCP_SRC="$REPO_DIR/mcp-servers.json"
  if [ ! -f "$MCP_SRC" ]; then
    MCP_SRC="$(mktemp)"
    curl -fsSL "https://raw.githubusercontent.com/InnoVestrum/agent-skills/main/mcp-servers.json" \
      -o "$MCP_SRC" 2>/dev/null || { echo "  ⚠ Could not fetch mcp-servers.json — skipping"; return 0; }
  fi

  local tools=("Windsurf" "Cursor" "Codex")
  local dests=(
    "$HOME/.codeium/windsurf/mcp_config.json"
    "$HOME/.cursor/mcp.json"
    "$HOME/.codex/mcp.json"
  )

  local new_servers
  new_servers="$(jq '.mcpServers' "$MCP_SRC")"

  local i
  for i in 0 1 2; do
    local tool="${tools[$i]}"
    local dest="${dests[$i]}"
    mkdir -p "$(dirname "$dest")"

    if [ -f "$dest" ]; then
      # Merge: existing servers take precedence (don't overwrite user tokens)
      updated="$(jq --argjson new "$new_servers" \
        '.mcpServers = ($new + (.mcpServers // {}))' "$dest")"
    else
      updated="$(jq -n --argjson new "$new_servers" '{mcpServers: $new}')"
    fi

    echo "$updated" > "$dest"
    echo "  merged MCP servers → $dest ($tool)"
  done
  echo "✓ MCP servers → Windsurf, Cursor, Codex configs"
  echo "  ⚠ Edit token placeholders in the config files above before use"
}

echo "InnoVestrum Agent Skills installer"
echo "Source: $REPO_DIR"
echo ""

install_skills
echo ""
install_agents_md
echo ""
install_commands
echo ""
install_mcps
echo ""
echo "Done. Restart your agent to pick up new skills and commands."
echo "  Claude Code: MCP servers are configured via plugin userConfig prompts."
echo "  claude-reflect is declared as a plugin dependency — Claude Code installs it automatically."
echo "Weekly ritual: run /reflect-triage in Claude Code to process captured learnings."
echo ""
echo "To update: git -C \"$REPO_DIR\" pull && bash \"$REPO_DIR/install.sh\""
