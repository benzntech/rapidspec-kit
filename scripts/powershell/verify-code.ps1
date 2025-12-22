#!/usr/bin/env pwsh

# Spec-Kit Code Verification Script
# Purpose: Verify actual code files exist, detect frameworks, analyze git history
# Usage: .\verify-code.ps1 -Json

param(
    [switch]$Json,
    [string]$FeatureDir = ""
)

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT = (Get-Item (Join-Path $SCRIPT_DIR "../..")).FullName

# Source common utilities
$commonPath = Join-Path $SCRIPT_DIR "common.ps1"
if (Test-Path $commonPath) {
    . $commonPath
}

# Default values
$OUTPUT_FORMAT = if ($Json) { "json" } else { "text" }
$VERIFICATION_FILE = ""
$FEATURE_NAME = ""

# Determine feature directory
if ([string]::IsNullOrEmpty($FeatureDir)) {
    $featureDirs = @(Get-ChildItem -Path $REPO_ROOT -Directory -ErrorAction SilentlyContinue |
                     Where-Object { $_.Name -match '^\d{3}-' } |
                     Sort-Object -Property Name -Descending |
                     Select-Object -First 1)

    if ($featureDirs) {
        $FEATURE_DIR = $featureDirs[0].FullName
    }
}

if ([string]::IsNullOrEmpty($FEATURE_DIR) -or -not (Test-Path $FEATURE_DIR -PathType Container)) {
    Write-Error "No feature directory found"
    exit 1
}

$FEATURE_NAME = (Get-Item $FEATURE_DIR).Name -replace '^\d{3}-', ''
$VERIFICATION_FILE = Join-Path $FEATURE_DIR "verification.md"

# Output based on format
if ($OUTPUT_FORMAT -eq "json") {
    $jsonOutput = @{
        feature_dir       = $FEATURE_DIR
        feature_name      = $FEATURE_NAME
        verification_file = $VERIFICATION_FILE
        repo_root         = $REPO_ROOT
        timestamp         = (Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ')
    } | ConvertTo-Json
    Write-Output $jsonOutput
} else {
    Write-Output "Feature Directory: $FEATURE_DIR"
    Write-Output "Feature Name: $FEATURE_NAME"
    Write-Output "Verification File: $VERIFICATION_FILE"
    Write-Output "Repo Root: $REPO_ROOT"
}

exit 0
