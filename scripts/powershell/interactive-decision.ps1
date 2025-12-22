#!/usr/bin/env pwsh

# Spec-Kit Interactive Decision Script
# Purpose: Display options and capture decision with reasoning
# Usage: .\interactive-decision.ps1 -FeatureDir <path>

param(
    [Parameter(Mandatory=$true)]
    [string]$FeatureDir
)

$ErrorActionPreference = "Stop"

$PLAN_FILE = Join-Path $FeatureDir "plan.md"
$OPTIONS_FILE = Join-Path $FeatureDir "options.md"

# Validate that files exist
if (-not (Test-Path $FeatureDir -PathType Container)) {
    Write-Error "Feature directory not found: $FeatureDir"
    exit 1
}

if (-not (Test-Path $PLAN_FILE -PathType Leaf)) {
    Write-Error "plan.md not found in $FeatureDir"
    exit 1
}

if (-not (Test-Path $OPTIONS_FILE -PathType Leaf)) {
    Write-Error "options.md not found in $FeatureDir"
    exit 1
}

function Display-Options {
    Write-Output ""
    Write-Output "╔════════════════════════════════════════════════════════════════════════════╗"
    Write-Output "║           🎯 Implementation Options Decision Workflow                       ║"
    Write-Output "╚════════════════════════════════════════════════════════════════════════════╝"
    Write-Output ""

    $planContent = Get-Content $PLAN_FILE -Raw

    # Extract Option 1
    if ($planContent -match "### Option 1:") {
        Write-Output "OPTION 1:"
        $optionMatch = $planContent -match "### Option 1:(.*?)(?=###|$)"
        if ($optionMatch) {
            $optionText = $matches[1] -split "`n" | Select-Object -First 15
            Write-Output ($optionText -join "`n")
        }
        Write-Output ""
    }

    # Extract Option 2
    if ($planContent -match "### Option 2:") {
        Write-Output "OPTION 2:"
        $optionMatch = $planContent -match "### Option 2:(.*?)(?=###|$)"
        if ($optionMatch) {
            $optionText = $matches[1] -split "`n" | Select-Object -First 15
            Write-Output ($optionText -join "`n")
        }
        Write-Output ""
    }

    # Extract Option 3
    if ($planContent -match "### Option 3:") {
        Write-Output "OPTION 3:"
        $optionMatch = $planContent -match "### Option 3:(.*?)(?=###|$)"
        if ($optionMatch) {
            $optionText = $matches[1] -split "`n" | Select-Object -First 15
            Write-Output ($optionText -join "`n")
        }
        Write-Output ""
    }
}

function Main {
    Display-Options

    Write-Output ""
    Write-Output "═══════════════════════════════════════════════════════════════════════════════"
    Write-Output ""

    # Get user choice
    $choice = $null
    while ($choice -eq $null) {
        Write-Output "📋 Choose your implementation approach:"
        Write-Output "  [1] Option 1"
        Write-Output "  [2] Option 2"
        Write-Output "  [3] Option 3"
        Write-Output "  [q] Quit without saving"
        Write-Output ""
        $choice = Read-Host "Your choice (1-3 or q)"

        switch ($choice) {
            {$_ -in @("1", "2", "3")} {
                $SELECTED_OPTION = [int]$_
                break
            }
            {$_ -in @("q", "Q")} {
                Write-Output "Exiting without saving decision."
                exit 0
            }
            default {
                Write-Output "Invalid choice. Please enter 1, 2, 3, or q."
                $choice = $null
            }
        }
    }

    Write-Output ""
    Write-Output "✅ Selected: Option $SELECTED_OPTION"
    Write-Output ""

    # Get reasoning
    $reasoning = Read-Host "Why Option $SELECTED_OPTION`? (explain the decision rationale)"

    # Get confidence level
    $confidence = $null
    while ($confidence -eq $null) {
        $input = Read-Host "Confidence level (1-10)"
        if ($input -match '^[1-9]$|^10$') {
            $confidence = [int]$input
        } else {
            Write-Output "Please enter a number between 1 and 10."
        }
    }

    Write-Output ""
    Write-Output "💾 Saving decision..."

    # Update options.md with decision
    Update-OptionsFile -OptionNum $SELECTED_OPTION -Reasoning $reasoning -Confidence $confidence

    # Update plan.md with selected approach
    Update-PlanFile -OptionNum $SELECTED_OPTION -Confidence $confidence

    Write-Output "✅ Decision recorded in options.md and plan.md"
    Write-Output ""
    Write-Output "📊 Decision Summary:"
    Write-Output "  Option: $SELECTED_OPTION"
    Write-Output "  Reasoning: $reasoning"
    Write-Output "  Confidence: $confidence/10"
    Write-Output ""
}

