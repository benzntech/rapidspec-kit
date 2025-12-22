#!/usr/bin/env pwsh

# Spec-Kit Change Detection Script
# Purpose: Detect what changed to determine which agents should run
# Usage: .\detect-changes.ps1 -Json

param([switch]$Json)

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$REPO_ROOT = (Get-Item (Join-Path $SCRIPT_DIR "../..")).FullName

# Default values
$OUTPUT_FORMAT = if ($Json) { "json" } else { "text" }

# Get git changes
$CHANGED_FILES = try {
    git diff --name-only 2>$null
} catch {
    ""
}

# Initialize detection flags
$HAS_COMPONENT_CHANGES = 0
$HAS_API_CHANGES = 0
$HAS_DB_CHANGES = 0
$HAS_TEST_CHANGES = 0

# Detect component changes (React/Vue)
if (($CHANGED_FILES -match '\.(tsx?|jsx?)$') -and ($CHANGED_FILES -match '(components|views|pages)/')) {
    $HAS_COMPONENT_CHANGES = 1
}

# Detect API changes
if ($CHANGED_FILES -match '(api|routes|handlers|controllers)/.*\.(ts|js)$') {
    $HAS_API_CHANGES = 1
}

# Detect database changes
if (($CHANGED_FILES -match '\.(sql|ts|js)$') -and ($CHANGED_FILES -match '(migrations|schema|database)/')) {
    $HAS_DB_CHANGES = 1
}

# Detect test changes
if ($CHANGED_FILES -match '\.(test|spec)\.(ts|js|tsx)$') {
    $HAS_TEST_CHANGES = 1
}

# Count changed files
$TOTAL_CHANGES = @($CHANGED_FILES | Where-Object { $_ }).Count

# Build agents list
$agents = @("code-reviewer", "security-auditor", "architecture-strategist")
if ($HAS_COMPONENT_CHANGES -eq 1) { $agents += "component-reviewer" }
if ($HAS_API_CHANGES -eq 1) { $agents += "api-reviewer" }
if ($HAS_DB_CHANGES -eq 1) { $agents += "database-reviewer" }
if ($HAS_TEST_CHANGES -eq 1) { $agents += "test-reviewer" }

# Output based on format
if ($OUTPUT_FORMAT -eq "json") {
    $jsonOutput = @{
        total_changes      = $TOTAL_CHANGES
        component_changes  = $HAS_COMPONENT_CHANGES
        api_changes        = $HAS_API_CHANGES
        database_changes   = $HAS_DB_CHANGES
        test_changes       = $HAS_TEST_CHANGES
        agents_to_run      = $agents
        timestamp          = (Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ')
    } | ConvertTo-Json
    Write-Output $jsonOutput
} else {
    Write-Output "Change Detection Results"
    Write-Output "======================="
    Write-Output "Total Changes: $TOTAL_CHANGES"
    Write-Output ""
    Write-Output "Detected Changes:"
    Write-Output "  Component Changes: $(if ($HAS_COMPONENT_CHANGES -eq 1) { 'Yes' } else { 'No' })"
    Write-Output "  API Changes: $(if ($HAS_API_CHANGES -eq 1) { 'Yes' } else { 'No' })"
    Write-Output "  Database Changes: $(if ($HAS_DB_CHANGES -eq 1) { 'Yes' } else { 'No' })"
    Write-Output "  Test Changes: $(if ($HAS_TEST_CHANGES -eq 1) { 'Yes' } else { 'No' })"
    Write-Output ""
    Write-Output "Agents to Run:"
    Write-Output "  - code-reviewer (always)"
    Write-Output "  - security-auditor (always)"
    Write-Output "  - architecture-strategist (always)"
    if ($HAS_COMPONENT_CHANGES -eq 1) { Write-Output "  - component-reviewer" }
    if ($HAS_API_CHANGES -eq 1) { Write-Output "  - api-reviewer" }
    if ($HAS_DB_CHANGES -eq 1) { Write-Output "  - database-reviewer" }
    if ($HAS_TEST_CHANGES -eq 1) { Write-Output "  - test-reviewer" }
}

exit 0
