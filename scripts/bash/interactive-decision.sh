#!/usr/bin/env bash

set -e

# Usage function
usage() {
    echo "Usage: $0 <feature_dir>"
    echo "  feature_dir  Path to the feature directory (e.g., specs/001-my-feature)"
    exit 1
}

# Check arguments
if [[ $# -eq 0 ]]; then
    usage
fi

FEATURE_DIR="$1"
PLAN_FILE="$FEATURE_DIR/plan.md"
OPTIONS_FILE="$FEATURE_DIR/options.md"

# Validate that files exist
if [[ ! -d "$FEATURE_DIR" ]]; then
    echo "ERROR: Feature directory not found: $FEATURE_DIR"
    exit 1
fi

if [[ ! -f "$PLAN_FILE" ]]; then
    echo "ERROR: plan.md not found in $FEATURE_DIR"
    exit 1
fi

if [[ ! -f "$OPTIONS_FILE" ]]; then
    echo "ERROR: options.md not found in $FEATURE_DIR"
    exit 1
fi

# Extract options from plan.md
display_options() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║           🎯 Implementation Options Decision Workflow                       ║"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    # Extract Option 1
    if grep -q "### Option 1:" "$PLAN_FILE"; then
        echo "OPTION 1:"
        grep -A 15 "### Option 1:" "$PLAN_FILE" | head -16
        echo ""
    fi

    # Extract Option 2
    if grep -q "### Option 2:" "$PLAN_FILE"; then
        echo "OPTION 2:"
        grep -A 15 "### Option 2:" "$PLAN_FILE" | head -16
        echo ""
    fi

    # Extract Option 3
    if grep -q "### Option 3:" "$PLAN_FILE"; then
        echo "OPTION 3:"
        grep -A 15 "### Option 3:" "$PLAN_FILE" | head -16
        echo ""
    fi
}

# Main interactive workflow
main() {
    display_options

    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════════"
    echo ""

    # Get user choice
    while true; do
        echo "📋 Choose your implementation approach:"
        echo "  [1] Option 1"
        echo "  [2] Option 2"
        echo "  [3] Option 3"
        echo "  [q] Quit without saving"
        echo ""
        read -p "Your choice (1-3 or q): " choice

        case "$choice" in
            1|2|3)
                SELECTED_OPTION=$choice
                break
                ;;
            q|Q)
                echo "Exiting without saving decision."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, or q."
                ;;
        esac
    done

    echo ""
    echo "✅ Selected: Option $SELECTED_OPTION"
    echo ""

    # Get reasoning
    read -p "Why Option $SELECTED_OPTION? (explain the decision rationale): " reasoning

    # Get confidence level
    while true; do
        read -p "Confidence level (1-10): " confidence
        if [[ "$confidence" =~ ^[1-9]$|^10$ ]]; then
            break
        else
            echo "Please enter a number between 1 and 10."
        fi
    done

    echo ""
    echo "💾 Saving decision..."

    # Update options.md with decision
    update_options_file "$SELECTED_OPTION" "$reasoning" "$confidence"

    # Update plan.md with selected approach
    update_plan_file "$SELECTED_OPTION" "$confidence"

    echo "✅ Decision recorded in options.md and plan.md"
    echo ""
    echo "📊 Decision Summary:"
    echo "  Option: $SELECTED_OPTION"
    echo "  Reasoning: $reasoning"
    echo "  Confidence: $confidence/10"
    echo ""
}

# Update options.md file
update_options_file() {
    local option_num=$1
    local reasoning=$2
    local confidence=$3

    # Create or update the decision section in options.md
    if grep -q "## Decision:" "$OPTIONS_FILE"; then
        # Replace existing decision section
        sed -i '' "/## Decision:/,$ {
            /## Decision:/c\\
## Decision: Selected Option $option_num\\
\\
**Chosen at**: $(date '+%Y-%m-%d %H:%M:%S')\\
**Confidence**: $confidence/10\\
\\
**Reasoning**:\\
$reasoning\\
\\
**Evidence Supporting This Choice**:\\
- [Update with findings from research.md]\\

**Key Risks to Watch**:\\
- [Identified risks]\\

**Success Criteria**:\\
- [Criteria]
        }" "$OPTIONS_FILE"
    else
        # Append decision section
        cat >> "$OPTIONS_FILE" << EOF

---

## Decision: Selected Option $option_num

**Chosen at**: $(date '+%Y-%m-%d %H:%M:%S')
**Confidence**: $confidence/10

**Reasoning**:
$reasoning

**Evidence Supporting This Choice**:
- [Add findings from research.md that support this choice]
- [Add relevant trade-offs considered]

**Key Risks to Watch**:
- [Identified risks and mitigation strategies]

**Success Criteria**:
- [Criteria for successful implementation]
EOF
    fi
}

# Update plan.md file
update_plan_file() {
    local option_num=$1
    local confidence=$2

    # Check if "Selected Approach" section exists
    if grep -q "## Selected Approach" "$PLAN_FILE"; then
        # Update existing section
        sed -i '' "/## Selected Approach/,/^##/ {
            s/\*\*Option Chosen\*\*: Option [0-9]/\*\*Option Chosen\*\*: Option $option_num/
            s/\*\*Confidence\*\*: [0-9]\+\/10/\*\*Confidence\*\*: $confidence\/10/
        }" "$PLAN_FILE"
    else
        # Append Selected Approach section
        cat >> "$PLAN_FILE" << EOF

---

## Selected Approach

**Option Chosen**: Option $option_num
**Decision Date**: $(date '+%Y-%m-%d')
**Confidence**: $confidence/10

**Why This Option**:
- [Update with reasoning specific to selected option]
- [Add benefits relative to other options]
- [Add any constraints that made this optimal]

**Key Risks to Watch**:
- [Risk 1 and mitigation strategy]
- [Risk 2 and mitigation strategy]

**Success Criteria**:
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

**Next Steps**:
1. Review this decision with team (if applicable)
2. Create detailed implementation plan
3. Begin implementation phase
EOF
    fi
}

# Run the main workflow
main
