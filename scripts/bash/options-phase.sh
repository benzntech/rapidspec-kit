#!/usr/bin/env bash

set -e

# Parse command line arguments
JSON_MODE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json]"
            echo "  --json    Output results in JSON format"
            echo "  --help    Show this help message"
            exit 0
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
done

# Get script directory and load common functions
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get all paths and variables from common functions
eval $(get_feature_paths)

# Ensure the feature directory exists
mkdir -p "$FEATURE_DIR"

# Create options.md if it doesn't exist
OPTIONS_FILE="$FEATURE_DIR/options.md"
if [[ ! -f "$OPTIONS_FILE" ]]; then
    cat > "$OPTIONS_FILE" << 'EOF'
# Implementation Options

## Overview
Document 2-3 implementation approaches for this feature based on research findings.

## Option 1: [Name]

**Description**: [1-2 sentences explaining what this approach is]

**Architecture**: [How it works at a high level]

**Pros** (Why choose this):
- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

**Cons** (Trade-offs):
- [Drawback 1]
- [Drawback 2]

**Cost Estimate**:
- **Time**: [X weeks/days]
- **Risk Level**: Low / Medium / High
- **Complexity**: Low / Medium / High

**Evidence from research**:
- [Reference implementation]: [What they found from research.md]
- [Industry standard]: [What the research showed]

**When to use**: [What conditions favor this approach]

---

## Option 2: [Name]

[Same structure as Option 1]

---

## Option 3: [Name]

[Same structure as Option 1]

---

## Comparison Table

| Aspect | Option 1 | Option 2 | Option 3 |
|--------|----------|----------|----------|
| Implementation Time | X weeks | Y weeks | Z weeks |
| Risk Level | Low/Med/High | Low/Med/High | Low/Med/High |
| Complexity | Low/Med/High | Low/Med/High | Low/Med/High |
| Scalability | [Rating] | [Rating] | [Rating] |
| Maintenance | [Rating] | [Rating] | [Rating] |
| Learning Curve | [Rating] | [Rating] | [Rating] |

---

## Decision: Selected Option [N]

**Chosen at**: [Date/Time]
**Confidence**: [1-10]

**Reasoning**:
[User's explanation of why this option was chosen]

**Evidence Supporting This Choice**:
- [Finding from research.md]
- [Finding from research.md]
- [Decision factors]

**Key Risks to Watch**:
- [Risk 1 and mitigation]
- [Risk 2 and mitigation]

**Success Criteria**:
- [Criterion 1]
- [Criterion 2]
EOF
    echo "Created options.md template"
fi

# Extract feature name from the feature directory
FEATURE_NAME=$(basename "$FEATURE_DIR" | sed 's/^[0-9]\{3\}-//')

# Append options template section to plan.md if it doesn't already exist
if [[ -f "$IMPL_PLAN" ]]; then
    if ! grep -q "## Phase 1.5: Implementation Options" "$IMPL_PLAN"; then
        cat >> "$IMPL_PLAN" << 'EOF'

## Phase 1.5: Implementation Options

Based on research findings, evaluate these implementation approaches:

### Option 1: [Name]

**Description**: [Brief description]

**Architecture**: [How it works]

**Pros**:
- [Benefit 1]
- [Benefit 2]

**Cons**:
- [Drawback 1]

**Cost**: [Time estimate] | [Risk] | [Complexity]

---

### Option 2: [Name]

[Same structure as Option 1]

---

### Option 3: [Name]

[Same structure as Option 1]

---

### Trade-offs Comparison

| Aspect | Option 1 | Option 2 | Option 3 |
|--------|----------|----------|----------|
| Time | | | |
| Risk | | | |
| Complexity | | | |

### Decision Factors
- [Factor 1]
- [Factor 2]
- [Factor 3]

---

## Selected Approach

**Option Chosen**: Option [N]
**Decision Date**: [Date]
**Confidence**: [1-10]

**Why This Option**:
- [Reason 1]
- [Reason 2]

**Key Risks to Watch**:
- [Risk 1 and mitigation]

**Success Criteria**:
- [Criterion 1]
- [Criterion 2]
EOF
        echo "Added options template to plan.md"
    fi
fi

# Output results
if $JSON_MODE; then
    printf '{"FEATURE_DIR":"%s","FEATURE_NAME":"%s","OPTIONS_FILE":"%s","FEATURE_SPEC":"%s"}\n' \
        "$FEATURE_DIR" "$FEATURE_NAME" "$OPTIONS_FILE" "$FEATURE_SPEC"
else
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "FEATURE_NAME: $FEATURE_NAME"
    echo "OPTIONS_FILE: $OPTIONS_FILE"
    echo "FEATURE_SPEC: $FEATURE_SPEC"
fi
