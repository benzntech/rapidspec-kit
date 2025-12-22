#!/bin/bash

# Spec-Kit Change Detection Script
# Purpose: Detect what changed to determine which agents should run
# Usage: ./detect-changes.sh --json

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

# Get git changes
CHANGED_FILES=$(git diff --name-only 2>/dev/null || echo "")

# Initialize detection flags
HAS_COMPONENT_CHANGES=0
HAS_API_CHANGES=0
HAS_DB_CHANGES=0
HAS_TEST_CHANGES=0

# Detect component changes (React/Vue)
if echo "$CHANGED_FILES" | grep -qE '\.(tsx?|jsx?)$' && echo "$CHANGED_FILES" | grep -qE '(components|views|pages)/'; then
  HAS_COMPONENT_CHANGES=1
fi

# Detect API changes
if echo "$CHANGED_FILES" | grep -qE '(api|routes|handlers|controllers)/.*\.(ts|js)$'; then
  HAS_API_CHANGES=1
fi

# Detect database changes
if echo "$CHANGED_FILES" | grep -qE '\.(sql|ts|js)$' && echo "$CHANGED_FILES" | grep -qE '(migrations|schema|database)/'; then
  HAS_DB_CHANGES=1
fi

# Detect test changes
if echo "$CHANGED_FILES" | grep -qE '\.(test|spec)\.(ts|js|tsx)$'; then
  HAS_TEST_CHANGES=1
fi

# Count changed files
TOTAL_CHANGES=$(echo "$CHANGED_FILES" | grep -c . || echo "0")

# Output based on format
if [ "$OUTPUT_FORMAT" = "json" ]; then
  cat <<EOF
{
  "total_changes": $TOTAL_CHANGES,
  "component_changes": $HAS_COMPONENT_CHANGES,
  "api_changes": $HAS_API_CHANGES,
  "database_changes": $HAS_DB_CHANGES,
  "test_changes": $HAS_TEST_CHANGES,
  "agents_to_run": [
    "code-reviewer",
    "security-auditor",
    "architecture-strategist"
    $([ $HAS_COMPONENT_CHANGES -eq 1 ] && echo ",\"component-reviewer\"")
    $([ $HAS_API_CHANGES -eq 1 ] && echo ",\"api-reviewer\"")
    $([ $HAS_DB_CHANGES -eq 1 ] && echo ",\"database-reviewer\"")
    $([ $HAS_TEST_CHANGES -eq 1 ] && echo ",\"test-reviewer\"")
  ],
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
else
  echo "Change Detection Results"
  echo "======================="
  echo "Total Changes: $TOTAL_CHANGES"
  echo ""
  echo "Detected Changes:"
  echo "  Component Changes: $([ $HAS_COMPONENT_CHANGES -eq 1 ] && echo "Yes" || echo "No")"
  echo "  API Changes: $([ $HAS_API_CHANGES -eq 1 ] && echo "Yes" || echo "No")"
  echo "  Database Changes: $([ $HAS_DB_CHANGES -eq 1 ] && echo "Yes" || echo "No")"
  echo "  Test Changes: $([ $HAS_TEST_CHANGES -eq 1 ] && echo "Yes" || echo "No")"
  echo ""
  echo "Agents to Run:"
  echo "  - code-reviewer (always)"
  echo "  - security-auditor (always)"
  echo "  - architecture-strategist (always)"
  [ $HAS_COMPONENT_CHANGES -eq 1 ] && echo "  - component-reviewer"
  [ $HAS_API_CHANGES -eq 1 ] && echo "  - api-reviewer"
  [ $HAS_DB_CHANGES -eq 1 ] && echo "  - database-reviewer"
  [ $HAS_TEST_CHANGES -eq 1 ] && echo "  - test-reviewer"
fi

exit 0
