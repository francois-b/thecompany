#!/bin/bash
# Usage: next-doc-id.sh <TYPE>
# Returns the next available ID for a document type
#
# Examples:
#   next-doc-id.sh DES   → DES-001 (or next available)
#   next-doc-id.sh BUG   → BUG-001 (or next available)
#   next-doc-id.sh TODO  → TODO-001 (or next available)

set -e

TYPE="$1"

if [ -z "$TYPE" ]; then
  echo "Usage: next-doc-id.sh <TYPE>" >&2
  echo "Types: DES, BUG, TODO" >&2
  exit 1
fi

# Determine directory based on type
case "$TYPE" in
  DES)
    DIR="docs/design"
    ;;
  BUG)
    DIR="docs/bugs"
    ;;
  TODO)
    DIR="docs/todos"
    ;;
  *)
    echo "Unknown type: $TYPE" >&2
    echo "Valid types: DES, BUG, TODO" >&2
    exit 1
    ;;
esac

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "${TYPE}-001"
  exit 0
fi

# Find highest existing number
HIGHEST=$(ls -1 "$DIR"/${TYPE}-*.md 2>/dev/null | \
  sed "s/.*${TYPE}-\([0-9]*\).*/\1/" | \
  sort -n | tail -1)

if [ -z "$HIGHEST" ]; then
  NEXT=1
else
  NEXT=$((HIGHEST + 1))
fi

printf "%s-%03d\n" "$TYPE" "$NEXT"
