---
name: RapidSpec: Finalize
description: Finalize the workflow by archiving the change
category: RapidSpec
tags: [rapidspec, finalize, archive]
allowed-tools: Read, Write, Edit, Bash, Task
argument-hint: <change-id>

---

<!-- SPECKIT.SPEC:START -->
# Finalize Workflow

<command_purpose>
Finalize the current workflow by validating completion and archiving the change.
This is an alias for the archive process.
</command_purpose>

<change_id> #$ARGUMENTS </change_id>

<critical_requirement>
MUST verify all tasks completed before finalizing.
MUST validate canonical specs after delta merge.
</critical_requirement>

## Execution

<thinking>
The user wants to finalize the workflow. This typically means archiving the current feature/change.
We will execute the archive process.
</thinking>

**Run Archive Command:**

- Execute the `archive` command/capability.

- Refer to `templates/commands/archive.md` for details if needed.

**Action:**

1.  Check for `/rapidspec.archive` command availability.

2.  If available, execute `/rapidspec.archive <change-id>`.

3.  If not, perform manual archive steps:

    - Verify tasks complete.

    - Move to archive directory.

    - Merge spec deltas.

    - Validate.

## Examples

```
User: "/rapidspec.finalize"

AI: "Finalizing workflow..."
AI executes: /rapidspec.archive
```
<!-- SPECKIT.SPEC:END -->
