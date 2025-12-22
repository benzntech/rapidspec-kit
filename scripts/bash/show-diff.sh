#!/bin/bash

# Spec-Kit Diff Display Script
# Purpose: Show before/after diffs for code changes
# Usage: ./show-diff.sh <file-path> <before-file> <after-file> [--format unified|side-by-side]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Arguments
FILE_PATH="$1"
BEFORE_FILE="$2"
AFTER_FILE="$3"
FORMAT="${4:-unified}"

if [ -z "$FILE_PATH" ] || [ -z "$BEFORE_FILE" ] || [ -z "$AFTER_FILE" ]; then
  echo "Usage: $0 <file-path> <before-file> <after-file> [--format unified|side-by-side]"
  exit 1
fi

# Show file information
echo "════════════════════════════════════════════════════════"
echo "File: $FILE_PATH"
echo "════════════════════════════════════════════════════════"
echo ""

# Show before stats
if [ -f "$BEFORE_FILE" ]; then
  BEFORE_LINES=$(wc -l < "$BEFORE_FILE")
  echo "Before: $BEFORE_LINES lines"
else
  echo "Before: [NEW FILE]"
fi

# Show after stats
if [ -f "$AFTER_FILE" ]; then
  AFTER_LINES=$(wc -l < "$AFTER_FILE")
  echo "After: $AFTER_LINES lines"
else
  echo "After: [FILE DELETED]"
fi

# Calculate difference
if [ -f "$BEFORE_FILE" ] && [ -f "$AFTER_FILE" ]; then
  ADDED=$((AFTER_LINES - BEFORE_LINES))
  if [ $ADDED -gt 0 ]; then
    echo "Change: +$ADDED lines"
  else
    echo "Change: $ADDED lines"
  fi
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo ""

# Show diff based on format
if [ "$FORMAT" = "side-by-side" ]; then
  # Side-by-side diff
  if command -v sdiff &> /dev/null; then
    sdiff "$BEFORE_FILE" "$AFTER_FILE" || true
  else
    # Fallback to unified diff if sdiff not available
    diff -u "$BEFORE_FILE" "$AFTER_FILE" || true
  fi
else
  # Unified diff (default)
  diff -u "$BEFORE_FILE" "$AFTER_FILE" || true
fi

echo ""
echo "════════════════════════════════════════════════════════"
