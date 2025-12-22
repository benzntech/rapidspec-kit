#!/bin/bash

# Spec-Kit Spec Merger Script
# Purpose: Merge feature specs to canonical location
# Usage: ./merge-specs.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Find feature directory
FEATURE_DIR=$(find "$REPO_ROOT" -maxdepth 1 -type d -name "[0-9]*-*" | sort -r | head -1)

if [ -z "$FEATURE_DIR" ] || [ ! -d "$FEATURE_DIR" ]; then
  echo "Error: No feature directory found"
  exit 1
fi

FEATURE_NAME=$(basename "$FEATURE_DIR" | sed 's/^[0-9]\{3\}-//')
SPEC_FILE="$FEATURE_DIR/spec.md"

if [ ! -f "$SPEC_FILE" ]; then
  echo "Error: spec.md not found"
  exit 1
fi

cd "$REPO_ROOT"

# Create canonical specs directory if needed
mkdir -p specs

# Slugify feature name for filename
SLUG=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/-+/-/g')

# Copy spec to canonical location
CANONICAL_SPEC="specs/${SLUG}.md"

echo "Creating canonical spec: $CANONICAL_SPEC"
cp "$SPEC_FILE" "$CANONICAL_SPEC"

# Update or create specs index
echo "Updating specs index..."
if [ ! -f "specs/index.md" ]; then
  cat > "specs/index.md" << 'EOF'
# Feature Specification Catalog

## Completed Features (Production Ready)

EOF
fi

# Check if feature already in index
if ! grep -q "$CANONICAL_SPEC" "specs/index.md" 2>/dev/null; then
  # Add entry to index
  cat >> "specs/index.md" << EOF
- [$FEATURE_NAME]($CANONICAL_SPEC) - ✅ Complete ($(date +%Y-%m-%d))
EOF
fi

echo "✅ Spec merged successfully"
echo "Canonical location: $CANONICAL_SPEC"
echo "Index updated: specs/index.md"

exit 0
