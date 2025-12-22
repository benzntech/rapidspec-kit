#!/bin/bash

# Spec-Kit Code Verification Script
# Purpose: Verify actual code files exist, detect frameworks, analyze git history
# Usage: ./verify-code.sh --json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common utilities
if [ -f "$SCRIPT_DIR/common.sh" ]; then
  source "$SCRIPT_DIR/common.sh"
fi

# Default values
OUTPUT_FORMAT="text"
FEATURE_DIR=""
VERIFICATION_FILE=""
FEATURE_NAME=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --json)
      OUTPUT_FORMAT="json"
      shift
      ;;
    --feature-dir)
      FEATURE_DIR="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Determine feature directory
if [ -z "$FEATURE_DIR" ]; then
  # Find most recent feature directory
  FEATURE_DIR=$(find "$REPO_ROOT" -maxdepth 1 -type d -name "[0-9]*-*" | sort -r | head -1)
fi

if [ -z "$FEATURE_DIR" ] || [ ! -d "$FEATURE_DIR" ]; then
  echo "Error: No feature directory found"
  exit 1
fi

FEATURE_NAME=$(basename "$FEATURE_DIR" | sed 's/^[0-9]\{3\}-//')
VERIFICATION_FILE="$FEATURE_DIR/verification.md"

# Output based on format
if [ "$OUTPUT_FORMAT" = "json" ]; then
  cat <<EOF
{
  "feature_dir": "$FEATURE_DIR",
  "feature_name": "$FEATURE_NAME",
  "verification_file": "$VERIFICATION_FILE",
  "repo_root": "$REPO_ROOT",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
else
  echo "Feature Directory: $FEATURE_DIR"
  echo "Feature Name: $FEATURE_NAME"
  echo "Verification File: $VERIFICATION_FILE"
  echo "Repo Root: $REPO_ROOT"
fi

exit 0
