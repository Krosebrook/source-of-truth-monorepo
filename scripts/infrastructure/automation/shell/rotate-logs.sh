#!/usr/bin/env bash
set -euo pipefail

# Rotate logs in logs/active/, keeping the newest N (defaults to 5) and archiving the rest.
# Archived logs are timestamped and moved into logs/archive/ to avoid bloating commits.

KEEP_COUNT=${1:-5}
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOGS_ROOT=$(realpath "$SCRIPT_DIR/../../logs")
ACTIVE_DIR="$LOGS_ROOT/active"
ARCHIVE_DIR="$LOGS_ROOT/archive"

mkdir -p "$ACTIVE_DIR" "$ARCHIVE_DIR"

mapfile -t LOG_FILES < <(ls -1t "$ACTIVE_DIR"/*.log 2>/dev/null || true)
TOTAL=${#LOG_FILES[@]}

if (( TOTAL <= KEEP_COUNT )); then
  exit 0
fi

TIMESTAMP_BASE=$(date -u +"%Y%m%dT%H%M%SZ")
COUNTER=0

for idx in "${!LOG_FILES[@]}"; do
  if (( idx < KEEP_COUNT )); then
    continue
  fi
  SRC="${LOG_FILES[$idx]}"
  BASENAME=$(basename "$SRC")
  EXT="${BASENAME##*.}"
  STEM="${BASENAME%.*}"
  COUNTER=$((COUNTER + 1))
  DEST="$ARCHIVE_DIR/${STEM}_${TIMESTAMP_BASE}_$COUNTER.$EXT"
  mv "$SRC" "$DEST"
  gzip -f "$DEST"
done
