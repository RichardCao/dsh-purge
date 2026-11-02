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

if [[ ! -d "$PLUGIN" ]]; then
  echo "未找到 $PLUGIN；先安装 dsh-purge 1.1.89" >&2
  exit 1
fi

cp -R "$ROOT/../lib/." "$PLUGIN/lib/"
cp "$ROOT/../package.json" "$PLUGIN/package.json"

cp "$ROOT/config/cordis.patch.yml" "$PROFILE/cordis.patch.yml"

PROMPT_MODE="${PROMPT_MODE:-current}"
case "$PROMPT_MODE" in
  current) PROMPT_SRC="$ROOT/config/prompt-inject.md" ;;
  v3) PROMPT_SRC="$ROOT/config/prompt-inject-v3.md" ;;
  policy) PROMPT_SRC="$ROOT/config/prompt-inject-policy.md" ;;
  *) echo "未知 PROMPT_MODE: $PROMPT_MODE（current|v3|policy）" >&2; exit 1 ;;
esac

if [[ -f "$DSH_HOME/prompt-inject.md" ]]; then
  cp "$DSH_HOME/prompt-inject.md" "$DSH_HOME/prompt-inject.md.bak.$(date +%s)"
fi
cp "$PROMPT_SRC" "$DSH_HOME/prompt-inject.md"

DSH_LOCAL="${DSH_LOCAL:-}"
if [[ -z "$DSH_LOCAL" ]]; then
  for cand in "$ROOT/../dsh-local" "$ROOT/../../dsh-local"; do
    if [[ -x "$cand" ]]; then DSH_LOCAL="$cand"; break; fi
  done
fi
if [[ -n "$DSH_LOCAL" && -x "$DSH_LOCAL" ]]; then
  "$DSH_LOCAL" purge --apply
else
  echo "未找到 dsh-local；请手动运行 dsh purge --apply" >&2
fi
