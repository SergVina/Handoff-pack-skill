#!/usr/bin/env bash
# Builds one ZIP per skill in dist/, ready to upload to Claude (web or desktop):
# dist/handoff-pack.zip and dist/handoff-implement.zip.
# Each ZIP root must contain a single folder whose name matches the skill name,
# with SKILL.md directly inside it.
set -euo pipefail

SKILLS=(handoff-pack handoff-implement)
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"

mkdir -p "$DIST_DIR"

for skill in "${SKILLS[@]}"; do
  if [ ! -f "$ROOT_DIR/skills/$skill/SKILL.md" ]; then
    echo "Error: skills/$skill/SKILL.md not found" >&2
    exit 1
  fi
  out="$DIST_DIR/$skill.zip"
  rm -f "$out"
  if command -v zip >/dev/null 2>&1; then
    (cd "$ROOT_DIR/skills" && zip -rq "$out" "$skill" -x "*.DS_Store")
  else
    # Fallback for systems without the zip CLI (for example Git Bash on Windows).
    PY="$(command -v python3 || command -v python)"
    (cd "$ROOT_DIR/skills" && "$PY" - "$out" "$skill" <<'PYEOF'
import os, sys, zipfile
out, skill = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for base, dirs, files in os.walk(skill):
        dirs.sort()
        for name in sorted(files):
            if name != ".DS_Store":
                path = os.path.join(base, name)
                z.write(path, path.replace(os.sep, "/"))
PYEOF
    )
  fi
  echo "Built $out"
done