function Update-OptionsFile {
    param(
        [int]$OptionNum,
        [string]$Reasoning,
        [int]$Confidence
    )

    $optionsContent = Get-Content $OPTIONS_FILE -Raw

    if ($optionsContent -match "## Decision:") {
        # Replace existing decision section
        $newContent = $optionsContent -replace "## Decision:.*$", @"
## Decision: Selected Option $OptionNum

**Chosen at**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**Confidence**: $Confidence/10

**Reasoning**:
$Reasoning

**Evidence Supporting This Choice**:
- [Add findings from research.md that support this choice]
- [Add relevant trade-offs considered]

**Key Risks to Watch**:
- [Identified risks and mitigation strategies]

**Success Criteria**:
- [Criteria for successful implementation]
"@
        Set-Content -Path $OPTIONS_FILE -Value $newContent
    } else {
        # Append decision section
        $decisionSection = @"

---

## Decision: Selected Option $OptionNum

**Chosen at**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**Confidence**: $Confidence/10

**Reasoning**:
$Reasoning

**Evidence Supporting This Choice**:
- [Add findings from research.md that support this choice]
- [Add relevant trade-offs considered]

**Key Risks to Watch**:
- [Identified risks and mitigation strategies]

**Success Criteria**:
- [Criteria for successful implementation]
"@
        Add-Content -Path $OPTIONS_FILE -Value $decisionSection
    }
}

function Update-PlanFile {
    param(
        [int]$OptionNum,
        [int]$Confidence
    )

    $planContent = Get-Content $PLAN_FILE -Raw

    if ($planContent -match "## Selected Approach") {
        # Update existing section
        $newContent = $planContent -replace "## Selected Approach.*?(?=^##|$)", @"
## Selected Approach

**Option Chosen**: Option $OptionNum
**Decision Date**: $(Get-Date -Format 'yyyy-MM-dd')
**Confidence**: $Confidence/10

**Why This Option**:
- [Update with reasoning specific to selected option]
- [Add benefits relative to other options]
- [Add any constraints that made this optimal]

**Key Risks to Watch**:
- [Risk 1 and mitigation strategy]
- [Risk 2 and mitigation strategy]

**Success Criteria**:
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

**Next Steps**:
1. Review this decision with team (if applicable)
2. Create detailed implementation plan
3. Begin implementation phase

"@, [System.Text.RegularExpressions.RegexOptions]::Multiline
        Set-Content -Path $PLAN_FILE -Value $newContent
    } else {
        # Append Selected Approach section
        $approachSection = @"

---

## Selected Approach

**Option Chosen**: Option $OptionNum
**Decision Date**: $(Get-Date -Format 'yyyy-MM-dd')
**Confidence**: $Confidence/10

**Why This Option**:
- [Update with reasoning specific to selected option]
- [Add benefits relative to other options]
- [Add any constraints that made this optimal]

**Key Risks to Watch**:
- [Risk 1 and mitigation strategy]
- [Risk 2 and mitigation strategy]

**Success Criteria**:
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

**Next Steps**:
1. Review this decision with team (if applicable)
2. Create detailed implementation plan
3. Begin implementation phase
"@
        Add-Content -Path $PLAN_FILE -Value $approachSection
    }
}

# Run the main workflow
Main
