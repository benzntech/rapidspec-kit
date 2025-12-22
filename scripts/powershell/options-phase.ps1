#!/usr/bin/env pwsh

# Parse command line arguments
param(
    [switch]$json = $false,
    [switch]$help = $false
)

if ($help) {
    Write-Host "Usage: options-phase.ps1 [-json] [-help]"
    Write-Host "  -json    Output results in JSON format"
    Write-Host "  -help    Show this help message"
    exit 0
}

# Get script directory and load common functions
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptDir\common.ps1"

# Get all paths and variables from common functions
$paths = Get-FeaturePaths

$REPO_ROOT = $paths.REPO_ROOT
$FEATURE_DIR = $paths.FEATURE_DIR
$FEATURE_SPEC = $paths.FEATURE_SPEC
$IMPL_PLAN = $paths.IMPL_PLAN

# Ensure the feature directory exists
if (-not (Test-Path -PathType Container $FEATURE_DIR)) {
    New-Item -ItemType Directory -Force -Path $FEATURE_DIR | Out-Null
}

# Create options.md if it doesn't exist
$OPTIONS_FILE = Join-Path -Path $FEATURE_DIR -ChildPath "options.md"

if (-not (Test-Path -Path $OPTIONS_FILE)) {
    $optionsTemplate = @"
# Implementation Options

## Overview
Document 2-3 implementation approaches for this feature based on research findings.

## Option 1: [Name]

**Description**: [1-2 sentences explaining what this approach is]

**Architecture**: [How it works at a high level]

**Pros** (Why choose this):
- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

**Cons** (Trade-offs):
- [Drawback 1]
- [Drawback 2]

**Cost Estimate**:
- **Time**: [X weeks/days]
- **Risk Level**: Low / Medium / High
- **Complexity**: Low / Medium / High

**Evidence from research**:
- [Reference implementation]: [What they found from research.md]
- [Industry standard]: [What the research showed]

**When to use**: [What conditions favor this approach]

---

## Option 2: [Name]

[Same structure as Option 1]

---

## Option 3: [Name]

[Same structure as Option 1]

---

## Comparison Table

| Aspect | Option 1 | Option 2 | Option 3 |
|--------|----------|----------|----------|
| Implementation Time | X weeks | Y weeks | Z weeks |
| Risk Level | Low/Med/High | Low/Med/High | Low/Med/High |
| Complexity | Low/Med/High | Low/Med/High | Low/Med/High |
| Scalability | [Rating] | [Rating] | [Rating] |
| Maintenance | [Rating] | [Rating] | [Rating] |
| Learning Curve | [Rating] | [Rating] | [Rating] |

---

## Decision: Selected Option [N]

**Chosen at**: [Date/Time]
**Confidence**: [1-10]

**Reasoning**:
[User's explanation of why this option was chosen]

**Evidence Supporting This Choice**:
- [Finding from research.md]
- [Finding from research.md]
- [Decision factors]

**Key Risks to Watch**:
- [Risk 1 and mitigation]
- [Risk 2 and mitigation]

**Success Criteria**:
- [Criterion 1]
- [Criterion 2]
"@
    Set-Content -Path $OPTIONS_FILE -Value $optionsTemplate
    Write-Host "Created options.md template"
}

# Append options template section to plan.md if it doesn't already exist
if (Test-Path -Path $IMPL_PLAN) {
    $planContent = Get-Content -Path $IMPL_PLAN -Raw
    if ($planContent -notmatch "## Phase 1\.5: Implementation Options") {
        $optionsSection = @"

## Phase 1.5: Implementation Options

Based on research findings, evaluate these implementation approaches:

### Option 1: [Name]

**Description**: [Brief description]

**Architecture**: [How it works]

**Pros**:
- [Benefit 1]
- [Benefit 2]

**Cons**:
- [Drawback 1]

**Cost**: [Time estimate] | [Risk] | [Complexity]

---

### Option 2: [Name]

[Same structure as Option 1]

---

### Option 3: [Name]

[Same structure as Option 1]

---

### Trade-offs Comparison

| Aspect | Option 1 | Option 2 | Option 3 |
|--------|----------|----------|----------|
| Time | | | |
| Risk | | | |
| Complexity | | | |

### Decision Factors
- [Factor 1]
- [Factor 2]
- [Factor 3]

---

## Selected Approach

**Option Chosen**: Option [N]
**Decision Date**: [Date]
**Confidence**: [1-10]

**Why This Option**:
- [Reason 1]
- [Reason 2]

**Key Risks to Watch**:
- [Risk 1 and mitigation]

**Success Criteria**:
- [Criterion 1]
- [Criterion 2]
"@
        Add-Content -Path $IMPL_PLAN -Value $optionsSection
        Write-Host "Added options template to plan.md"
    }
}

# Extract feature name from the feature directory
$featureName = Split-Path -Leaf $FEATURE_DIR
$featureName = $featureName -replace '^[0-9]{3}-', ''

# Output results
if ($json) {
    $result = @{
        FEATURE_DIR = $FEATURE_DIR
        FEATURE_NAME = $featureName
        OPTIONS_FILE = $OPTIONS_FILE
        FEATURE_SPEC = $FEATURE_SPEC
    }
    Write-Host ($result | ConvertTo-Json -Compress)
} else {
    Write-Host "FEATURE_DIR: $FEATURE_DIR"
    Write-Host "FEATURE_NAME: $featureName"
    Write-Host "OPTIONS_FILE: $OPTIONS_FILE"
    Write-Host "FEATURE_SPEC: $FEATURE_SPEC"
}
