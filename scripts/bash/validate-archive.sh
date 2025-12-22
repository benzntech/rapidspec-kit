#!/bin/bash

# Spec-Kit Archive Validation Script
# Purpose: Validate that feature is ready for archival
# Usage: ./validate-archive.sh --json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Default values
OUTPUT_FORMAT="text"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --json)
      OUTPUT_FORMAT="json"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Find feature directory
FEATURE_DIR=$(find "$REPO_ROOT" -maxdepth 1 -type d -name "[0-9]*-*" | sort -r | head -1)

if [ -z "$FEATURE_DIR" ] || [ ! -d "$FEATURE_DIR" ]; then
  echo "Error: No feature directory found"
  exit 1
fi

FEATURE_NAME=$(basename "$FEATURE_DIR" | sed 's/^[0-9]\{3\}-//')
TASKS_FILE="$FEATURE_DIR/tasks.md"
REVIEW_FILE="$FEATURE_DIR/review.md"

# Run validations
VALIDATION_PASSED=1

# Check tasks completion
if grep -q "^- \[ \]" "$TASKS_FILE" 2>/dev/null; then
  VALIDATION_PASSED=0
  TASKS_STATUS="incomplete"
else
  TASKS_STATUS="complete"
fi

# Check review status
if [ -f "$REVIEW_FILE" ] && grep -q "Ready to Merge: Yes" "$REVIEW_FILE" 2>/dev/null; then
  REVIEW_STATUS="passed"
else
  VALIDATION_PASSED=0
  REVIEW_STATUS="failed"
fi

# Check git status
cd "$REPO_ROOT"
if git diff-index --quiet HEAD --; then
  GIT_STATUS="clean"
else
  VALIDATION_PASSED=0
  GIT_STATUS="dirty"
fi

# Check if on main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" = "main" ]; then
  BRANCH_STATUS="main"
else
  VALIDATION_PASSED=0
  BRANCH_STATUS="not-main"
fi

# Output based on format
if [ "$OUTPUT_FORMAT" = "json" ]; then
  cat <<EOF
{
  "feature_name": "$FEATURE_NAME",
  "ready_to_archive": $VALIDATION_PASSED,
  "tasks_status": "$TASKS_STATUS",
  "review_status": "$REVIEW_STATUS",
  "git_status": "$GIT_STATUS",
  "branch_status": "$BRANCH_STATUS",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
else
  echo "Archive Validation Results"
  echo "=========================="
  echo ""
  echo "Feature: $FEATURE_NAME"
  echo ""
  echo "Validation Checks:"
  echo "  Tasks Complete: $([ "$TASKS_STATUS" = "complete" ] && echo "✅ Yes" || echo "❌ No")"
  echo "  Review Passed: $([ "$REVIEW_STATUS" = "passed" ] && echo "✅ Yes" || echo "❌ No")"
  echo "  Git Clean: $([ "$GIT_STATUS" = "clean" ] && echo "✅ Yes" || echo "❌ No")"
  echo "  On Main: $([ "$BRANCH_STATUS" = "main" ] && echo "✅ Yes" || echo "❌ No")"
  echo ""

  if [ $VALIDATION_PASSED -eq 1 ]; then
    echo "✅ Ready to archive"
  else
    echo "❌ Not ready to archive"
    [ "$TASKS_STATUS" != "complete" ] && echo "   - Complete all pending tasks"
    [ "$REVIEW_STATUS" != "passed" ] && echo "   - Ensure review passes"
    [ "$GIT_STATUS" != "clean" ] && echo "   - Commit all changes"
    [ "$BRANCH_STATUS" != "main" ] && echo "   - Merge to main branch"
  fi
fi

exit 0
