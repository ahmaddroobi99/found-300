#!/usr/bin/env bash
# Star every extra in catalog/extras.json onto the authenticated account.
# Requires: gh auth login  (scope: public_repo)
# GitHub Apps without user scope will 403 — that is expected.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
JSON="$ROOT/catalog/extras.json"
if ! command -v gh >/dev/null; then
  echo "install GitHub CLI: https://cli.github.com/" >&2
  exit 1
fi
if ! command -v python3 >/dev/null; then
  echo "python3 required to parse extras.json" >&2
  exit 1
fi
python3 - <<'PY' | while IFS= read -r slug; do
  echo "star $slug"
  gh api -X PUT "user/starred/$slug" >/dev/null && echo "  ok" || echo "  FAIL $slug"
done
import json, pathlib
p = pathlib.Path(__file__).resolve().parents[1] / "catalog" / "extras.json" if False else None
PY
python3 -c '
import json, pathlib
p = pathlib.Path("'