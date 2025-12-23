---
name: RapidSpec UMB (Update Memory Bank)
description: Update memory bank during development sessions with session analysis
category: RapidSpec
tags: [rapidspec, memory, umb, session-tracking]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: "[optional: focus area for session update]"
---

# RapidSpec UMB Command

Update Memory Bank during development sessions. Analyzes recent work and updates all relevant memory files with new decisions, progress, patterns, and context.

## Usage

```bash
/rapidspec.umb
# Analyze current session and update all memory files

/rapidspec.umb Focus on authentication refactoring
# Update memory bank with specific session focus
```

## What This Does

Examines the current session (git changes, proposals, chat history context) and intelligently updates:

1. **decisionLog.md** - Technical decisions made during session
2. **progress.md** - Work completed or started
3. **activeContext.md** - Current objectives and blockers
4. **systemPatterns.md** - New patterns observed or introduced
5. **productContext.md** - Any scope or architectural changes
6. **constitution.md** - No direct updates (reference governance)

## Command Flow

<!-- RAPIDSPEC:START -->

### 1. Verify Initialization

Check that memory bank is ready:

```bash
# Check if memory bank exists
if [[ ! -d ".rapidspec/memory" ]]; then
  echo "Memory bank not initialized. Run:"
  echo "  /rapidspec.constitution"
  exit 1
fi

# Verify all required files exist
REQUIRED_FILES=("constitution.md" "productContext.md" "activeContext.md" "systemPatterns.md" "decisionLog.md" "progress.md")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f ".rapidspec/memory/$file" ]]; then
    MISSING_FILES+=("$file")
  fi
done

if [[ ${#MISSING_FILES[@]} -gt 0 ]]; then
  echo "⚠️  Memory bank incomplete. Missing: ${MISSING_FILES[*]}"
  echo "Run: /rapidspec.constitution"
  exit 1
fi

echo "[MEMORY BANK: UPDATING]"
echo "Analyzing current session..."
```

### 2. Analyze Session

Review chat history and recent changes to extract:

#### 2a. Decisions Made

Look for decision indicators in session:

```bash
# Check git diff for significant changes
git diff HEAD~10..HEAD --name-only | grep -E "src/|lib/" > /tmp/changed_files.txt

# Search chat history for decision keywords (simulated via git log)
# Real implementation would analyze actual chat context
git log --oneline --grep="decide\|decided\|choose\|chosen\|architecture\|pattern\|approach" -20 > /tmp/decisions.txt

# Extract decision candidates
echo "Decision Keywords Found:"
grep -i "decision\|decided\|chose\|approach\|architecture" /tmp/decisions.txt | head -5
```

Extract from session:
- Technical choices made (algorithms, libraries, patterns)
- Trade-offs discussed and decided
- Architectural changes
- Code organization decisions

#### 2b. Progress Updates

Identify completed and in-progress work:

```bash
# Check for completed changes (archived)
COMPLETED=$(find changes/archive -type d -name "*" | xargs ls -trd 2>/dev/null | tail -5)

# Check for active changes
ACTIVE=$(ls -trd changes/*/ 2>/dev/null | grep -v archive | head -5)

# Get recent commits
git log --oneline -10 > /tmp/recent_commits.txt

echo "Recent Work:"
cat /tmp/recent_commits.txt
```

Extract:
- Features completed and merged
- Bugs fixed
- Refactoring completed
- Technical debt addressed

#### 2c. Patterns Observed

Identify new or modified patterns in code:

```bash
# Check for new coding patterns in recent commits
for file in $(cat /tmp/changed_files.txt | head -20); do
  if [[ -f "$file" ]]; then
    echo "=== $file ==="
    head -50 "$file" | grep -E "^\s*(const|function|class|async|interface)" | head -3
  fi
done
```

Extract:
- New design patterns introduced
- Code organization changes
- Testing patterns added
- Security patterns applied

#### 2d. Context Changes

Identify scope or architectural changes:

```bash
# Check for changes in core files
for file in package.json tsconfig.json .env.example README.md; do
  if git diff HEAD~5..HEAD -- "$file" > /dev/null 2>&1; then
    echo "Modified: $file"
    git diff HEAD~5..HEAD -- "$file" | head -20
  fi
done
```

Extract:
- New dependencies added or removed
- Feature scope changes
- Architecture modifications
- Technology choices

#### 2e. Session State

Capture current work state:

```bash
# Current branch and status
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
UNCOMMITTED=$(git status --porcelain | wc -l)

# Active proposals
ACTIVE_PROPOSALS=$(find . -path ./node_modules -prune -o -path "./.git" -prune -o -name "proposal.md" -newer /tmp/session_start.txt 2>/dev/null | wc -l)

echo "Session State:"
echo "  Branch: $CURRENT_BRANCH"
echo "  Uncommitted changes: $UNCOMMITTED"
echo "  Active proposals: $ACTIVE_PROPOSALS"
```

