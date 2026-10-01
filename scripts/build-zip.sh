#!/usr/bin/env bash
# Builds dist/handoff-pack.zip, ready to upload to Claude (web or desktop).
# The ZIP root must contain a single folder whose name matches the skill name.
set -euo pipefail

SKILL_NAME="handoff-pack"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"

if [ ! -f "$ROOT_DIR/skills/$SKILL_NAME/SKILL.md" ]; then
  echo "Error: skills/$SKILL_NAME/SKILL.md not found" >&2
  exit 1
fi

mkdir -p "$DIST_DIR"
rm -f "$DIST_DIR/$SKILL_NAME.zip"
(cd "$ROOT_DIR/skills" && zip -rq "$DIST_DIR/$SKILL_NAME.zip" "$SKILL_NAME" -x "*.DS_Store")

echo "Built $DIST_DIR/$SKILL_NAME.zip"
