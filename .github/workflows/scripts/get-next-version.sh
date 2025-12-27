#!/usr/bin/env bash
set -euo pipefail

# get-next-version.sh
# Read version from pyproject.toml (source of truth) and output GitHub Actions variables
# Usage: get-next-version.sh

# Read version from pyproject.toml
PYPROJECT_VERSION=$(grep -m 1 'version = ' pyproject.toml | sed 's/.*version = "\([^"]*\)".*/\1/')
NEW_VERSION="v$PYPROJECT_VERSION"

# Get the latest tag for reference (may be behind pyproject.toml)
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

echo "latest_tag=$LATEST_TAG" >> $GITHUB_OUTPUT
echo "new_version=$NEW_VERSION" >> $GITHUB_OUTPUT
echo "pyproject_version=$PYPROJECT_VERSION" >> $GITHUB_OUTPUT
echo "New version from pyproject.toml: $NEW_VERSION (latest tag was: $LATEST_TAG)"
