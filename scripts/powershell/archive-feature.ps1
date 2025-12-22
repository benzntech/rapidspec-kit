#!/usr/bin/env pwsh

# Spec-Kit Feature Archive Script
# Purpose: Archive feature artifacts to specs/archive/
# Usage: .\archive-feature.ps1

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

# Create archive directory
$TIMESTAMP = Get-Date -Format "yyyyMMdd-HHmmss"
$ARCHIVE_DIR = Join-Path $REPO_ROOT "specs/archive/${TIMESTAMP}-${FEATURE_NAME}"

Write-Output "Creating archive directory: $ARCHIVE_DIR"
New-Item -ItemType Directory -Path $ARCHIVE_DIR -Force | Out-Null

# Copy artifacts
Write-Output "Copying artifacts..."
$artifacts = @("spec.md", "plan.md", "tasks.md", "research.md", "options.md", "review.md", "verification.md")

foreach ($file in $artifacts) {
    $sourcePath = Join-Path $FEATURE_DIR $file
    if (Test-Path $sourcePath -PathType Leaf) {
        Copy-Item -Path $sourcePath -Destination $ARCHIVE_DIR -Force
        Write-Output "  ✓ $file"
    }
}

# Create manifest
Write-Output "Creating manifest..."
$createdAt = Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ'

# Get feature directory creation time for duration calculation
$featureDirInfo = Get-Item $FEATURE_DIR
$creationTime = $featureDirInfo.CreationTime
$durationDays = [math]::Floor(([DateTime]::Now - $creationTime).TotalDays)

$manifestData = @{
    feature_name      = $FEATURE_NAME
    archived_at       = $createdAt
    feature_directory = $FEATURE_DIR
    duration_days     = $durationDays
    artifacts         = @()
}

# Add artifacts list
foreach ($file in $artifacts) {
    $archivePath = Join-Path $ARCHIVE_DIR $file
    if (Test-Path $archivePath -PathType Leaf) {
        $manifestData.artifacts += $file
    }
}

# Write manifest JSON
$manifestPath = Join-Path $ARCHIVE_DIR "manifest.json"
$manifestData | ConvertTo-Json | Set-Content -Path $manifestPath

# Store archival metadata
$archivedMetadata = @(
    "Archived: $(Get-Date)"
    "Feature: $FEATURE_NAME"
    "Archive ID: ${TIMESTAMP}-${FEATURE_NAME}"
) -join "`n"

Set-Content -Path (Join-Path $ARCHIVE_DIR "ARCHIVED") -Value $archivedMetadata

Write-Output ""
Write-Output "✅ Feature archived successfully"
Write-Output "Archive location: $ARCHIVE_DIR"

exit 0
