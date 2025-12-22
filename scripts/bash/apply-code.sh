#!/bin/bash

# Spec-Kit Code Application Script
# Purpose: Initialize code application phase with checkpoint tracking
# Usage: ./apply-code.sh --json

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
PLAN_FILE=""
TASKS_FILE=""
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
  FEATURE_DIR=$(find "$REPO_ROOT" -maxdepth 1 -type d -name "[0-9]*-*" | sort -r | head -1)
fi

if [ -z "$FEATURE_DIR" ] || [ ! -d "$FEATURE_DIR" ]; then
  echo "Error: No feature directory found"
  exit 1
fi

FEATURE_NAME=$(basename "$FEATURE_DIR" | sed 's/^[0-9]\{3\}-//')
PLAN_FILE="$FEATURE_DIR/plan.md"
TASKS_FILE="$FEATURE_DIR/tasks.md"

# Verify required files exist
if [ ! -f "$PLAN_FILE" ]; then
  echo "Error: plan.md not found at $PLAN_FILE"
  exit 1
fi

if [ ! -f "$TASKS_FILE" ]; then
  echo "Error: tasks.md not found at $TASKS_FILE"
  exit 1
fi

# Count pending tasks
PENDING_TASKS=$(grep -c "^- \[ \]" "$TASKS_FILE" || echo "0")
COMPLETED_TASKS=$(grep -c "^- \[x\]" "$TASKS_FILE" || echo "0")
TOTAL_TASKS=$((PENDING_TASKS + COMPLETED_TASKS))

# Output based on format
if [ "$OUTPUT_FORMAT" = "json" ]; then
  cat <<EOF
{
  "feature_dir": "$FEATURE_DIR",
  "feature_name": "$FEATURE_NAME",
  "plan_file": "$PLAN_FILE",
  "tasks_file": "$TASKS_FILE",
  "repo_root": "$REPO_ROOT",
  "total_tasks": $TOTAL_TASKS,
  "pending_tasks": $PENDING_TASKS,
  "completed_tasks": $COMPLETED_TASKS,
  "progress": $(echo "scale=1; ($COMPLETED_TASKS / $TOTAL_TASKS) * 100" | bc 2>/dev/null || echo "0"),
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
else
  echo "Feature Directory: $FEATURE_DIR"
  echo "Feature Name: $FEATURE_NAME"
  echo "Plan File: $PLAN_FILE"
  echo "Tasks File: $TASKS_FILE"
  echo "Repo Root: $REPO_ROOT"
  echo ""
  echo "Task Summary:"
  echo "  Total Tasks: $TOTAL_TASKS"
  echo "  Pending: $PENDING_TASKS"
  echo "  Completed: $COMPLETED_TASKS"
  echo "  Progress: $(echo "scale=1; ($COMPLETED_TASKS / $TOTAL_TASKS) * 100" | bc 2>/dev/null || echo "0")%"
fi

exit 0
