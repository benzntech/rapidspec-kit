#!/usr/bin/env pwsh

# Spec-Kit Review Report Script
# Purpose: Synthesize review findings and generate report
# Usage: .\review-report.ps1

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
$REVIEW_FILE = Join-Path $FEATURE_DIR "review.md"

# Create review report
$reviewTemplate = @"
# Code Review Report

**Status**: Review in progress...
**Generated**: $(Get-Date)
**Feature**: $FEATURE_NAME

---

## Review Summary

| Metric | Count |
|--------|-------|
| Files Reviewed | TBD |
| Critical Issues | TBD |
| Warnings | TBD |
| Info/Suggestions | TBD |
| Ready to Merge | TBD |

---

## Agent Results

### Code Quality Review
[Results from code-reviewer agent]

### Security Audit
[Results from security-auditor agent]

### Architecture Review
[Results from architecture-strategist agent]

### Conditional Reviews

#### Component Review
[Results from component-reviewer agent if applicable]

#### API Review
[Results from api-reviewer agent if applicable]

#### Database Review
[Results from database-reviewer agent if applicable]

#### Test Review
[Results from test-reviewer agent if applicable]

---

## Findings by Severity

### Critical Issues ❌
[List critical issues that must be fixed]

### Warnings ⚠️
[List warnings that should be addressed]

### Info/Suggestions 💡
[List suggestions for improvement]

---

## Merge Decision

**Ready to Merge**: [Yes/No]

**Reasoning**:
- [ ] No critical issues
- [ ] Warnings addressed
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Security reviewed

**Next Steps**:
1. Address critical issues
2. Consider addressing warnings
3. Run full test suite
4. Proceed to commit/merge

---

## Review Checklist

- [ ] Code quality approved
- [ ] Security audit passed
- [ ] Architecture approved
- [ ] Tests written/updated
- [ ] Documentation updated
- [ ] No critical issues
- [ ] Ready for deployment

---

**Review completed**: $(Get-Date)
**Reviewer**: AI Multi-Agent Review System
"@

Set-Content -Path $REVIEW_FILE -Value $reviewTemplate

Write-Output "Review report created at: $REVIEW_FILE"
Write-Output ""
Write-Output "Next steps:"
Write-Output "1. Review findings from each agent"
Write-Output "2. Address critical issues"
Write-Output "3. Consider warnings"
Write-Output "4. Decide on merge readiness"

exit 0
