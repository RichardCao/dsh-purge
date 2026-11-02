#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DSH_HOME="${DSH_HOME:-}"
if [[ -z "$DSH_HOME" ]]; then
  for cand in "$ROOT/../.dsh-home" "$ROOT/../../.dsh-home"; do
    if [[ -d "$cand" ]]; then DSH_HOME="$cand"; break; fi
  done
fi
if [[ -z "$DSH_HOME" ]]; then
  echo "未找到 DSH_HOME；请设置 DSH_HOME=/path/to/.dsh-home" >&2
  exit 1
fi
PROFILE="$DSH_HOME/profiles/web"
PLUGIN="$PROFILE/node_modules/dsh-purge"

for f in "$PLUGIN/lib/net-scope.js" "$PLUGIN/lib/index.js" "$PLUGIN/lib/core.js"; do
  node --check "$f"
done

grep -n 'regionGate\|cheatGate\|refusalSteer\|prefill' "$PROFILE/cordis.patch.yml"
grep -n 'harness-dev-context' "$PLUGIN/lib/core.js"

DSH_LOCAL="${DSH_LOCAL:-}"
if [[ -z "$DSH_LOCAL" ]]; then
  for cand in "$ROOT/../dsh-local" "$ROOT/../../dsh-local"; do
    if [[ -x "$cand" ]]; then DSH_LOCAL="$cand"; break; fi
  done
fi
if [[ -n "$DSH_LOCAL" && -x "$DSH_LOCAL" ]]; then
  "$DSH_LOCAL" purge --status | grep -E '#32|#53|#77|patches'
fi
