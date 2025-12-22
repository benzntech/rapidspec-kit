#!/usr/bin/env pwsh

# Spec-Kit Spec Merger Script
# Purpose: Merge feature specs to canonical location
# Usage: .\merge-specs.ps1

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT = (Get-Item (Join-Path $SCRIPT_DIR "../..")).FullName

# Find feature directory
$featureDirs = @(Get-ChildItem -Path $REPO_ROOT -Directory -ErrorAction SilentlyContinue |
                 Where-Object { $_.Name -match '^\d{3}-' } |
                 Sort-Object -Property Name -Descending |
                 Select-Object -First 1)

if (-not $featureDirs) {
    Write-Error "No feature directory found"
    exit 1
}

$FEATURE_DIR = $featureDirs[0].FullName
$FEATURE_NAME = (Get-Item $FEATURE_DIR).Name -replace '^\d{3}-', ''
$SPEC_FILE = Join-Path $FEATURE_DIR "spec.md"

if (-not (Test-Path $SPEC_FILE -PathType Leaf)) {
    Write-Error "spec.md not found"
    exit 1
}

Push-Location $REPO_ROOT
try {
    # Create canonical specs directory if needed
    New-Item -ItemType Directory -Path "specs" -Force | Out-Null

    # Slugify feature name for filename
    $SLUG = $FEATURE_NAME.ToLower() -replace '[^a-z0-9-]', '-' -replace '-+', '-'

    # Copy spec to canonical location
    $CANONICAL_SPEC = "specs/$SLUG.md"

    Write-Output "Creating canonical spec: $CANONICAL_SPEC"
    Copy-Item -Path $SPEC_FILE -Destination $CANONICAL_SPEC -Force

    # Update or create specs index
    Write-Output "Updating specs index..."
    $INDEX_FILE = "specs/index.md"

    if (-not (Test-Path $INDEX_FILE -PathType Leaf)) {
        $indexContent = @"
# Feature Specification Catalog

## Completed Features (Production Ready)

"@
        Set-Content -Path $INDEX_FILE -Value $indexContent
    }

    # Check if feature already in index
    $indexContent = Get-Content $INDEX_FILE -Raw
    if ($indexContent -notmatch [regex]::Escape($CANONICAL_SPEC)) {
        # Add entry to index
        $entry = "`n- [$FEATURE_NAME]($CANONICAL_SPEC) - ✅ Complete ($(Get-Date -Format 'yyyy-MM-dd'))"
        Add-Content -Path $INDEX_FILE -Value $entry
    }

    Write-Output "✅ Spec merged successfully"
    Write-Output "Canonical location: $CANONICAL_SPEC"
    Write-Output "Index updated: $INDEX_FILE"

} finally {
    Pop-Location
}

exit 0
