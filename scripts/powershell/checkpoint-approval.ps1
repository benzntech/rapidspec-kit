#!/usr/bin/env pwsh

# Spec-Kit Checkpoint Approval Script
# Purpose: Interactive approval prompts for code changes
# Usage: .\checkpoint-approval.ps1 -PromptType <type> [options]

param(
    [Parameter(Mandatory=$true)]
    [string]$PromptType,

    [string]$TaskName = "",
    [string]$FilePath = "",
    [string]$Message = "",
    [int]$Completed = 0,
    [int]$Total = 0
)

function Show-ApplyPrompt {
    param([string]$TaskName, [string]$FilePath)

    Write-Output ""
    Write-Output "$(($PSStyle.Foreground.Cyan))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output "Apply this change to $FilePath`?"
    Write-Output "$(($PSStyle.Foreground.Cyan))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output ""
    Write-Output "Task: $TaskName"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  [$(($PSStyle.Foreground.Green))yes$($PSStyle.Reset)]   ✅ Proceed - Apply the change"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))wait$($PSStyle.Reset)]  ⏸️  Pause - Let me review this more"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))skip$($PSStyle.Reset)]  ⏭️  Skip - Move to next task"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))edit$($PSStyle.Reset)]  ✏️  Edit - Modify the proposal"
    Write-Output "  [$(($PSStyle.Foreground.Cyan))help$($PSStyle.Reset)]  ❓ Help - Explain the change"
    Write-Output ""
    Write-Host -NoNewline "> "
}

function Show-ContinuePrompt {
    param([string]$TaskName)

    Write-Output ""
    Write-Output "$(($PSStyle.Foreground.Cyan))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Green))✅ Task Complete: $TaskName$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Cyan))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output ""
    Write-Output "Test this change`?"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  [$(($PSStyle.Foreground.Green))yes$($PSStyle.Reset)]     ✅ Continue to next task - Looks good!"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))wait$($PSStyle.Reset)]    ⏸️  Let me test this first (pause)"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))review$($PSStyle.Reset)]  ↩️  Show me the change again"
    Write-Output ""
    Write-Host -NoNewline "> "
}

function Show-ImprovementPrompt {
    param([string]$Improvement)

    Write-Output ""
    Write-Output "$(($PSStyle.Foreground.Cyan))─────────────────────────────────────────────────────$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Yellow))💡 Discovered: $Improvement$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Cyan))─────────────────────────────────────────────────────$($PSStyle.Reset)"
    Write-Output ""
    Write-Output "Should we add this improvement`?"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  [$(($PSStyle.Foreground.Green))yes$($PSStyle.Reset)]    Include in this task"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))later$($PSStyle.Reset)]  Add to tasks list"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))skip$($PSStyle.Reset)]   Skip this improvement"
    Write-Output ""
    Write-Host -NoNewline "> "
}

function Show-FinalPrompt {
    param([int]$TasksCompleted, [int]$TotalTasks)

    Write-Output ""
    Write-Output "$(($PSStyle.Foreground.Green))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Green))✅ Implementation Complete$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Green))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output ""
    Write-Output "Completed: $TasksCompleted of $TotalTasks tasks"
    Write-Output ""
    Write-Output "Ready to commit`?"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  [$(($PSStyle.Foreground.Green))yes$($PSStyle.Reset)]   Proceed to review and commit"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))wait$($PSStyle.Reset)]  Let me test these changes first"
    Write-Output ""
    Write-Host -NoNewline "> "
}

function Show-ErrorPrompt {
    param([string]$ErrorMessage)

    Write-Output ""
    Write-Output "$(($PSStyle.Foreground.Red))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Red))❌ Error$($PSStyle.Reset)"
    Write-Output "$(($PSStyle.Foreground.Red))═══════════════════════════════════════════════════════$($PSStyle.Reset)"
    Write-Output ""
    Write-Output "Error: $ErrorMessage"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))retry$($PSStyle.Reset)]  Try again"
    Write-Output "  [$(($PSStyle.Foreground.Yellow))skip$($PSStyle.Reset)]   Skip this task"
    Write-Output "  [$(($PSStyle.Foreground.Red))stop$($PSStyle.Reset)]   Stop application"
    Write-Output ""
    Write-Host -NoNewline "> "
}

function Show-Progress {
    param([int]$Completed, [int]$Total)

    $percent = if ($Total -gt 0) { [math]::Floor(($Completed * 100) / $Total) } else { 0 }
    $barLength = 40
    $filled = if ($Total -gt 0) { [math]::Floor(($barLength * $Completed) / $Total) } else { 0 }
    $empty = $barLength - $filled

    $bar = ("█" * $filled) + ("░" * $empty)

    Write-Output ""
    Write-Output "Progress: $bar $percent% ($Completed/$Total tasks)"
    Write-Output ""
}

# Handle prompt types
switch ($PromptType) {
    "apply" {
        Show-ApplyPrompt -TaskName $TaskName -FilePath $FilePath
    }
    "continue" {
        Show-ContinuePrompt -TaskName $TaskName
    }
    "improvement" {
        Show-ImprovementPrompt -Improvement $Message
    }
    "final" {
        Show-FinalPrompt -TasksCompleted $Completed -TotalTasks $Total
    }
    "error" {
        Show-ErrorPrompt -ErrorMessage $Message
    }
    "progress" {
        Show-Progress -Completed $Completed -Total $Total
    }
    default {
        Write-Error "Unknown prompt type: $PromptType"
        Write-Output "Valid types: apply, continue, improvement, final, error, progress"
        exit 1
    }
}
