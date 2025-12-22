#!/bin/bash

# Spec-Kit Feature Archive Script
# Purpose: Archive feature artifacts to specs/archive/
# Usage: ./archive-feature.sh

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

# Create archive directory
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE_DIR="$REPO_ROOT/specs/archive/${TIMESTAMP}-${FEATURE_NAME}"

echo "Creating archive directory: $ARCHIVE_DIR"
mkdir -p "$ARCHIVE_DIR"

# Copy artifacts
echo "Copying artifacts..."
for file in spec.md plan.md tasks.md research.md options.md review.md verification.md; do
  if [ -f "$FEATURE_DIR/$file" ]; then
    cp "$FEATURE_DIR/$file" "$ARCHIVE_DIR/"
    echo "  ✓ $file"
  fi
done

# Create manifest
echo "Creating manifest..."
cat > "$ARCHIVE_DIR/manifest.json" << EOF
{
  "feature_name": "$FEATURE_NAME",
  "archived_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "feature_directory": "$FEATURE_DIR",
  "duration_days": $(($(date +%s) - $(stat -f%B "$FEATURE_DIR" 2>/dev/null || date +%s) / 86400)),
  "artifacts": [
EOF

# Add artifacts list
for file in spec.md plan.md tasks.md research.md options.md review.md verification.md; do
  if [ -f "$ARCHIVE_DIR/$file" ]; then
    echo "    \"$file\"," >> "$ARCHIVE_DIR/manifest.json"
  fi
done

# Remove trailing comma and close JSON
sed -i '' '$ s/,$//' "$ARCHIVE_DIR/manifest.json"
cat >> "$ARCHIVE_DIR/manifest.json" << EOF
  ]
}
EOF

# Store archival metadata
echo "Archived: $(date)" > "$ARCHIVE_DIR/ARCHIVED"
echo "Feature: $FEATURE_NAME" >> "$ARCHIVE_DIR/ARCHIVED"
echo "Archive ID: ${TIMESTAMP}-${FEATURE_NAME}" >> "$ARCHIVE_DIR/ARCHIVED"

echo ""
echo "✅ Feature archived successfully"
echo "Archive location: $ARCHIVE_DIR"

exit 0
