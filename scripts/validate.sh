#!/usr/bin/env bash
# Sanity checks for every skill in skills/ and for the repository metadata.
# Run locally or in CI. Requires Python 3 with PyYAML.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PY="$(command -v python3 || command -v python)"

"$PY" - "$ROOT_DIR" <<'EOF'
import glob, json, os, re, sys
import yaml

root = sys.argv[1]
errors = []
def err(msg):
    errors.append(msg)

ALLOWED_KEYS = {"name", "description", "license", "compatibility", "metadata", "allowed-tools"}

def read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()

# Repository version: marketplace, README badge and CHANGELOG must agree.
market_path = os.path.join(root, ".claude-plugin", "marketplace.json")
try:
    market = json.loads(read(market_path))
except Exception as e:
    err(f"marketplace.json is not valid JSON: {e}")
    market = {}
repo_version = market.get("metadata", {}).get("version")
badge = re.search(r"badge/version-([0-9.]+)-", read(os.path.join(root, "README.md")))
log = re.search(r"^## \[([0-9][^\]]*)\]", read(os.path.join(root, "CHANGELOG.md")), re.M)
for label, v in (("README badge", badge and badge.group(1)), ("CHANGELOG", log and log.group(1))):
    if v != repo_version:
        err(f"version mismatch: marketplace.json={repo_version}, {label}={v}")

# Every skill listed in the marketplace must exist, and every skill folder must be listed.
listed = set()
for plugin in market.get("plugins", []):
    for s in plugin.get("skills", []):
        listed.add(os.path.normpath(s.lstrip("./")))
folders = {os.path.normpath(os.path.relpath(os.path.dirname(p), root))
           for p in glob.glob(os.path.join(root, "skills", "*", "SKILL.md"))}
for missing in sorted(listed - folders):
    err(f"marketplace.json lists {missing}, which has no SKILL.md")
for unlisted in sorted(folders - listed):
    err(f"{unlisted} is not listed in marketplace.json")

# Per-skill checks.
for skill_dir in sorted(glob.glob(os.path.join(root, "skills", "*", ""))):
    skill_md = os.path.join(skill_dir, "SKILL.md")
    folder = os.path.basename(os.path.normpath(skill_dir))
    if not os.path.isfile(skill_md):
        continue
    text = read(skill_md)
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        err(f"{folder}: SKILL.md has no YAML frontmatter")
        continue
    try:
        fm = yaml.safe_load(m.group(1))
    except yaml.YAMLError as e:
        err(f"{folder}: frontmatter is not valid YAML: {e}")
        continue
    if fm.get("name") != folder:
        err(f"{folder}: frontmatter name is '{fm.get('name')}', expected '{folder}'")
    desc = fm.get("description") or ""
    if not desc:
        err(f"{folder}: description is empty")
    if len(desc) > 1024:
        err(f"{folder}: description has {len(desc)} characters (max 1024)")
    extra = set(fm) - ALLOWED_KEYS
    if extra:
        err(f"{folder}: unexpected frontmatter keys {sorted(extra)}")
    lines = text.count("\n")
    if lines >= 500:
        err(f"{folder}: SKILL.md has {lines} lines (must be under 500)")
    v = str((fm.get("metadata") or {}).get("version"))
    if v != repo_version:
        err(f"{folder}: metadata.version={v}, marketplace.json={repo_version}")
    # Every file cited in SKILL.md must exist inside the skill's own folder.
    for ref in sorted(set(re.findall(r"references/[A-Za-z0-9_./-]+\.md", text))):
        if not os.path.isfile(os.path.join(skill_dir, ref)):
            err(f"{folder}: SKILL.md cites {ref}, which does not exist in the skill folder")
    print(f"{folder}: name ok, description {len(desc)} chars, SKILL.md {lines} lines")

# Every JSON file under evals/ must be valid.
for path in sorted(glob.glob(os.path.join(root, "evals", "**", "*.json"), recursive=True)):
    try:
        json.loads(read(path))
    except Exception as e:
        err(f"{os.path.relpath(path, root)} is not valid JSON: {e}")

# No reference to the old flat evals layout may remain.
old = re.compile(r"evals/(evals|trigger-evals)\.json")
for path in glob.glob(os.path.join(root, "**", "*"), recursive=True):
    if ".git" in path.split(os.sep) or "dist" in path.split(os.sep) or not os.path.isfile(path):
        continue
    if path.endswith((".md", ".json", ".sh", ".yml")):
        if old.search(read(path)):
            err(f"{os.path.relpath(path, root)} still cites the old evals/ layout")

if errors:
    for e in errors:
        print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
print(f"OK: repository v{repo_version}")
EOF
