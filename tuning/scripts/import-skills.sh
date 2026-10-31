#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DSH_HOME="${DSH_HOME:-$ROOT/../.dsh-home}"
SKILLS_DIR="$DSH_HOME/skills"
ARCHIVE="${1:-}"

if [[ -z "$ARCHIVE" ]]; then
  echo "用法: $0 <skills.zip|skills目录>" >&2
  exit 1
fi

mkdir -p "$SKILLS_DIR"

if [[ -d "$ARCHIVE" ]]; then
  cp -a "$ARCHIVE"/. "$SKILLS_DIR"/
else
  unzip -q "$ARCHIVE" -d "$SKILLS_DIR"
fi

echo "已导入到 $SKILLS_DIR"
