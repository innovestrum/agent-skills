#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
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

install_claude_code() {
  if ! command -v claude &>/dev/null; then
    echo "⚠ claude CLI not found — skipping Claude Code plugin install"
    return
  fi

  echo "Setting up Claude Code plugin marketplace..."
  claude plugin marketplace remove innovestrum 2>/dev/null || true
  if claude plugin marketplace add InnoVestrum/agent-skills 2>/dev/null \
     && claude plugin install innovestrum-standards@innovestrum 2>/dev/null; then
    echo "✓ Claude Code → plugin installed (innovestrum-standards@innovestrum)"
  else
    echo "⚠ Claude Code plugin install failed."
    echo "  Once repo is public, run manually:"
    echo "    /plugin marketplace add InnoVestrum/agent-skills"
    echo "    /plugin install innovestrum-standards@innovestrum"
  fi
}

echo "InnoVestrum Agent Skills installer"
echo "Source: $SKILLS_DIR"
echo ""

link_skills "$HOME/.codeium/windsurf/skills" "Windsurf (global)"
link_skills "$HOME/.agents/skills"            "Codex (global)"
install_claude_code

echo ""
echo "Done. Restart your agent to pick up new skills."
echo "To update: git -C \"$REPO_DIR\" pull && bash \"$REPO_DIR/install.sh\""
