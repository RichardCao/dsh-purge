#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! git -C "$ROOT" remote get-url upstream >/dev/null 2>&1; then
  git -C "$ROOT" remote add upstream https://github.com/YuJunZhiXue/dsh-purge.git
fi

git -C "$ROOT" fetch upstream --tags
git -C "$ROOT" checkout tuning
git -C "$ROOT" rebase upstream/master

printf 'rebase done: tuning -> %s\n' "$(git -C "$ROOT" rev-parse --short upstream/master)"
