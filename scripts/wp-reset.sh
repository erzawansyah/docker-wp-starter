#!/usr/bin/env bash
set -euo pipefail

# Get the directory of the current script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Get the root directory of the project
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# Iterate over target directories to delete and clean up the environment
for target in "/wordpress" "${PROJECT_ROOT}/wordpress" "${PROJECT_ROOT}/db_data"; do
  # Check if the target exists or is a symbolic link
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -rf -- "$target"
    echo "deleted: $target"
  else
    echo "skip: $target"
  fi
done
