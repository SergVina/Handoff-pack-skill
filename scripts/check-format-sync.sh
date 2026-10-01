#!/usr/bin/env bash
# Fails if any skill's copy of the pack format contract differs from the canonical
# spec/PACK-FORMAT.md. Each skill ships its own copy because a skill cannot depend
# on files outside its folder; this check keeps the copies identical.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CANONICAL="$ROOT_DIR/spec/PACK-FORMAT.md"
COPIES=(
  "skills/handoff-pack/references/pack-format.md"
  "skills/handoff-implement/references/pack-format.md"
)
fail=0

[ -f "$CANONICAL" ] || { echo "Error: spec/PACK-FORMAT.md not found" >&2; exit 1; }

for copy in "${COPIES[@]}"; do
  if [ ! -f "$ROOT_DIR/$copy" ]; then
    echo "Error: missing copy $copy" >&2
    fail=1
  elif ! cmp -s "$CANONICAL" "$ROOT_DIR/$copy"; then
    echo "Error: $copy differs from spec/PACK-FORMAT.md (copy the canonical file over it)" >&2
    fail=1
  fi
done

[ "$fail" -eq 0 ] && echo "OK: ${#COPIES[@]} copies of the pack format are in sync"
exit "$fail"
