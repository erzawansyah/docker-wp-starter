#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

for target in "/wordpress" "${PROJECT_ROOT}/wordpress" "${PROJECT_ROOT}/db_data"; do
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -rf -- "$target"
    echo "deleted: $target"
  else
    echo "skip: $target"
  fi
done
