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

# Create or update research.md template
TEMPLATE="$REPO_ROOT/templates/research-template.md"
if [[ ! -f "$RESEARCH" ]]; then
    if [[ -f "$TEMPLATE" ]]; then
        cp "$TEMPLATE" "$RESEARCH"
        echo "Created research.md from template"
    else
        # Create a basic research.md if template doesn't exist
        cat > "$RESEARCH" << 'EOF'
# Research: [Feature Name]

## Best Practices
### Industry Standards
- [Standard]: [Description and source]

### Recommended Approaches
1. [Approach]: [Description and rationale]

## Framework Documentation
### [Technology Name]
- Documentation: [URL]
- Patterns: [Description]

## Reference Implementations
### [Project Name]
- Approach: [Description]
- Pros: [Benefits]
- Cons: [Drawbacks]

## Security & Performance
### Security
- [Consideration 1]
- [Consideration 2]

### Performance
- [Benchmark 1]
- [Benchmark 2]

## Trade-offs & Comparison
| Aspect | Option A | Option B | Option C |
|--------|----------|----------|----------|

## Sources & References
- [Title](URL)
EOF
        echo "Created basic research.md"
    fi
fi

# Extract feature name from the feature directory
FEATURE_NAME=$(basename "$FEATURE_DIR" | sed 's/^[0-9]\{3\}-//')

# Output results
if $JSON_MODE; then
    printf '{"FEATURE_DIR":"%s","FEATURE_NAME":"%s","RESEARCH":"%s","FEATURE_SPEC":"%s"}\n' \
        "$FEATURE_DIR" "$FEATURE_NAME" "$RESEARCH" "$FEATURE_SPEC"
else
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "FEATURE_NAME: $FEATURE_NAME"
    echo "RESEARCH: $RESEARCH"
    echo "FEATURE_SPEC: $FEATURE_SPEC"
fi
