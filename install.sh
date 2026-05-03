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

install_claude_reflect() {
  # Self-learning plugin: captures corrections in chat, queues them for /reflect-triage.
  # Tries CLI install first, falls back to printed instructions.
  if ! command -v claude >/dev/null 2>&1; then
    echo "  ⚠ Claude Code CLI not found in PATH"
    echo "    Install Claude Code first: https://docs.claude.com/en/docs/claude-code/setup"
    echo "    Then re-run this installer, or install the plugin manually:"
    echo "      /plugin marketplace add bayramannakov/claude-reflect"
    echo "      /plugin install claude-reflect@claude-reflect-marketplace"
    return 0
  fi

  # Best-effort CLI install. The Claude Code plugin CLI commands may differ across
  # versions; on failure we print fallback instructions instead of erroring out.
  if claude plugin marketplace add bayramannakov/claude-reflect >/dev/null 2>&1 \
     && claude plugin install claude-reflect@claude-reflect-marketplace >/dev/null 2>&1; then
    echo "✓ claude-reflect plugin installed (restart Claude Code to activate)"
  else
    echo "  ⚠ Could not auto-install claude-reflect via CLI"
    echo "    Run inside Claude Code:"
    echo "      /plugin marketplace add bayramannakov/claude-reflect"
    echo "      /plugin install claude-reflect@claude-reflect-marketplace"
    echo "    Then restart Claude Code."
  fi
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
install_claude_reflect
echo ""
echo "Done. Restart your agent to pick up new skills and commands."
echo "Weekly ritual: run /reflect-triage in Claude Code to process captured learnings."
echo ""
echo "To update: git -C \"$REPO_DIR\" pull && bash \"$REPO_DIR/install.sh\""
