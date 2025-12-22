#!/bin/bash

# Spec-Kit Commit Verification Script
# Purpose: Verify git changes and task completions before committing
# Usage: ./commit-verify.sh --json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common utilities
if [ -f "$SCRIPT_DIR/common.sh" ]; then
  source "$SCRIPT_DIR/common.sh"
fi

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

# Verify required files exist
if [ ! -f "$TASKS_FILE" ]; then
  echo "Error: tasks.md not found"
  exit 1
fi

# Check git status
cd "$REPO_ROOT"

# Count git changes
CHANGED_FILES=$(git diff --name-only 2>/dev/null | wc -l || echo "0")
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null | wc -l || echo "0")

# Count completed tasks
COMPLETED_TASKS=$(grep -c "^- \[x\]" "$TASKS_FILE" || echo "0")
PENDING_TASKS=$(grep -c "^- \[ \]" "$TASKS_FILE" || echo "0")

# Check if review passed
REVIEW_STATUS="pending"
if [ -f "$REVIEW_FILE" ]; then
  if grep -q "Ready to Merge: Yes" "$REVIEW_FILE" 2>/dev/null; then
    REVIEW_STATUS="passed"
  elif grep -q "Ready to Merge: No" "$REVIEW_FILE" 2>/dev/null; then
    REVIEW_STATUS="failed"
  fi
fi

# Output based on format
if [ "$OUTPUT_FORMAT" = "json" ]; then
  cat <<EOF
{
  "feature_dir": "$FEATURE_DIR",
  "feature_name": "$FEATURE_NAME",
  "tasks_file": "$TASKS_FILE",
  "completed_tasks": $COMPLETED_TASKS,
  "pending_tasks": $PENDING_TASKS,
  "changed_files": $CHANGED_FILES,
  "staged_files": $STAGED_FILES,
  "review_status": "$REVIEW_STATUS",
  "ready_to_commit": $([ "$REVIEW_STATUS" = "passed" ] && [ $COMPLETED_TASKS -gt 0 ] && echo "true" || echo "false"),
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
else
  echo "Commit Verification Results"
  echo "============================"
  echo ""
  echo "Feature: $FEATURE_NAME"
  echo "Directory: $FEATURE_DIR"
  echo ""
  echo "Task Status:"
  echo "  Completed: $COMPLETED_TASKS"
  echo "  Pending: $PENDING_TASKS"
  echo ""
  echo "Git Status:"
  echo "  Changed Files: $CHANGED_FILES"
  echo "  Staged Files: $STAGED_FILES"
  echo ""
  echo "Review Status: $REVIEW_STATUS"
  echo ""

  if [ "$REVIEW_STATUS" = "passed" ] && [ $COMPLETED_TASKS -gt 0 ]; then
    echo "✅ Ready to commit"
  else
    echo "❌ Not ready to commit"
    [ "$REVIEW_STATUS" != "passed" ] && echo "   - Review status: $REVIEW_STATUS"
    [ $COMPLETED_TASKS -eq 0 ] && echo "   - No completed tasks"
  fi
fi

exit 0
