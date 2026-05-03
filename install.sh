#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

link_skills() {
  local target_dir="$1"
  local label="$2"
  mkdir -p "$target_dir"
  for skill_path in "$SKILLS_DIR"/*/; do
    skill_name="$(basename "$skill_path")"
    link="$target_dir/$skill_name"
    if [ -L "$link" ]; then
      rm "$link"
    fi
    ln -s "$skill_path" "$link"
    echo "  linked $skill_name"
  done
  echo "✓ $label → $target_dir"
}

echo "InnoVestrum Agent Skills installer"
echo "Source: $SKILLS_DIR"
echo ""

link_skills "$HOME/.codeium/windsurf/skills"  "Windsurf (global)"
link_skills "$HOME/.claude/skills"             "Claude Code (global)"
link_skills "$HOME/.agents/skills"             "Codex (global)"

echo ""
echo "Done. Restart your agent to pick up new skills."
echo "To update: git -C \"$REPO_DIR\" pull && bash \"$REPO_DIR/install.sh\""
