#!/usr/bin/env bash
set -euo pipefail

# get-next-version.sh
# Read version from pyproject.toml (source of truth) and output GitHub Actions variables
# PERMANENT SOLUTION: Always read from pyproject.toml to prevent version mismatch issues
# 
# This script ensures that:
# 1. Version comes from pyproject.toml (single source of truth)
# 2. Workflow doesn't calculate versions incrementally from tags
# 3. Release is created for any version bump in pyproject.toml
# 4. Git tags are kept in sync with releases
#
# Usage: get-next-version.sh

# Validate that pyproject.toml exists
if [[ ! -f pyproject.toml ]]; then
  echo "Error: pyproject.toml not found" >&2
  exit 1
fi

# Read version from pyproject.toml (source of truth)
PYPROJECT_VERSION=$(grep -m 1 'version = ' pyproject.toml | sed 's/.*version = "\([^"]*\)".*/\1/')

# Validate version format (should be X.Y.Z)
if ! [[ $PYPROJECT_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid version format in pyproject.toml: $PYPROJECT_VERSION" >&2
  echo "Expected format: X.Y.Z (e.g., 0.0.11)" >&2
  exit 1
fi

NEW_VERSION="v$PYPROJECT_VERSION"

# Get the latest tag for comparison (may be behind pyproject.toml)
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

# Log version information for debugging
echo "Version Information:" >&2
echo "  pyproject.toml: $PYPROJECT_VERSION" >&2
echo "  release tag: $NEW_VERSION" >&2
echo "  latest tag: $LATEST_TAG" >&2

# Check if version is ahead of latest tag
LATEST_VERSION="${LATEST_TAG#v}"
if [[ "$PYPROJECT_VERSION" > "$LATEST_VERSION" ]] || [[ "$PYPROJECT_VERSION" == "$LATEST_VERSION" && "$NEW_VERSION" != "$LATEST_TAG" ]]; then
  echo "  status: Ready for release" >&2
else
  echo "  status: Version already released" >&2
fi

# Output variables for GitHub Actions
echo "latest_tag=$LATEST_TAG" >> $GITHUB_OUTPUT
echo "new_version=$NEW_VERSION" >> $GITHUB_OUTPUT
echo "pyproject_version=$PYPROJECT_VERSION" >> $GITHUB_OUTPUT
