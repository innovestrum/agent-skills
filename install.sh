#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
COMMANDS_DIR="$REPO_DIR/commands"
AGENTS_MD="$REPO_DIR/AGENTS.md"
TARGET_DIR="$HOME/.agents/skills"
CANONICAL_REPO="$HOME/.agents/agent-skills"
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
  # TODO: once ~/.config/agents/AGENTS.md is universally adopted (agentskills.io issue #91),
  # replace all tool-specific paths below with that single XDG path.
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
  if [ ! -d "$COMMANDS_DIR" ]; then
    echo "  (no commands/ directory — skipping)"
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
  [ "$count" -gt 0 ] && echo "✓ Slash commands → $CLAUDE_COMMANDS_DIR" || echo "  (no .md files in commands/ — skipping)"
}

print_claude_plugin_instructions() {
  # TODO: automate plugin install + userConfig seeding once
  # https://github.com/anthropics/claude-code/issues/39827 is fixed
  # (currently `claude plugin install` cannot pass userConfig values,
  # so the GitHub MCP only wires up via the interactive /plugin flow).
  echo "Claude Code plugin (manual, one-time):"
  echo "  Open Claude Code and run:"
  echo ""
  echo "    /plugin marketplace add InnoVestrum/agent-skills"
  echo "    /plugin install innovestrum-standards@innovestrum"
  echo ""
  echo "  You will be prompted for a GitHub Personal Access Token"
  echo "  (scopes: repo, read:org — create at https://github.com/settings/tokens)."
  echo "  This is the only path that wires up the GitHub MCP correctly."
}

install_canonical_link() {
  # Skip if repo is already at canonical location
  if [ "$REPO_DIR" = "$CANONICAL_REPO" ]; then
    echo "  (repo already at canonical path — skipping)"
    return 0
  fi
  mkdir -p "$(dirname "$CANONICAL_REPO")"
  if [ -e "$CANONICAL_REPO" ] || [ -L "$CANONICAL_REPO" ]; then
    rm -rf "$CANONICAL_REPO"
  fi
  ln -s "$REPO_DIR" "$CANONICAL_REPO"
  echo "✓ Repo → $CANONICAL_REPO (canonical path for skills)"
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
install_canonical_link
echo ""
print_claude_plugin_instructions
echo ""
echo "Done. Restart your agent to pick up new skills and commands."
echo "  Other tools: ask your agent to invoke the 'setup-mcps' skill for guided MCP setup."
echo "Weekly ritual: run /reflect-triage in Claude Code to process captured learnings."
echo ""
echo "To update: git -C \"$REPO_DIR\" pull && bash \"$REPO_DIR/install.sh\""
