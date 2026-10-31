#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DSH_HOME="${DSH_HOME:-$ROOT/../.dsh-home}"
PROFILE="$DSH_HOME/profiles/web"
PLUGIN="$PROFILE/node_modules/dsh-purge"

if [[ ! -d "$PLUGIN" ]]; then
  echo "未找到 $PLUGIN；先安装 dsh-purge 1.1.83" >&2
  exit 1
fi

cp "$ROOT/../lib/net-scope.js" "$PLUGIN/lib/net-scope.js"
cp "$ROOT/../lib/index.js" "$PLUGIN/lib/index.js"
cp "$ROOT/../lib/core.js" "$PLUGIN/lib/core.js"

cp "$ROOT/config/cordis.patch.yml" "$PROFILE/cordis.patch.yml"
if [[ -f "$DSH_HOME/prompt-inject.md" ]]; then
  cp "$DSH_HOME/prompt-inject.md" "$DSH_HOME/prompt-inject.md.bak.$(date +%s)"
fi
cp "$ROOT/config/prompt-inject.md" "$DSH_HOME/prompt-inject.md"

if [[ -x "$ROOT/../dsh-local" ]]; then
  "$ROOT/../dsh-local" purge --apply
else
  echo "未找到 dsh-local；请手动运行 dsh-purge apply" >&2
fi
