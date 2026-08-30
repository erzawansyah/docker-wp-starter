#!/usr/bin/env bash
set -euo pipefail

# Get the directory of the current script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Get the root directory of the project
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

INCLUDE_ALL=false

# Check command line arguments
for arg in "$@"; do
  case "$arg" in
    --all|-a)
      INCLUDE_ALL=true
      ;;
    --help|-h)
      echo "Usage: $0 [--all]"
      echo "  Default : Deletes 'wordpress/' and 'db_data/'"
      echo "  --all   : Deletes 'wordpress/', 'db_data/', 'backups/', and '.env'"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--all]"
      exit 1
      ;;
  esac
done

TARGETS=(
  "${PROJECT_ROOT}/wordpress"
  "${PROJECT_ROOT}/db_data"
)

if [ "$INCLUDE_ALL" = true ]; then
  TARGETS+=(
    "${PROJECT_ROOT}/backups"
    "${PROJECT_ROOT}/.env"
  )
  echo "[Reset] Running full reset (including 'backups/' and '.env')..."
else
  echo "[Reset] Running standard reset ('wordpress/' and 'db_data/')..."
  echo "        Tip: Gunakan '$0 --all' untuk menyertakan folder 'backups/' dan file '.env'."
fi

# Iterate over target directories and files to delete
for target in "${TARGETS[@]}"; do
  # Check if the target exists or is a symbolic link
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -rf -- "$target"
    echo "deleted: $target"
  else
    echo "skip: $target"
  fi
done

echo "[Reset] Selesai!"
