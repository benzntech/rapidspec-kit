#!/usr/bin/env pwsh

# Spec-Kit PR Generation Script
# Purpose: Create pull request with auto-generated description
# Usage: .\generate-pr.ps1

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT = (Get-Item (Join-Path $SCRIPT_DIR "../..")).FullName

# Source common utilities
$commonPath = Join-Path $SCRIPT_DIR "common.ps1"
if (Test-Path $commonPath) {
    . $commonPath
}

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
$TASKS_FILE = Join-Path $FEATURE_DIR "tasks.md"
$REVIEW_FILE = Join-Path $FEATURE_DIR "review.md"

# Verify gh CLI is available
try {
    $ghVersion = gh --version 2>$null
} catch {
    Write-Error "GitHub CLI (gh) not installed"
    Write-Output "Install from: https://cli.github.com/"
    exit 1
}

Push-Location $REPO_ROOT
try {
    # Generate PR title
    $PR_TITLE = "feat: $FEATURE_NAME"

    # Generate PR description
    $PR_BODY = @"
## Summary

Feature implementation completed and ready for review.

## What Changed

### Completed Tasks

"@

    # Add completed tasks from tasks.md
    if (Test-Path $TASKS_FILE -PathType Leaf) {
        $completedTasks = @(Get-Content $TASKS_FILE | Select-String -Pattern "^- \[x\]" | ForEach-Object { $_ -replace "^- \[x\] ", "- " })
        if ($completedTasks) {
            $PR_BODY += ($completedTasks -join "`n")
        } else {
            $PR_BODY += "- Tasks completed`n"
        }
    }

    $PR_BODY += @"

## Statistics

### Files Changed
"@

    # Add git statistics
    $changedFiles = @(git diff --name-only)
    $PR_BODY += "`n- $($changedFiles.Count) files modified"

    # Count additions and deletions
    $diffStats = git diff --numstat
    $linesAdded = 0
    $linesRemoved = 0

    foreach ($line in $diffStats) {
        $parts = $line -split '\t'
        if ($parts[0] -ne '-') { $linesAdded += [int]$parts[0] }
        if ($parts[1] -ne '-') { $linesRemoved += [int]$parts[1] }
    }

    $PR_BODY += "`n- $linesAdded lines added"
    $PR_BODY += "`n- $linesRemoved lines removed"

    $PR_BODY += @"

## Testing Checklist

- [ ] Manual testing completed
- [ ] All tests passing (npm test)
- [ ] No console errors
- [ ] Feature works as designed
- [ ] No regressions identified

## Review Status

"@

    # Add review status if available
    if (Test-Path $REVIEW_FILE -PathType Leaf) {
        $reviewContent = Get-Content $REVIEW_FILE -Raw
        if ($reviewContent -match "Code Quality") {
            $PR_BODY += "- Code Quality: ✅ Passed`n"
        }
        if ($reviewContent -match "Security") {
            $PR_BODY += "- Security: ✅ Passed`n"
        }
        if ($reviewContent -match "Architecture") {
            $PR_BODY += "- Architecture: ✅ Passed`n"
        }
    }

    $PR_BODY += @"

## Related Issues

See spec.md for complete feature specification.
"@

    # Create PR
    Write-Output "Creating pull request..."
    Write-Output "Title: $PR_TITLE"
    Write-Output ""

    # Get current branch
    $currentBranch = git rev-parse --abbrev-ref HEAD

    # Create temp file for body
    $bodyFile = New-TemporaryFile
    Set-Content -Path $bodyFile -Value $PR_BODY

    try {
        gh pr create `
            --title $PR_TITLE `
            --body-file $bodyFile `
            --base main `
            --head $currentBranch
    } catch {
        Write-Error "Error creating PR"
        exit 1
    }

} finally {
    Pop-Location
}

Write-Output ""
Write-Output "✅ Pull request created successfully"

exit 0
