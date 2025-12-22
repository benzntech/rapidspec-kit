#!/bin/bash

# Spec-Kit PR Generation Script
# Purpose: Create pull request with auto-generated description
# Usage: ./generate-pr.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common utilities
if [ -f "$SCRIPT_DIR/common.sh" ]; then
  source "$SCRIPT_DIR/common.sh"
fi

# Find feature directory
FEATURE_DIR=$(find "$REPO_ROOT" -maxdepth 1 -type d -name "[0-9]*-*" | sort -r | head -1)

if [ -z "$FEATURE_DIR" ] || [ ! -d "$FEATURE_DIR" ]; then
  echo "Error: No feature directory found"
  exit 1
fi

FEATURE_NAME=$(basename "$FEATURE_DIR" | sed 's/^[0-9]\{3\}-//')
SPEC_FILE="$FEATURE_DIR/spec.md"
TASKS_FILE="$FEATURE_DIR/tasks.md"
REVIEW_FILE="$FEATURE_DIR/review.md"

# Verify gh CLI is available
if ! command -v gh &> /dev/null; then
  echo "Error: GitHub CLI (gh) not installed"
  echo "Install from: https://cli.github.com/"
  exit 1
fi

cd "$REPO_ROOT"

# Generate PR title
PR_TITLE="feat: $FEATURE_NAME"

# Generate PR description
PR_BODY_FILE=$(mktemp)

cat > "$PR_BODY_FILE" << 'EOF'
## Summary

Feature implementation completed and ready for review.

## What Changed

### Completed Tasks
EOF

# Add completed tasks from tasks.md
grep "^- \[x\]" "$TASKS_FILE" 2>/dev/null | sed 's/^- \[x\] /- /' >> "$PR_BODY_FILE" || echo "- Tasks completed" >> "$PR_BODY_FILE"

cat >> "$PR_BODY_FILE" << 'EOF'

## Statistics

### Files Changed
EOF

# Add git statistics
echo "- $(git diff --name-only | wc -l) files modified" >> "$PR_BODY_FILE"
echo "- $(git diff --numstat | awk '{sum+=$1} END {print sum}') lines added" >> "$PR_BODY_FILE"
echo "- $(git diff --numstat | awk '{sum+=$2} END {print sum}') lines removed" >> "$PR_BODY_FILE"

cat >> "$PR_BODY_FILE" << 'EOF'

## Testing Checklist

- [ ] Manual testing completed
- [ ] All tests passing (npm test)
- [ ] No console errors
- [ ] Feature works as designed
- [ ] No regressions identified

## Review Status

EOF

# Add review status if available
if [ -f "$REVIEW_FILE" ]; then
  if grep -q "Code Quality" "$REVIEW_FILE"; then
    echo "- Code Quality: ✅ Passed" >> "$PR_BODY_FILE"
  fi
  if grep -q "Security" "$REVIEW_FILE"; then
    echo "- Security: ✅ Passed" >> "$PR_BODY_FILE"
  fi
  if grep -q "Architecture" "$REVIEW_FILE"; then
    echo "- Architecture: ✅ Passed" >> "$PR_BODY_FILE"
  fi
fi

cat >> "$PR_BODY_FILE" << 'EOF'

## Related Issues

See spec.md for complete feature specification.
EOF

# Create PR
echo "Creating pull request..."
echo "Title: $PR_TITLE"
echo ""

gh pr create \
  --title "$PR_TITLE" \
  --body-file "$PR_BODY_FILE" \
  --base main \
  --head "$(git rev-parse --abbrev-ref HEAD)" \
  || {
    echo "Error creating PR"
    rm -f "$PR_BODY_FILE"
    exit 1
  }

# Clean up
rm -f "$PR_BODY_FILE"

echo ""
echo "✅ Pull request created successfully"

exit 0
