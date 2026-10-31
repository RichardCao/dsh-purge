#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DSH_HOME="${DSH_HOME:-$ROOT/../.dsh-home}"
PROFILE="$DSH_HOME/profiles/web"
PLUGIN="$PROFILE/node_modules/dsh-purge"

for f in "$PLUGIN/lib/net-scope.js" "$PLUGIN/lib/index.js" "$PLUGIN/lib/core.js"; do
  node --check "$f"
done

grep -n 'regionGate\|cheatGate\|refusalSteer\|prefill' "$PROFILE/cordis.patch.yml"
grep -n 'harness-dev-context' "$PLUGIN/lib/core.js"

if [[ -x "$ROOT/../dsh-local" ]]; then
  "$ROOT/../dsh-local" purge --status | grep -E '#32|#53|#77|patches'
fi
