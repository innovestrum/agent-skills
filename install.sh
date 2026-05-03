#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
AGENTS_MD="$REPO_DIR/AGENTS.md"
TARGET_DIR="$HOME/.agents/skills"

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
    "$HOME/.config/agents/AGENTS.md"   # proposed XDG standard (issue #91)
    "$HOME/.codex/AGENTS.md"           # Codex CLI
    "$HOME/.claude/CLAUDE.md"          # Claude Code
    "$HOME/.config/AGENTS.md"          # Amp
  )
  for dest in "${paths[@]}"; do
    mkdir -p "$(dirname "$dest")"
    [ -L "$dest" ] && rm "$dest"
    ln -s "$AGENTS_MD" "$dest"
    echo "  linked $(basename "$dest") → $dest"
  done
  echo "✓ AGENTS.md → global tool paths"
}

echo "InnoVestrum Agent Skills installer"
echo "Source: $REPO_DIR"
echo ""

install_skills
echo ""
install_agents_md

echo ""
echo "Done. Restart your agent to pick up new skills."
echo "To update: git -C \"$REPO_DIR\" pull && bash \"$REPO_DIR/install.sh\""
