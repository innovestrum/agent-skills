#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
TARGET_DIR="$HOME/.agents/skills"

echo "InnoVestrum Agent Skills installer"
echo "Source: $SKILLS_DIR"
echo ""

mkdir -p "$TARGET_DIR"
for skill_path in "$SKILLS_DIR"/*/; do
  skill_name="$(basename "$skill_path")"
  link="$TARGET_DIR/$skill_name"
  [ -L "$link" ] && rm "$link"
  ln -s "$skill_path" "$link"
  echo "  linked $skill_name"
done
echo "✓ Skills → $TARGET_DIR"

echo ""
echo "Done. Restart your agent to pick up new skills."
echo "To update: git -C \"$REPO_DIR\" pull && bash \"$REPO_DIR/install.sh\""