### 3. Update Files

#### 3a. Update decisionLog.md (APPEND)

Add new decisions with timestamps:

```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Append new decision entry
cat >> .rapidspec/memory/decisionLog.md << EOF

### [$TIMESTAMP] - [Decision from session]

**Context:**
[Why was this needed?]

**Decision:**
[What was decided?]

**Rationale:**
[Why this approach?]

**Alternatives Considered:**
- Alternative A: [Description] → Rejected because [reason]
- Alternative B: [Description] → Rejected because [reason]

**Implications:**
- Impact on [Component]: [Specific effects]

**Related:**
- Files: [list changed files]
- Commits: [relevant commit hashes]

EOF

echo "✓ decisionLog.md updated"
```

#### 3b. Update progress.md (APPEND)

Add work completed or started:

```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Append progress entry for completed work
if [[ -n "$COMPLETED" ]]; then
  cat >> .rapidspec/memory/progress.md << EOF

### [$TIMESTAMP] - Work Completed

- **Feature/Fix**: [Name from git log]
  - Change ID: [from commit message]
  - Status: Completed
  - Files: $(echo "$COMPLETED" | tr '\n' ', ')

EOF
fi

# Append entry for in-progress work
if [[ -n "$ACTIVE" ]]; then
  cat >> .rapidspec/memory/progress.md << EOF

### [$TIMESTAMP] - Work In Progress

- **Feature/Fix**: [Name from current branch]
  - Status: In Progress
  - Current focus: [from session or arguments]

EOF
fi

echo "✓ progress.md updated"
```

#### 3c. Update activeContext.md (MODIFY)

Update session objectives and blockers:

```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Update "Recent Changes" section
sed -i "/^## Recent Changes/a\\
\n### [$TIMESTAMP] - Session Update\n\
[Summary of work done this session]\n" .rapidspec/memory/activeContext.md

# Update "Next Actions" section
sed -i "/^## Next Actions/,/^###/ s/^###/\n### [$TIMESTAMP] - Updated Next Steps\n\n- [Next action based on session]\n\n###/" .rapidspec/memory/activeContext.md

# Add any identified blockers
if [[ -n "$BLOCKERS" ]]; then
  sed -i "/^### Known Blockers/a\\
\n- Issue: [Blocker from session]\n  Root cause: [Analysis]\n  Actions: [Mitigation]" .rapidspec/memory/activeContext.md
fi

echo "✓ activeContext.md updated"
```

#### 3d. Update systemPatterns.md (APPEND)

Add new patterns or anti-patterns discovered:

```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# If new patterns found in changed files
if [[ -s /tmp/new_patterns.txt ]]; then
  cat >> .rapidspec/memory/systemPatterns.md << EOF

### [$TIMESTAMP] - New Pattern Introduced

**Pattern Name**: [Name of pattern]

**Description**: [What was introduced]

**Example**:
\`\`\`
[Code example from actual implementation]
\`\`\`

**When to use**: [Guidance on when to apply]

**Why**: [Benefits of this approach]

EOF
fi

echo "✓ systemPatterns.md updated"
```

#### 3e. Update productContext.md (MODIFY)

Update if scope or architecture changed:

```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Check for scope changes
if git diff HEAD~10..HEAD -- package.json | grep -q '"'; then
  # Dependencies changed, update tech stack section
  sed -i "/^### Technology Stack/a\\
\n**Updated [$TIMESTAMP]**: New dependencies added. See recent commits for details." .rapidspec/memory/productContext.md
fi

# Check for architectural changes
if [[ ${#CHANGED_ARCHITECTURE[@]} -gt 0 ]]; then
  sed -i "/^## Components & Architecture/a\\
\n**Modified [$TIMESTAMP]**: Architecture changed. See decisionLog for details." .rapidspec/memory/productContext.md
fi

echo "✓ productContext.md updated (if needed)"
```

### 4. Cross-File Synchronization

Ensure consistency across memory bank:

```bash
# If decision was marked as "becomes pattern", add to systemPatterns
if grep -q "becomes a pattern\|pattern going forward" .rapidspec/memory/decisionLog.md; then
  echo "Syncing decision to systemPatterns.md..."
  # Extract pattern details from recent decision entry
  # Add to systemPatterns with reference back to decision
fi

# If task was completed, clear from activeContext objectives
if grep -q "✓ Completed\|DONE" .rapidspec/memory/progress.md; then
  echo "Syncing completed work to activeContext.md..."
  # Mark objectives as complete
fi

# If question was answered, log as decision
if grep -q "Status: \[Resolved\]\|Status: \[Answered\]" .rapidspec/memory/activeContext.md; then
  echo "Syncing resolved questions to decisionLog.md..."
  # Move from questions to decisions
fi

echo "✓ Cross-file synchronization complete"
```

