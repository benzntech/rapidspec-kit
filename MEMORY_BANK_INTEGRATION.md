# Memory Bank Integration Guide

This document describes how the memory bank system integrates with RapidSpec commands during development workflows.

## Overview

The memory bank system provides optional and automatic hooks to track project context, decisions, and progress across development sessions. Integration is designed to be:

- **Non-intrusive**: Memory updates don't block or interfere with command execution
- **Flexible**: Users control behavior with optional flags
- **Automatic where it matters**: Key transitions (commit, archive) always record work
- **Progressive**: Users can ignore memory bank initially, adopt gradually

## Integration Pattern

Two patterns are used:

### 1. Optional Integration (Default: Prompt)
Commands: `proposal`, `apply`, `review`, `triage`, `resolve-parallel`

**User controls with flags:**
- `--update-memory` / `--log-findings` / `--log-triage` / `--track-waves`: Always update
- `--skip-memory`: Never update
- No flag (default): Prompt user "Update memory bank? (yes/no/auto)"

**Behavior:**
- Memory update happens after command completes
- Doesn't block or affect command workflow
- User can choose per-command or set `--auto` for persistent preference

### 2. Automatic Integration (No Flags)
Commands: `commit`, `archive`, `finalize`

**Behavior:**
- Automatically called after command succeeds
- Non-blocking (doesn't fail if memory bank unavailable)
- Always records critical work transitions

## Command Integration Details

### Proposal Command
**Purpose**: Create feature proposal with research and options analysis
**Integration**: Optional (default: prompt)
**Timing**: After proposal creation, when user confirms

**What gets logged:**
```
/rapidspec.umb Auto-logged proposal: $CHANGE_ID
- Description: [Feature description]
- Decision: Selected option [#]
- Options considered: [Alternatives analyzed]
- Key context: [Investigation findings]
```

**Files updated:**
- `decisionLog.md`: New decision entry with research findings
- `activeContext.md`: New in-progress work item
- `progress.md`: New planned work

**Examples:**
```bash
# Prompt user to update memory bank
/rapidspec.proposal feature-auth "Add OAuth2 authentication"

# Always update memory bank
/rapidspec.proposal feature-auth --update-memory "Add OAuth2 authentication"

# Never update memory bank
/rapidspec.proposal feature-auth --skip-memory "Add OAuth2 authentication"
```

---

### Apply Command
**Purpose**: Implement feature tasks step-by-step with checkpoints
**Integration**: Optional during implementation
**Timing**: At checkpoint intervals (every 5 checkpoints)

**What gets logged:**
```
/rapidspec.umb Progress on $CHANGE_ID: Checkpoints 1-5/20 complete
- Completed tasks: [List of 5 task names]
- Current focus: [Next task]
- Blockers: [Any impediments]
- Tests passing: [Status]
```

**Files updated:**
- `progress.md`: In-progress work status update
- `activeContext.md`: Current focus and blockers
- Helps resume work after pauses

**Behavior:**
- Default: No automatic updates during apply (better performance)
- Users enable with `--track-progress` or `--full-track`
- Useful for long implementations

**Examples:**
```bash
# No memory updates during apply
/rapidspec.apply feature-auth

# Update every 5 checkpoints
/rapidspec.apply feature-auth --track-progress

# Update at every checkpoint
/rapidspec.apply feature-auth --full-track
```

---

### Review Command
**Purpose**: Automated quality review with specialized agents
**Integration**: Optional
**Timing**: After review completes, before user decides on fixes

**What gets logged:**
```
/rapidspec.umb Code review completed for $CHANGE_ID
- Review agents: [List of agents that ran]
- Critical findings: [Count and summary]
- Warnings: [Count and areas]
- Patterns: [New or violated patterns]
```

**Files updated:**
- `decisionLog.md`: Review findings and fixes applied
- `systemPatterns.md`: New patterns or violations identified
- `activeContext.md`: Remaining blockers from review

**Examples:**
```bash
# Prompt user about logging findings
/rapidspec.review feature-auth

# Always log findings
/rapidspec.review feature-auth --log-findings

# Never log findings
/rapidspec.review feature-auth --skip-memory
```

---

### Commit Command
**Purpose**: Create git commits with task verification
**Integration**: Automatic (always happens)
**Timing**: After commit succeeds

**What gets logged automatically:**
```
/rapidspec.umb Work committed: $CHANGE_ID
- Commit: $COMMIT_HASH
- Message: $COMMIT_MESSAGE
- Tasks completed: [Marked [x] tasks]
- Discovered work: [Unplanned work captured]
```

**Files updated automatically:**
- `progress.md`: New committed work entry
- `decisionLog.md`: Implementation insights
- `activeContext.md`: Completed objectives cleared

**Why automatic:**
- All committed work must be recorded
- Maintains continuous audit trail
- Enables project history reconstruction
- Supports team knowledge retention

**Examples:**
```bash
# Commit (automatic memory update)
/rapidspec.commit "feat: add OAuth2 authentication provider"

# Memory bank updated automatically with commit details
```

---

### Archive Command
**Purpose**: Finalize feature and merge spec deltas
**Integration**: Automatic (always happens)
**Timing**: After archive succeeds

**What gets logged automatically:**
```
/rapidspec.umb Feature archived: $CHANGE_ID
- Archived to: changes/archive/$TIMESTAMP-$CHANGE_ID/
- Proposal: [Link to proposal.md]
- Tasks: [All tasks completed]
- Commits: [All commit hashes]
- Specs merged: [Into canonical specs/]
```

**Files updated automatically:**
- `progress.md`: Move from "Current Work" to "Completed Work"
- `activeContext.md`: Clear completed objectives, set new focus
- Archive preserves implementation details for retrospectives

**Why automatic:**
- Archives represent feature completions
- Must be permanently recorded
- Moves context from active to archive
- Enables project history and lessons learned

**Examples:**
```bash
# Archive (automatic memory update)
/rapidspec.archive feature-auth

# Memory bank updated automatically
# Archive timestamp: 2025-12-23-feature-auth
```

---

### Finalize Command
**Purpose**: Alias for archive workflow
**Integration**: Automatic (same as archive)
**Timing**: After finalize succeeds

**What gets logged automatically:**
Same as archive command (see above).

---

### Triage Command
**Purpose**: Prioritize review findings for implementation
**Integration**: Optional
**Timing**: After triage completes

**What gets logged:**
```
/rapidspec.umb Triage completed: $CHANGE_ID
- Critical items: [Count and areas]
- Priority order: [Which items first]
- Deferred items: [Low priority with rationale]
- Timeline: [When fixes needed]
```

**Files updated:**
- `activeContext.md`: Prioritized blockers and next steps
- `decisionLog.md`: Triage priority decisions
- `progress.md`: Issue tracking status

**Examples:**
```bash
# Prompt user to log triage decisions
/rapidspec.triage feature-auth

# Always log triage decisions
/rapidspec.triage feature-auth --log-triage

# Never log triage decisions
/rapidspec.triage feature-auth --skip-memory
```

---

### Resolve-Parallel Command
**Purpose**: Resolve multiple tasks in parallel waves
**Integration**: Optional
**Timing**: After completing all waves

**What gets logged:**
```
/rapidspec.umb Parallel resolution: $CHANGE_ID
- Waves: [Number completed]
- Tasks resolved: [Total count]
- Dependencies resolved: [Count]
- Time saved: [vs sequential estimate]
```

**Files updated:**
- `progress.md`: Completion summary
- `activeContext.md`: Next steps
- Documents efficiency gains

**Examples:**
```bash
# Prompt user about logging wave progress
/rapidspec.resolve-parallel feature-auth

# Always log wave progress
/rapidspec.resolve-parallel feature-auth --track-waves

# Never log
/rapidspec.resolve-parallel feature-auth --skip-memory
```

---

## User Preferences

Users can set persistent preferences to avoid repeated prompts:

### One-time Command Override
```bash
# Use specific flag for single command
/rapidspec.proposal feature-auth --update-memory "Add OAuth2"
```

### Set Default Behavior
```bash
# Set auto-update as default (no more prompts)
/rapidspec.proposal feature-auth --auto "Add OAuth2"

# This sets preference: all future proposal commands auto-update
# User can override with --skip-memory when needed
```

### Reset to Prompts
```bash
# Go back to prompting
/rapidspec.proposal feature-auth --prompt "Add OAuth2"
```

## Workflow Examples

### Typical Feature Development With Memory Bank

```bash
# 1. Create proposal (with memory bank update)
/rapidspec.proposal feature-auth --update-memory "OAuth2 support"
→ Memory bank: Decision logged, in-progress work added

# 2. Implement with checkpoints (optional progress tracking)
/rapidspec.apply feature-auth --track-progress
→ Memory bank: Updated every 5 checkpoints with progress

# 3. Review code
/rapidspec.review feature-auth --log-findings
→ Memory bank: Findings logged

# 4. Triage and fix findings
/rapidspec.triage feature-auth --log-triage
/rapidspec.apply feature-auth --track-progress
→ Memory bank: Priority decisions logged

# 5. Commit work (automatic update)
/rapidspec.commit "feat: add OAuth2 authentication"
→ Memory bank: Auto-logged commit

# 6. Archive feature (automatic update)
/rapidspec.archive feature-auth
→ Memory bank: Auto-logged completion, moved to archive

# At any point: Check memory bank status
cat .rapidspec/memory/progress.md
```

### Memory Bank Status Tracking

Throughout workflow, memory bank shows:

**activeContext.md**: Current focus, blockers, next steps
- Started: "Implementing OAuth2 feature"
- Mid-implementation: "Checkpoint 10/20, testing auth flow"
- After triage: "5 critical findings prioritized for fixing"
- After archive: "OAuth2 archived, ready for next feature"

**progress.md**: Work status
- Added: "OAuth2 feature in progress"
- Updated: "Checkpoints 1-5 complete"
- Completed: "OAuth2 feature archived"

**decisionLog.md**: Why decisions were made
- Proposal: "Chose JWT + refresh tokens over session-based (see rationale)"
- Review: "Fixed 3 critical findings before archive"
- Archive: "Feature shipped in v2.1"

## Best Practices

### When to Enable Memory Bank Integration

✅ **Enable for:**
- Multi-person teams (knowledge sharing)
- Long-running features (context resumption)
- Complex decisions (rationale documentation)
- Knowledge retention (onboarding new team members)

❌ **Skip for:**
- Quick bug fixes (low complexity)
- Solo projects with good git history
- One-off tasks (limited reuse)
- Performance-critical workflows (memory updates overhead)

### Recommended Settings

**For teams:** Use `--auto` (always update memory)
```bash
/rapidspec.proposal --auto "Feature description"
# Sets: All future proposals auto-update memory bank
```

**For individuals:** Use `--prompt` (ask each time)
```bash
/rapidspec.proposal --prompt "Feature description"
# Default behavior, decide per feature
```

**For bulk fixes:** Disable memory during apply
```bash
/rapidspec.apply change-id --skip-memory --track-progress
# Don't spam memory bank with minor fixes
```

## Memory Bank Without Integration

The memory bank can be used standalone without command integration:

```bash
# Initialize memory bank
/rapidspec.constitution

# Work normally without memory bank flags
/rapidspec.proposal ...
/rapidspec.apply ...
/rapidspec.commit ...

# Manually update memory bank when desired
/rapidspec.umb "Completed OAuth2 feature, key findings from review"
```

This approach:
- Keeps memory updates explicit and intentional
- Avoids automatic logging overhead
- Requires more discipline from users
- Still provides full memory bank benefits

## Troubleshooting

### Memory Bank Updates Failing

If `/rapidspec.umb` fails during command execution:
1. Command succeeds (failure is non-blocking)
2. User is notified: "Warning: Memory bank update failed"
3. Recommend manual update: `/rapidspec.umb [details]`
4. Check `.rapidspec/memory/` exists

### Preferences Not Sticking

Preferences are per-session and per-command:
- Set `--auto` again to enable
- Set `--prompt` to go back to asking
- Preferences not persistent across repositories

### Memory Bank Not Found

If `.rapidspec/memory/` doesn't exist:
1. Initialize with: `/rapidspec.constitution`
2. Commands skip memory updates silently
3. Create memory bank when ready

## Summary

Memory bank integration provides flexible, optional tracking of project context:

| Command | Integration | Default | Control |
|---------|-------------|---------|---------|
| proposal | Optional | Prompt | `--update-memory`, `--skip-memory` |
| apply | Optional | None | `--track-progress`, `--full-track` |
| review | Optional | Prompt | `--log-findings`, `--skip-memory` |
| commit | Automatic | Auto | Always logs |
| archive | Automatic | Auto | Always logs |
| finalize | Automatic | Auto | Always logs |
| triage | Optional | Prompt | `--log-triage`, `--skip-memory` |
| resolve-parallel | Optional | Prompt | `--track-waves`, `--skip-memory` |

Users control adoption level: from full automation (`--auto` on all) to manual (`/rapidspec.umb` only).
