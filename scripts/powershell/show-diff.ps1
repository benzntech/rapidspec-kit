#!/usr/bin/env pwsh

# Spec-Kit Diff Display Script
# Purpose: Show before/after diffs for code changes
# Usage: .\show-diff.ps1 -FilePath <path> -BeforeFile <file> -AfterFile <file> [-Format unified|side-by-side]

param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,

    [Parameter(Mandatory=$true)]
    [string]$BeforeFile,

    [Parameter(Mandatory=$true)]
    [string]$AfterFile,

    [string]$Format = "unified"
)

$ErrorActionPreference = "Stop"

# Show file information
Write-Output "════════════════════════════════════════════════════════"
Write-Output "File: $FilePath"
Write-Output "════════════════════════════════════════════════════════"
Write-Output ""

# Show before stats
if (Test-Path $BeforeFile -PathType Leaf) {
    $BEFORE_LINES = @(Get-Content $BeforeFile).Count
    Write-Output "Before: $BEFORE_LINES lines"
} else {
    Write-Output "Before: [NEW FILE]"
    $BEFORE_LINES = 0
}

# Show after stats
if (Test-Path $AfterFile -PathType Leaf) {
    $AFTER_LINES = @(Get-Content $AfterFile).Count
    Write-Output "After: $AFTER_LINES lines"
} else {
    Write-Output "After: [FILE DELETED]"
    $AFTER_LINES = 0
}

# Calculate difference
if ((Test-Path $BeforeFile -PathType Leaf) -and (Test-Path $AfterFile -PathType Leaf)) {
    $ADDED = $AFTER_LINES - $BEFORE_LINES
    if ($ADDED -gt 0) {
        Write-Output "Change: +$ADDED lines"
    } else {
        Write-Output "Change: $ADDED lines"
    }
}

Write-Output ""
Write-Output "════════════════════════════════════════════════════════"
Write-Output ""

# Show diff based on format
if ($Format -eq "side-by-side") {
    # PowerShell doesn't have native side-by-side diff, fall back to Compare-Object
    if ((Test-Path $BeforeFile -PathType Leaf) -and (Test-Path $AfterFile -PathType Leaf)) {
        $beforeContent = Get-Content $BeforeFile
        $afterContent = Get-Content $AfterFile
        Compare-Object -ReferenceObject $beforeContent -DifferenceObject $afterContent -IncludeEqual | Format-Table
    }
} else {
    # Unified diff (default) - use git diff if available, otherwise compare-object
    if ((Test-Path $BeforeFile -PathType Leaf) -and (Test-Path $AfterFile -PathType Leaf)) {
        try {
            git diff --no-index $BeforeFile $AfterFile 2>$null
        } catch {
            # Fallback to Compare-Object if git not available
            $beforeContent = Get-Content $BeforeFile
            $afterContent = Get-Content $AfterFile
            Compare-Object -ReferenceObject $beforeContent -DifferenceObject $afterContent
        }
    } elseif (-not (Test-Path $BeforeFile -PathType Leaf)) {
        Write-Output "[NEW FILE]"
        if (Test-Path $AfterFile -PathType Leaf) {
            Get-Content $AfterFile
        }
    } else {
        Write-Output "[FILE DELETED]"
    }
}

Write-Output ""
Write-Output "════════════════════════════════════════════════════════"

exit 0
