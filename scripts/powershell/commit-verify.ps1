#!/usr/bin/env pwsh

# Spec-Kit Commit Verification Script
# Purpose: Verify git changes and task completions before committing
# Usage: .\commit-verify.ps1 -Json

param([switch]$Json)

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
$TASKS_FILE = Join-Path $FEATURE_DIR "tasks.md"
$REVIEW_FILE = Join-Path $FEATURE_DIR "review.md"

# Verify required files exist
if (-not (Test-Path $TASKS_FILE -PathType Leaf)) {
    Write-Error "tasks.md not found"
    exit 1
}

# Check git status
Push-Location $REPO_ROOT
try {
    # Count git changes
    $CHANGED_FILES = @(git diff --name-only 2>$null)
    $STAGED_FILES = @(git diff --cached --name-only 2>$null)
} finally {
    Pop-Location
}

# Count completed tasks
$COMPLETED_TASKS = @(Get-Content $TASKS_FILE | Select-String -Pattern "^- \[x\]").Count
$PENDING_TASKS = @(Get-Content $TASKS_FILE | Select-String -Pattern "^- \[ \]").Count

# Check if review passed
$REVIEW_STATUS = "pending"
if (Test-Path $REVIEW_FILE -PathType Leaf) {
    $reviewContent = Get-Content $REVIEW_FILE -Raw
    if ($reviewContent -match "Ready to Merge: Yes") {
        $REVIEW_STATUS = "passed"
    } elseif ($reviewContent -match "Ready to Merge: No") {
        $REVIEW_STATUS = "failed"
    }
}

$readyToCommit = if (($REVIEW_STATUS -eq "passed") -and ($COMPLETED_TASKS -gt 0)) { $true } else { $false }

# Output based on format
if ($OUTPUT_FORMAT -eq "json") {
    $jsonOutput = @{
        feature_dir       = $FEATURE_DIR
        feature_name      = $FEATURE_NAME
        tasks_file        = $TASKS_FILE
        completed_tasks   = $COMPLETED_TASKS
        pending_tasks     = $PENDING_TASKS
        changed_files     = $CHANGED_FILES.Count
        staged_files      = $STAGED_FILES.Count
        review_status     = $REVIEW_STATUS
        ready_to_commit   = $readyToCommit
        timestamp         = (Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ')
    } | ConvertTo-Json
    Write-Output $jsonOutput
} else {
    Write-Output "Commit Verification Results"
    Write-Output "============================"
    Write-Output ""
    Write-Output "Feature: $FEATURE_NAME"
    Write-Output "Directory: $FEATURE_DIR"
    Write-Output ""
    Write-Output "Task Status:"
    Write-Output "  Completed: $($COMPLETED_TASKS.Count)"
    Write-Output "  Pending: $($PENDING_TASKS.Count)"
    Write-Output ""
    Write-Output "Git Status:"
    Write-Output "  Changed Files: $($CHANGED_FILES.Count)"
    Write-Output "  Staged Files: $($STAGED_FILES.Count)"
    Write-Output ""
    Write-Output "Review Status: $REVIEW_STATUS"
    Write-Output ""

    if ($readyToCommit) {
        Write-Output "✅ Ready to commit"
    } else {
        Write-Output "❌ Not ready to commit"
        if ($REVIEW_STATUS -ne "passed") {
            Write-Output "   - Review status: $REVIEW_STATUS"
        }
        if ($COMPLETED_TASKS.Count -eq 0) {
            Write-Output "   - No completed tasks"
        }
    }
}

exit 0
