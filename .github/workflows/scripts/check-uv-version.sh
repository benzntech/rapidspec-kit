#!/usr/bin/env bash
set -euo pipefail

# check-uv-version.sh
# Check if UV package manager is installed and up-to-date
# Downloads latest version if outdated
#
# Usage: check-uv-version.sh [--min-version X.Y.Z]
#
# This script:
# 1. Checks if 'uv' command is available
# 2. Gets current installed version
# 3. Compares with latest available version
# 4. Downloads latest if outdated
# 5. Reports status to GitHub Actions or terminal

# Default minimum version requirement
MIN_VERSION="0.1.0"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --min-version)
      MIN_VERSION="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
  echo -e "${BLUE}ℹ $1${NC}" >&2
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}" >&2
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}" >&2
}

print_error() {
  echo -e "${RED}✗ $1${NC}" >&2
}

# Check if UV is installed
if ! command -v uv &> /dev/null; then
  print_info "UV not found - installing latest version"
  
  # Install UV
  if command -v curl &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    print_success "UV installed successfully"
    exit 0
  elif command -v wget &> /dev/null; then
    wget -qO- https://astral.sh/uv/install.sh | sh
    print_success "UV installed successfully"
    exit 0
  else
    print_error "Neither curl nor wget found - cannot install UV"
    exit 1
  fi
fi

# Get current version
CURRENT_VERSION=$(uv --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)

if [[ -z "$CURRENT_VERSION" ]]; then
  print_warning "Could not determine UV version"
  exit 0
fi

print_info "Current UV version: $CURRENT_VERSION"

# Fetch latest version from GitHub API
LATEST_VERSION=$(curl -s https://api.github.com/repos/astral-sh/uv/releases/latest | grep -oP '"tag_name": "v\K[^"]+' | head -1)

if [[ -z "$LATEST_VERSION" ]]; then
  print_warning "Could not fetch latest UV version from GitHub"
  exit 0
fi

print_info "Latest UV version: $LATEST_VERSION"

# Compare versions
compare_versions() {
  # Simple version comparison (works for X.Y.Z format)
  local ver1=$1
  local ver2=$2
  
  # Convert to integer for comparison (e.g., 0.1.5 -> 000001005)
  local v1=$(echo "$ver1" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')
  local v2=$(echo "$ver2" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')
  
  if [[ $v1 -lt $v2 ]]; then
    echo "outdated"
  elif [[ $v1 -eq $v2 ]]; then
    echo "current"
  else
    echo "newer"
  fi
}

# Check if update is needed
STATUS=$(compare_versions "$CURRENT_VERSION" "$LATEST_VERSION")

case "$STATUS" in
  current|newer)
    print_success "UV is up-to-date"
    ;;
  outdated)
    print_warning "UV is outdated ($CURRENT_VERSION → $LATEST_VERSION)"
    print_info "Updating UV..."
    
    # Update UV
    if command -v curl &> /dev/null; then
      curl -LsSf https://astral.sh/uv/install.sh | sh
      print_success "UV updated to $LATEST_VERSION"
    elif command -v wget &> /dev/null; then
      wget -qO- https://astral.sh/uv/install.sh | sh
      print_success "UV updated to $LATEST_VERSION"
    else
      print_error "Cannot update UV - neither curl nor wget available"
      exit 1
    fi
    ;;
esac

# Verify minimum version requirement
MIN_VER=$(echo "$MIN_VERSION" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')
CURRENT_VER=$(echo "$CURRENT_VERSION" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')

if [[ $CURRENT_VER -lt $MIN_VER ]]; then
  print_error "UV version $CURRENT_VERSION is below minimum requirement $MIN_VERSION"
  exit 1
fi

print_success "UV version check passed ($CURRENT_VERSION)"
exit 0
