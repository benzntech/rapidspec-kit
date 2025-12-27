#!/usr/bin/env bash
set -euo pipefail

# bump-version.sh
# Automated version bumping and release triggering
# Single command to bump version and trigger release workflow
#
# Usage:
#   ./scripts/bump-version.sh patch       # 0.0.11 → 0.0.12
#   ./scripts/bump-version.sh minor       # 0.0.11 → 0.1.0
#   ./scripts/bump-version.sh major       # 0.1.0 → 1.0.0
#   ./scripts/bump-version.sh 0.0.12      # Explicit version
#
# What it does:
#   1. Validates current version in pyproject.toml
#   2. Calculates or uses provided new version
#   3. Updates pyproject.toml with new version
#   4. Creates commit with conventional commit format
#   5. Pushes to origin (triggers workflow)
#   6. Shows release progress info

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_error() {
  echo -e "${RED}✗ Error: $1${NC}" >&2
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ $1${NC}"
}

print_step() {
  echo -e "${YELLOW}→ $1${NC}"
}

# Validate we're in git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  print_error "Not in a git repository"
  exit 1
fi

# Check if pyproject.toml exists
if [[ ! -f "pyproject.toml" ]]; then
  print_error "pyproject.toml not found"
  exit 1
fi

# Get current version
CURRENT_VERSION=$(grep -m 1 'version = ' pyproject.toml | sed 's/.*version = "\([^"]*\)".*/\1/')

if [[ -z "$CURRENT_VERSION" ]]; then
  print_error "Could not find version in pyproject.toml"
  exit 1
fi

print_info "Current version: $CURRENT_VERSION"

# Determine new version
if [[ $# -eq 0 ]]; then
  print_error "Missing version argument"
  echo "Usage: $0 <patch|minor|major|X.Y.Z>"
  echo "Examples:"
  echo "  $0 patch       # Bump patch version"
  echo "  $0 minor       # Bump minor version"
  echo "  $0 major       # Bump major version"
  echo "  $0 0.0.12      # Explicit version"
  exit 1
fi

VERSION_ARG="$1"

# Parse version components
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]:-0}
MINOR=${VERSION_PARTS[1]:-0}
PATCH=${VERSION_PARTS[2]:-0}

# Calculate new version based on argument
case "$VERSION_ARG" in
  patch)
    PATCH=$((PATCH + 1))
    NEW_VERSION="$MAJOR.$MINOR.$PATCH"
    VERSION_TYPE="patch"
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    NEW_VERSION="$MAJOR.$MINOR.$PATCH"
    VERSION_TYPE="minor"
    ;;
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    NEW_VERSION="$MAJOR.$MINOR.$PATCH"
    VERSION_TYPE="major"
    ;;
  *)
    # Assume explicit version
    if [[ ! "$VERSION_ARG" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      print_error "Invalid version format: $VERSION_ARG"
      echo "Expected: patch, minor, major, or X.Y.Z format"
      exit 1
    fi
    NEW_VERSION="$VERSION_ARG"
    VERSION_TYPE="explicit"
    ;;
esac

print_step "Updating version: $CURRENT_VERSION → $NEW_VERSION"

# Check if version is going backwards
if [[ "$NEW_VERSION" < "$CURRENT_VERSION" ]]; then
  print_error "New version is older than current version"
  exit 1
fi

# Check if version is same
if [[ "$NEW_VERSION" == "$CURRENT_VERSION" ]]; then
  print_error "New version is same as current version"
  exit 1
fi

# Update pyproject.toml
sed -i.bak "s/version = \"$CURRENT_VERSION\"/version = \"$NEW_VERSION\"/" pyproject.toml
rm -f pyproject.toml.bak

print_success "Updated pyproject.toml"

# Verify update
VERIFIED_VERSION=$(grep -m 1 'version = ' pyproject.toml | sed 's/.*version = "\([^"]*\)".*/\1/')
if [[ "$VERIFIED_VERSION" != "$NEW_VERSION" ]]; then
  print_error "Version verification failed"
  git checkout pyproject.toml
  exit 1
fi

print_info "Verified version: $VERIFIED_VERSION"

# Create appropriate commit message based on version type
case "$VERSION_TYPE" in
  patch)
    COMMIT_MSG="chore: Bump version to $NEW_VERSION

Patch release with bug fixes and improvements."
    ;;
  minor)
    COMMIT_MSG="feat: Bump version to $NEW_VERSION

Minor release with new features."
    ;;
  major)
    COMMIT_MSG="feat!: Bump version to $NEW_VERSION

Major release with breaking changes."
    ;;
  *)
    COMMIT_MSG="chore: Bump version to $NEW_VERSION"
    ;;
esac

# Check git status
print_step "Committing changes..."

git add pyproject.toml

# Create commit
git commit -m "$COMMIT_MSG" || {
  print_error "Failed to create commit"
  exit 1
}

print_success "Created commit"

# Push to origin
print_step "Pushing to origin..."

git push origin $(git rev-parse --abbrev-ref HEAD) || {
  print_error "Failed to push to origin"
  print_info "Reverting commit..."
  git reset --soft HEAD~1
  git checkout pyproject.toml
  exit 1
}

print_success "Pushed to origin"

# Show workflow trigger info
print_step "Workflow triggered automatically"
print_info "Release v$NEW_VERSION will be created shortly"
print_info "Check progress: gh run list --workflow=release.yml --limit=1"

# Show next steps
echo ""
echo -e "${GREEN}═════════════════════════════════════════════${NC}"
echo -e "${GREEN}Release v$NEW_VERSION is being prepared${NC}"
echo -e "${GREEN}═════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "  1. Wait for workflow to complete (1-2 minutes)"
echo "  2. Check status: gh run list --workflow=release.yml --limit=1"
echo "  3. View release: gh release view v$NEW_VERSION"
echo "  4. Download packages: gh release download v$NEW_VERSION"
echo ""
echo "Release details:"
echo "  Version: v$NEW_VERSION"
echo "  Type: $VERSION_TYPE"
echo "  Packages: 34 (17 models × 2 script types)"
echo ""
