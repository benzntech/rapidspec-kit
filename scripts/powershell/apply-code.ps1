#!/usr/bin/env pwsh

# Spec-Kit Code Application Script
# Purpose: Initialize code application phase with checkpoint tracking
# Usage: .\apply-code.ps1 -Json

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
$FEATURE_NAME = ""
$PLAN_FILE = ""
$TASKS_FILE = ""

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
$PLAN_FILE = Join-Path $FEATURE_DIR "plan.md"
$TASKS_FILE = Join-Path $FEATURE_DIR "tasks.md"

# Verify required files exist
if (-not (Test-Path $PLAN_FILE -PathType Leaf)) {
    Write-Error "plan.md not found at $PLAN_FILE"
    exit 1
}

if (-not (Test-Path $TASKS_FILE -PathType Leaf)) {
    Write-Error "tasks.md not found at $TASKS_FILE"
    exit 1
}

# Count pending tasks
$PENDING_TASKS = @(Get-Content $TASKS_FILE | Select-String -Pattern "^- \[ \]").Count
$COMPLETED_TASKS = @(Get-Content $TASKS_FILE | Select-String -Pattern "^- \[x\]").Count
$TOTAL_TASKS = $PENDING_TASKS + $COMPLETED_TASKS

# Calculate progress
$PROGRESS = if ($TOTAL_TASKS -gt 0) { [math]::Round(($COMPLETED_TASKS / $TOTAL_TASKS) * 100, 1) } else { 0 }

# Output based on format
if ($OUTPUT_FORMAT -eq "json") {
    $jsonOutput = @{
        feature_dir     = $FEATURE_DIR
        feature_name    = $FEATURE_NAME
        plan_file       = $PLAN_FILE
        tasks_file      = $TASKS_FILE
        repo_root       = $REPO_ROOT
        total_tasks     = $TOTAL_TASKS
        pending_tasks   = $PENDING_TASKS
        completed_tasks = $COMPLETED_TASKS
        progress        = $PROGRESS
        timestamp       = (Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ')
    } | ConvertTo-Json
    Write-Output $jsonOutput
} else {
    Write-Output "Feature Directory: $FEATURE_DIR"
    Write-Output "Feature Name: $FEATURE_NAME"
    Write-Output "Plan File: $PLAN_FILE"
    Write-Output "Tasks File: $TASKS_FILE"
    Write-Output "Repo Root: $REPO_ROOT"
    Write-Output ""
    Write-Output "Task Summary:"
    Write-Output "  Total Tasks: $TOTAL_TASKS"
    Write-Output "  Pending: $PENDING_TASKS"
    Write-Output "  Completed: $COMPLETED_TASKS"
    Write-Output "  Progress: $PROGRESS%"
}

exit 0
