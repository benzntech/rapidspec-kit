#!/bin/bash

# Spec-Kit Checkpoint Approval Script
# Purpose: Interactive approval prompts for code changes
# Usage: ./checkpoint-approval.sh <prompt-type> [options]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Prompt types
PROMPT_TYPE="$1"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_apply_prompt() {
  local task_name="$1"
  local file_path="$2"

  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
  echo "Apply this change to $file_path?"
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
  echo ""
  echo "Task: $task_name"
  echo ""
  echo "Options:"
  echo "  [${GREEN}yes${NC}]   ✅ Proceed - Apply the change"
  echo "  [${YELLOW}wait${NC}]  ⏸️  Pause - Let me review this more"
  echo "  [${YELLOW}skip${NC}]  ⏭️  Skip - Move to next task"
  echo "  [${YELLOW}edit${NC}]  ✏️  Edit - Modify the proposal"
  echo "  [${BLUE}help${NC}]  ❓ Help - Explain the change"
  echo ""
  echo -n "> "
}

show_continue_prompt() {
  local task_name="$1"

  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}✅ Task Complete: $task_name${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
  echo ""
  echo "Test this change?"
  echo ""
  echo "Options:"
  echo "  [${GREEN}yes${NC}]     ✅ Continue to next task - Looks good!"
  echo "  [${YELLOW}wait${NC}]    ⏸️  Let me test this first (pause)"
  echo "  [${YELLOW}review${NC}]  ↩️  Show me the change again"
  echo ""
  echo -n "> "
}

show_improvement_prompt() {
  local improvement="$1"

  echo ""
  echo -e "${BLUE}─────────────────────────────────────────────────────${NC}"
  echo -e "${YELLOW}💡 Discovered: $improvement${NC}"
  echo -e "${BLUE}─────────────────────────────────────────────────────${NC}"
  echo ""
  echo "Should we add this improvement?"
  echo ""
  echo "Options:"
  echo "  [${GREEN}yes${NC}]    Include in this task"
  echo "  [${YELLOW}later${NC}]  Add to tasks list"
  echo "  [${YELLOW}skip${NC}]   Skip this improvement"
  echo ""
  echo -n "> "
}

show_final_prompt() {
  local tasks_completed="$1"
  local total_tasks="$2"

  echo ""
  echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}✅ Implementation Complete${NC}"
  echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
  echo ""
  echo "Completed: $tasks_completed of $total_tasks tasks"
  echo ""
  echo "Ready to commit?"
  echo ""
  echo "Options:"
  echo "  [${GREEN}yes${NC}]   Proceed to review and commit"
  echo "  [${YELLOW}wait${NC}]  Let me test these changes first"
  echo ""
  echo -n "> "
}

show_error_prompt() {
  local error_message="$1"

  echo ""
  echo -e "${RED}═══════════════════════════════════════════════════════${NC}"
  echo -e "${RED}❌ Error${NC}"
  echo -e "${RED}═══════════════════════════════════════════════════════${NC}"
  echo ""
  echo "Error: $error_message"
  echo ""
  echo "Options:"
  echo "  [${YELLOW}retry${NC}]  Try again"
  echo "  [${YELLOW}skip${NC}]   Skip this task"
  echo "  [${RED}stop${NC}]   Stop application"
  echo ""
  echo -n "> "
}

show_progress() {
  local completed="$1"
  local total="$2"

  # Calculate progress
  local percent=$((completed * 100 / total))
  local bar_length=40
  local filled=$((bar_length * completed / total))
  local empty=$((bar_length - filled))

  # Build progress bar
  local bar="$(printf '█%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))"

  echo ""
  echo "Progress: $bar $percent% ($completed/$total tasks)"
  echo ""
}

# Handle prompt types
case $PROMPT_TYPE in
  "apply")
    show_apply_prompt "$2" "$3"
    ;;
  "continue")
    show_continue_prompt "$2"
    ;;
  "improvement")
    show_improvement_prompt "$2"
    ;;
  "final")
    show_final_prompt "$2" "$3"
    ;;
  "error")
    show_error_prompt "$2"
    ;;
  "progress")
    show_progress "$2" "$3"
    ;;
  *)
    echo "Unknown prompt type: $PROMPT_TYPE"
    echo "Valid types: apply, continue, improvement, final, error, progress"
    exit 1
    ;;
esac