### 5. Summary and Status

Display what was updated:

```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo ""
echo "=========================================="
echo "✅ Memory Bank Update Complete"
echo "=========================================="
echo ""
echo "Files Updated:"
echo "  ✓ decisionLog.md"
echo "  ✓ progress.md"
echo "  ✓ activeContext.md"
echo "  ✓ systemPatterns.md"
echo "  ✓ productContext.md (if changes detected)"
echo ""
echo "Session Summary:"
echo "  Timestamp: $TIMESTAMP"
echo "  Decisions logged: [count]"
echo "  Work items added: [count]"
echo "  Patterns documented: [count]"
echo ""
echo "[MEMORY BANK: ACTIVE]"
echo "Memory synchronized based on current session"
```

<!-- RAPIDSPEC:END -->

## When to Use UMB

Call `/rapidspec.umb` at natural break points:

- **End of day**: Summarize day's work and decisions
- **Between features**: Before starting new feature work
- **After major decision**: When significant trade-off or architectural choice made
- **When blockers arise**: To document impediments and workarounds
- **Before pausing work**: To capture context for resuming later
- **Periodically during session**: Keep memory bank fresh during long sessions

## Integration with Other Commands

### Suggested Auto-Triggers (with flags)

```bash
# After /rapidspec.proposal - if --track flag
/rapidspec.proposal --track-memory

# After /rapidspec.apply - every N checkpoints
# Checkpoint 5/10: Auto-update if --auto-memory enabled

# After /rapidspec.review - if --log-findings
/rapidspec.review --log-findings-to-memory

# After /rapidspec.commit - if --update-memory
/rapidspec.commit --update-memory

# After /rapidspec.archive - always update (completed work)
# Automatically calls UMB to move change to progress.md completed
```

Users can control behavior with flags:
- `--auto` - Always update (no prompt)
- `--skip` - Never update (suppresses memory bank changes)
- `--prompt` - Ask each time (default)

## Example Session Flow

```bash
# 1. Start work
git checkout -b feature/auth-refactor

# 2. Make changes
# ... implement authentication refactoring ...

# 3. Before committing - update memory bank
/rapidspec.umb Feature completed: consolidated auth middleware

# Output:
# [MEMORY BANK: UPDATING]
# Analyzing current session...
#   Branch: feature/auth-refactor
#   Changed files: 3 (middleware/auth.ts, services/auth.ts, __tests__/auth.ts)
#   Recent commits: 5
#
# Extracting decisions...
#   Decision 1: Chose centralized auth middleware over decorator pattern
#   Decision 2: Implemented rate limiting in auth service
#
# Updating files...
# ✓ decisionLog.md
# ✓ progress.md
# ✓ activeContext.md
# ✓ systemPatterns.md
#
# ✅ Memory Bank Update Complete
# [MEMORY BANK: ACTIVE]

# 4. Commit work
/rapidspec.commit "Complete auth middleware refactor"

# 5. End of day - final memory update
/rapidspec.umb "Completed authentication refactor, all tests passing"
```

## Key Features

✅ **Session Analysis**: Extracts decisions from actual work
✅ **Intelligent Updates**: Appends to some files, modifies others strategically
✅ **Cross-File Sync**: Ensures consistency across memory bank
✅ **Timestamp Tracking**: All updates include precise timestamps
✅ **Contextual**: Uses git history and changed files for accuracy
✅ **Non-Destructive**: Appends rather than overwrites existing content

## Output Example

```
[MEMORY BANK: UPDATING]
Analyzing current session...
  Branch: feature/api-pagination
  Uncommitted changes: 2
  Active proposals: 1

Extracting decisions...
  Decision 1: Cursor-based pagination instead of offset
  Decision 2: Max limit of 100 items per page
  Pattern: Reusable pagination middleware

Updating files...
✓ decisionLog.md (2 decisions added)
✓ progress.md (In-progress feature updated)
✓ activeContext.md (Objectives and next steps updated)
✓ systemPatterns.md (1 new pattern documented)

=========================================
✅ Memory Bank Update Complete
=========================================

Files Updated: 4
Session Summary:
  Decisions logged: 2
  Work items: 1
  Patterns documented: 1

[MEMORY BANK: ACTIVE]
Memory synchronized based on current session
```

## Notes

- UMB preserves all existing content - it appends and modifies strategically
- Multiple sessions on same branch get added as separate timestamped entries
- Memory bank serves as permanent record even after branches are deleted
- Use with git for complete work audit trail
- Update frequency is flexible - daily, per-feature, or per-session based on preference
