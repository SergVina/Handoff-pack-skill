#!/usr/bin/env bash
# Sanity checks for the skill package. Run locally or in CI.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_DIR="$ROOT_DIR/skills/handoff-pack"
SKILL_MD="$SKILL_DIR/SKILL.md"
fail=0
err() { echo "Error: $*" >&2; fail=1; }

[ -f "$SKILL_MD" ] || { echo "Error: $SKILL_MD not found" >&2; exit 1; }

name=$(sed -n 's/^name: *//p' "$SKILL_MD" | head -1)
[ "$name" = "handoff-pack" ] || err "frontmatter name is '$name', expected 'handoff-pack'"

desc=$(sed -n 's/^description: *//p' "$SKILL_MD" | head -1)
[ "${#desc}" -le 1024 ] || err "description has ${#desc} characters (max 1024)"

lines=$(wc -l < "$SKILL_MD")
[ "$lines" -le 500 ] || err "SKILL.md has $lines lines (max 500)"

v_skill=$(sed -n 's/^  version: *"\(.*\)"/\1/p' "$SKILL_MD" | head -1)
v_market=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$ROOT_DIR/.claude-plugin/marketplace.json" | head -1)
v_badge=$(sed -n 's/.*badge\/version-\([0-9.]*\)-.*/\1/p' "$ROOT_DIR/README.md" | head -1)
v_log=$(sed -n 's/^## \[\([0-9][^]]*\)\].*/\1/p' "$ROOT_DIR/CHANGELOG.md" | head -1)
for v in "$v_market" "$v_badge" "$v_log"; do
  [ "$v" = "$v_skill" ] || err "version mismatch: SKILL.md=$v_skill, other=$v"
done

# Every reference cited in SKILL.md must exist
for ref in $(grep -o 'references/[a-z-]*\.md' "$SKILL_MD" | sort -u); do
  [ -f "$SKILL_DIR/$ref" ] || err "missing file cited in SKILL.md: $ref"
done

[ "$fail" -eq 0 ] && echo "OK: skill $name v$v_skill"
exit "$fail"
