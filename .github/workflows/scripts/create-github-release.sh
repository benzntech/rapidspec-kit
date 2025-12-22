#!/usr/bin/env bash
set -euo pipefail

# create-github-release.sh
# Create a GitHub release with all template zip files
# Usage: create-github-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Remove 'v' prefix from version for release title
VERSION_NO_V=${VERSION#v}

gh release create "$VERSION" \
  .genreleases/rapidspec-template-copilot-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-copilot-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-claude-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-claude-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-gemini-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-gemini-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-cursor-agent-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-cursor-agent-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-opencode-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-opencode-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-qwen-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-qwen-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-windsurf-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-windsurf-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-codex-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-codex-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-kilocode-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-kilocode-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-auggie-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-auggie-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-roo-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-roo-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-codebuddy-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-codebuddy-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-qoder-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-qoder-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-amp-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-amp-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-shai-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-shai-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-q-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-q-ps-"$VERSION".zip \
  .genreleases/rapidspec-template-bob-sh-"$VERSION".zip \
  .genreleases/rapidspec-template-bob-ps-"$VERSION".zip \
  --title "RapidSpec Templates - $VERSION_NO_V" \
  --notes-file release_notes.md
