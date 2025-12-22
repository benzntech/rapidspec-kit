#!/usr/bin/env pwsh

# Parse command line arguments
param(
    [switch]$json = $false,
    [switch]$help = $false
)

if ($help) {
    Write-Host "Usage: research-phase.ps1 [-json] [-help]"
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
$CURRENT_BRANCH = $paths.CURRENT_BRANCH
$HAS_GIT = $paths.HAS_GIT
$FEATURE_DIR = $paths.FEATURE_DIR
$FEATURE_SPEC = $paths.FEATURE_SPEC
$IMPL_PLAN = $paths.IMPL_PLAN
$RESEARCH = $paths.RESEARCH

# Ensure the feature directory exists
if (-not (Test-Path -PathType Container $FEATURE_DIR)) {
    New-Item -ItemType Directory -Force -Path $FEATURE_DIR | Out-Null
}

# Create or update research.md template
$template = Join-Path -Path $REPO_ROOT -ChildPath "templates\research-template.md"

if (-not (Test-Path -Path $RESEARCH)) {
    if (Test-Path -Path $template) {
        Copy-Item -Path $template -Destination $RESEARCH
        Write-Host "Created research.md from template"
    } else {
        # Create a basic research.md if template doesn't exist
        $basicTemplate = @"
# Research: [Feature Name]

## Best Practices
### Industry Standards
- [Standard]: [Description and source]

### Recommended Approaches
1. [Approach]: [Description and rationale]

## Framework Documentation
### [Technology Name]
- Documentation: [URL]
- Patterns: [Description]

## Reference Implementations
### [Project Name]
- Approach: [Description]
- Pros: [Benefits]
- Cons: [Drawbacks]

## Security & Performance
### Security
- [Consideration 1]
- [Consideration 2]

### Performance
- [Benchmark 1]
- [Benchmark 2]

## Trade-offs & Comparison
| Aspect | Option A | Option B | Option C |
|--------|----------|----------|----------|

## Sources & References
- [Title](URL)
"@
        Set-Content -Path $RESEARCH -Value $basicTemplate
        Write-Host "Created basic research.md"
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
        RESEARCH = $RESEARCH
        FEATURE_SPEC = $FEATURE_SPEC
    }
    Write-Host ($result | ConvertTo-Json -Compress)
} else {
    Write-Host "FEATURE_DIR: $FEATURE_DIR"
    Write-Host "FEATURE_NAME: $featureName"
    Write-Host "RESEARCH: $RESEARCH"
    Write-Host "FEATURE_SPEC: $FEATURE_SPEC"
}
