#!/usr/bin/env pwsh

# Spec-Kit Archive Validation Script
# Purpose: Validate that feature is ready for archival
# Usage: .\validate-archive.ps1 [-Json]

param([switch]$Json)

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT = (Get-Item (Join-Path $SCRIPT_DIR "../..")).FullName

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

# Run validations
$VALIDATION_PASSED = 1

# Check tasks completion
$tasksContent = Get-Content $TASKS_FILE -Raw -ErrorAction SilentlyContinue
if ($tasksContent -match "^- \[ \]") {
    $VALIDATION_PASSED = 0
    $TASKS_STATUS = "incomplete"
} else {
    $TASKS_STATUS = "complete"
}

# Check review status
if ((Test-Path $REVIEW_FILE -PathType Leaf) -and (Get-Content $REVIEW_FILE -Raw | Select-String -Pattern "Ready to Merge: Yes" -Quiet)) {
    $REVIEW_STATUS = "passed"
} else {
    $VALIDATION_PASSED = 0
    $REVIEW_STATUS = "failed"
}

# Check git status
Push-Location $REPO_ROOT
try {
    $gitDiff = git diff-index --quiet HEAD -- 2>$null
    $GIT_STATUS = "clean"
} catch {
    $VALIDATION_PASSED = 0
    $GIT_STATUS = "dirty"
}

# Check if on main branch
$CURRENT_BRANCH = git rev-parse --abbrev-ref HEAD
if ($CURRENT_BRANCH -eq "main") {
    $BRANCH_STATUS = "main"
} else {
    $VALIDATION_PASSED = 0
    $BRANCH_STATUS = "not-main"
}

} finally {
    Pop-Location
}

# Output based on format
if ($OUTPUT_FORMAT -eq "json") {
    $jsonOutput = @{
        feature_name    = $FEATURE_NAME
        ready_to_archive = [bool]$VALIDATION_PASSED
        tasks_status     = $TASKS_STATUS
        review_status    = $REVIEW_STATUS
        git_status       = $GIT_STATUS
        branch_status    = $BRANCH_STATUS
        timestamp        = (Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ')
    } | ConvertTo-Json
    Write-Output $jsonOutput
} else {
    Write-Output "Archive Validation Results"
    Write-Output "=========================="
    Write-Output ""
    Write-Output "Feature: $FEATURE_NAME"
    Write-Output ""
    Write-Output "Validation Checks:"
    Write-Output "  Tasks Complete: $(if ($TASKS_STATUS -eq 'complete') { '✅ Yes' } else { '❌ No' })"
    Write-Output "  Review Passed: $(if ($REVIEW_STATUS -eq 'passed') { '✅ Yes' } else { '❌ No' })"
    Write-Output "  Git Clean: $(if ($GIT_STATUS -eq 'clean') { '✅ Yes' } else { '❌ No' })"
    Write-Output "  On Main: $(if ($BRANCH_STATUS -eq 'main') { '✅ Yes' } else { '❌ No' })"
    Write-Output ""

    if ($VALIDATION_PASSED -eq 1) {
        Write-Output "✅ Ready to archive"
    } else {
        Write-Output "❌ Not ready to archive"
        if ($TASKS_STATUS -ne "complete") { Write-Output "   - Complete all pending tasks" }
        if ($REVIEW_STATUS -ne "passed") { Write-Output "   - Ensure review passes" }
        if ($GIT_STATUS -ne "clean") { Write-Output "   - Commit all changes" }
        if ($BRANCH_STATUS -ne "main") { Write-Output "   - Merge to main branch" }
    }
}

exit 0
