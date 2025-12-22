#!/bin/bash

# Spec-Kit Review Report Script
# Purpose: Synthesize review findings and generate report
# Usage: ./review-report.sh

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
REVIEW_FILE="$FEATURE_DIR/review.md"

# Create review report header
cat > "$REVIEW_FILE" << 'EOF'
# Code Review Report

**Status**: Review in progress...
**Generated**: $(date)
**Feature**: {{FEATURE_NAME}}

---

## Review Summary

| Metric | Count |
|--------|-------|
| Files Reviewed | TBD |
| Critical Issues | TBD |
| Warnings | TBD |
| Info/Suggestions | TBD |
| Ready to Merge | TBD |

---

## Agent Results

### Code Quality Review
[Results from code-reviewer agent]

### Security Audit
[Results from security-auditor agent]

### Architecture Review
[Results from architecture-strategist agent]

### Conditional Reviews

#### Component Review
[Results from component-reviewer agent if applicable]

#### API Review
[Results from api-reviewer agent if applicable]

#### Database Review
[Results from database-reviewer agent if applicable]

#### Test Review
[Results from test-reviewer agent if applicable]

---

## Findings by Severity

### Critical Issues ❌
[List critical issues that must be fixed]

### Warnings ⚠️
[List warnings that should be addressed]

### Info/Suggestions 💡
[List suggestions for improvement]

---

## Merge Decision

**Ready to Merge**: [Yes/No]

**Reasoning**:
- [ ] No critical issues
- [ ] Warnings addressed
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Security reviewed

**Next Steps**:
1. Address critical issues
2. Consider addressing warnings
3. Run full test suite
4. Proceed to commit/merge

---

## Review Checklist

- [ ] Code quality approved
- [ ] Security audit passed
- [ ] Architecture approved
- [ ] Tests written/updated
- [ ] Documentation updated
- [ ] No critical issues
- [ ] Ready for deployment

---

**Review completed**: $(date)
**Reviewer**: AI Multi-Agent Review System
EOF

# Replace placeholder
sed -i.bak "s|{{FEATURE_NAME}}|$FEATURE_NAME|g" "$REVIEW_FILE"
rm -f "$REVIEW_FILE.bak"

echo "Review report created at: $REVIEW_FILE"
echo ""
echo "Next steps:"
echo "1. Review findings from each agent"
echo "2. Address critical issues"
echo "3. Consider warnings"
echo "4. Decide on merge readiness"

exit 0
