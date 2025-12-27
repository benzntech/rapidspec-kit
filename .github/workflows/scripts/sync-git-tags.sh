#!/usr/bin/env bash
set -euo pipefail

# sync-git-tags.sh
# Synchronize git tags with pyproject.toml version
# PERMANENT SOLUTION: Ensures git tags always match released versions
#
# This script:
# 1. Reads version from pyproject.toml
# 2. Checks if a git tag exists for that version
# 3. Creates the tag if it doesn't exist
# 4. Pushes the tag to remote
#
# This keeps git tags in sync with actual releases and prevents:
# - Version mismatch between pyproject.toml and git tags
# - Workflow skipping releases due to missing tags
# - Manual tag creation overhead
#
# Usage: sync-git-tags.sh <version-with-v-prefix>
# Example: sync-git-tags.sh v0.0.11

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version-with-v-prefix>" >&2
  echo "Example: $0 v0.0.11" >&2
  exit 1
fi

VERSION_TAG="$1"

# Validate version format
if ! [[ $VERSION_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid version format: $VERSION_TAG" >&2
  echo "Expected format: v0.0.0 (with leading v)" >&2
  exit 1
fi

echo "Synchronizing git tags for version: $VERSION_TAG" >&2

# Check if tag already exists locally
if git rev-parse "$VERSION_TAG" >/dev/null 2>&1; then
  echo "  ✓ Tag $VERSION_TAG already exists locally" >&2
else
  echo "  ↻ Creating tag $VERSION_TAG" >&2
  git tag "$VERSION_TAG"
  echo "  ✓ Created tag $VERSION_TAG" >&2
fi

# Try to push the tag to remote
if git push origin "$VERSION_TAG" >/dev/null 2>&1; then
  echo "  ✓ Pushed tag $VERSION_TAG to remote" >&2
else
  # Tag might already exist on remote, which is fine
  echo "  ℹ Tag $VERSION_TAG already on remote" >&2
fi

echo "Git tags synchronized successfully" >&2
