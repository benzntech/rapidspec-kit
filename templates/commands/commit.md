---
name: RapidSpec: Commit
description: Create well-formatted commits with conventional commit format
category: RapidSpec
tags: [rapidspec, commit, git]
allowed-tools: Read, Bash, Grep, Glob, Task
argument-hint: [message] | --no-verify | --amend

---

<!-- SPECKIT.SPEC:START -->
# Commit RapidSpec Implementation

<command_purpose>
Create conventional commits with task verification and discovered work capture.
Verify git changes match tasks.md before marking complete, support partial commits.
</command_purpose>

<critical_requirement>
MUST verify claims with `git diff` and `git status` - NEVER trust memory.
MUST match actual git changes to tasks.md before marking complete.
MUST capture discovered work (unplanned improvements).
CAN commit partial work for incremental progress.
</critical_requirement>

## Main Tasks

### 0. Create Feature/Fix Branch (NEW - BEFORE CHANGES)

<thinking>
RapidSpec commit should NOT commit to main directly.
Instead, create a feature or fix branch based on the change type.
This ensures all changes go through PR review before merging to main.
</thinking>

**Branch Creation Strategy:**

1. **Determine branch type** from commit message type:
   - `feat(...)` → Create `feature/[change-id]` branch
   - `fix(...)` → Create `fix/[change-id]` branch
   - `refactor(...)` → Create `refactor/[change-id]` branch
   - `perf(...)` → Create `perf/[change-id]` branch
   - Other types → Create `chore/[change-id]` branch

2. **Get change-id** from context or argument (e.g., "add-user-auth")

3. **Create and switch to branch:**
   ```bash
   # Check current branch
   CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

   # If on main, create feature branch
   if [[ "$CURRENT_BRANCH" == "main" ]]; then
     COMMIT_TYPE=$(echo "$MESSAGE" | grep -oP '^\w+' || echo "chore")

     case "$COMMIT_TYPE" in
       feat) BRANCH_PREFIX="feature" ;;
       fix) BRANCH_PREFIX="fix" ;;
       refactor) BRANCH_PREFIX="refactor" ;;
       perf) BRANCH_PREFIX="perf" ;;
       *) BRANCH_PREFIX="chore" ;;
     esac

     BRANCH_NAME="$BRANCH_PREFIX/$CHANGE_ID"
     git checkout -b "$BRANCH_NAME"
     echo "✓ Created branch: $BRANCH_NAME"
   fi
   ```

4. **Status check:**
   - Display: "Branch: [feature/change-id]"
   - Confirm we're NOT on main anymore
   - Ready for committing changes

---

### 1. Review Git Changes (ALWAYS FIRST)

<thinking>
First, verify what actually changed by reading git status and diff.
Never assume or trust memory - always check actual file modifications.
This prevents marking tasks complete incorrectly.
</thinking>

**Immediate Actions:**
   ```bash
   git status
   git diff
   git log --oneline -5
   ```

   - List all modified, added, deleted files

   - Analyze actual code changes

   - Check recent commit messages for style

### 2. Match Changes to Tasks

<thinking>
Cross-reference git changes with tasks.md to verify completion.
Mark tasks as complete only if git diff confirms the work.
Capture any discovered work not in original task list.
</thinking>

**Task verification process:**

   - Read `rapidspec/changes/<change-id>/tasks.md`

   - For each task, check if actual git changes match:

     - Task 1.2: API Validation → Check API route files

     - Task 1.3: UI Toast → Check component files

   - Mark matching tasks as `[x]`

   - Leave incomplete tasks as `[ ]`

   - Capture discovered work not in original tasks

### 3. Update tasks.md

<thinking>
Update the task file to reflect actual completion state.
Document discovered work for traceability and future reference.
</thinking>

**Actions:**

   - Update checkboxes: `[ ]` → `[x]` for completed tasks

   - Add "Discovered Tasks" section if unplanned work found

   - Show completion status: "5/6 tasks complete"

### 4. Generate Commit Message

<thinking>
Create descriptive conventional commit message that summarizes changes.
Include completed tasks, discovered work, and testing information.
</thinking>

**Format:**
   ```
   type(scope): brief description

   ## Completed Tasks (X/Y)

   - Task description

   - Task description

   ## Additional Improvements (if discovered work)

   - Unplanned improvement

   - Unplanned improvement

   ## Testing

   - E2E: test-file.spec.ts ✓

   - Unit: test.test.ts ✓

   🤖 Generated with Claude Code
   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

### 5. Wait for Approval

<thinking>
Show commit message preview and wait for user confirmation.
User may want to revise message or change what's committed.
</thinking>

**Actions:**

   - Show commit message preview

   - Ask: "Ready to commit? (yes to proceed)"

   - If user says "wait" or "revise", modify message

### 6. Create Commit

<thinking>
Stage appropriate files and create commit with approved message.
Show commit hash and suggest next steps in workflow.
Push to feature branch, not main.
</thinking>

**Actions:**
   ```bash
   git add <files>
   git commit -m "<message>"
   ```

   - Show commit hash

   - Show current branch: `git rev-parse --abbrev-ref HEAD`

### 7. Push to Feature Branch

<thinking>
Push the commit to the feature/fix branch, not to main.
This ensures all work goes through PR review before merging.
</thinking>

**Push Actions:**
   ```bash
   CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

   if [[ "$CURRENT_BRANCH" != "main" ]]; then
     git push origin "$CURRENT_BRANCH"
     echo "✓ Pushed to branch: $CURRENT_BRANCH"
     echo ""
     echo "Next steps:"
     echo "1. Create PR: gh pr create --title '[commit message title]'"
     echo "2. Review changes and merge when ready"
     echo "3. Run: /rapidspec.review $CHANGE_ID (optional quality check)"
     echo "4. Run: /rapidspec.archive $CHANGE_ID (when deployed)"
   else
     echo "⚠ Still on main branch. Please create feature branch first."
     exit 1
   fi
   ```

   - Show pushed branch name

   - Suggest next steps: Create PR, then review/archive

### 8. Suggest Next Steps

**After commit and push:**
   - Suggest: `/rapidspec.review [change-id]` for quality check
   - Suggest: Create PR using `gh pr create`
   - Suggest: `/rapidspec.archive [change-id]` after deployment

## Commit Types

- `feat`: New feature

- `fix`: Bug fix

- `refactor`: Code restructuring

- `perf`: Performance improvement

- `test`: Test addition

- `docs`: Documentation

- `chore`: Maintenance

- `style`: Formatting

**Examples**

Example 1: Complete Feature (with Feature Branch)
```
User: "/rapidspec.commit add-loading-state"

[Step 0: Create Feature Branch]
✓ Current branch: main
✓ Creating branch: feature/add-loading-state
✓ Switched to: feature/add-loading-state

[Step 1: Review Git Changes]
AI reviews git:
✓ Git diff analyzed: 3 files changed
✓ Modified: src/app/dashboard/page.tsx (+12 -3)
✓ Added: src/app/dashboard/loading.tsx (new)
✓ Added: e2e/dashboard/loading.spec.ts (new)

[Step 2: Match Changes to Tasks]
Matching to tasks.md...
✓ Task 1.1: Add Suspense boundary - DONE
✓ Task 1.2: Create loading.tsx - DONE
✓ Task 1.3: Test loading state - DONE

Status: 3/3 tasks complete

[Step 4: Generate Commit Message]
Commit message:
────────────────────────────────────────
feat(ui): add loading states with Suspense boundaries

## Completed Tasks (3/3)

- Add Suspense boundary to dashboard page

- Create loading.tsx with skeleton UI

- Test loading state behavior

## Testing

- E2E: dashboard/loading.spec.ts ✓

- Manual testing: verified Suspense works ✓

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
────────────────────────────────────────

Ready? (yes)

User: "yes"

[Step 6: Create Commit]
AI: ✓ Committed: abc1234
   ✓ Branch: feature/add-loading-state

[Step 7: Push to Feature Branch]
✓ Pushed to branch: feature/add-loading-state

Next steps:
1. Create PR: gh pr create --title 'feat(ui): add loading states with Suspense boundaries'
2. Review changes and merge when ready
3. Run: /rapidspec.review add-loading-state (optional quality check)
4. Run: /rapidspec.archive add-loading-state (when deployed)
```

Example 2: Partial Commit (with Feature Branch)
```
User: "/rapidspec.commit add-auth-mutex"

[Step 0: Create Feature Branch]
✓ Current branch: main
✓ Creating branch: feature/add-auth-mutex
✓ Switched to: feature/add-auth-mutex

[Step 1: Review Git Changes]
AI reviews git:
✓ 2 files changed
✓ Modified: package.json (new dependency)

[Step 2: Match Changes to Tasks]
Matching to tasks.md...
✓ Task 1.2: Update client.ts - DONE
⏳ Task 2.1: Update all auth calls - NOT DONE
⏳ Task 2.2: Add error handling - NOT DONE

Status: 2/4 tasks complete

Options:
1. Commit partial work (2/4 tasks)
2. Complete remaining tasks first

Which? (1 or 2)

User: "1"

[Step 4: Generate Commit Message]
Commit message:
feat(auth): add mutex to prevent token refresh race

Partial implementation (2/4 tasks):
- Update client.ts to use new createBrowserClient

Remaining:
- Update all auth calls to use new client
- Add error handling for mutex timeout

Ready? (yes)

User: "yes"

[Step 6: Create Commit]
AI: ✓ Committed: def5678
   ✓ Branch: feature/add-auth-mutex

[Step 7: Push to Feature Branch]
✓ Pushed to branch: feature/add-auth-mutex

Next steps:
1. Create PR: gh pr create --title 'feat(auth): add mutex to prevent token refresh race'
2. Continue implementation with remaining tasks
3. Push additional commits to same branch
4. Run: /rapidspec.review add-auth-mutex (when tasks complete)
5. Run: /rapidspec.archive add-auth-mutex (when deployed)
```

Example 3: Discovered Work (with Feature Branch)
```
User: "/rapidspec.commit prevent-duplicate-smartlinks"

[Step 0: Create Feature Branch]
✓ Current branch: main
✓ Creating branch: feature/prevent-duplicate-smartlinks
✓ Switched to: feature/prevent-duplicate-smartlinks

[Step 1: Review Git Changes]
AI reviews git:
✓ 8 files changed

[Step 2: Match Changes to Tasks]
Matching to tasks.md...
✓ 5 planned tasks completed

Discovered work (not in tasks):
📝 Added: Index on release_id for performance
📝 Added: Extracted validation logic to helper
📝 Fixed: Type error in SmartLinkForm

[Step 3: Update tasks.md]
Added section "4. Performance & Quality (Discovered)"

[Step 4: Generate Commit Message]
Commit message:
feat(smart-links): prevent duplicate links per release

## Completed Tasks (5/5)

- API Validation: 400 error handling

- UI Toast: duplicate warning

- E2E Test: duplicate prevention flow

- Unit Test: validation logic

## Additional Improvements

- Performance: Add index on release_id

- Code quality: Extract validateSmartLink()

- Fix: Type error in SmartLinkForm

Ready? (yes)

User: "yes"

[Step 6: Create Commit]
AI: ✓ Committed: ghi9012
   ✓ Branch: feature/prevent-duplicate-smartlinks

[Step 7: Push to Feature Branch]
✓ Pushed to branch: feature/prevent-duplicate-smartlinks

Next steps:
1. Create PR: gh pr create --title 'feat(smart-links): prevent duplicate links per release'
2. Review changes and merge when ready
3. Run: /rapidspec.review prevent-duplicate-smartlinks (recommended for quality check)
4. Run: /rapidspec.archive prevent-duplicate-smartlinks (when deployed)
```

**Anti-Patterns**

❌ Don't: Mark tasks complete without verifying
```
Bad: User says "commit" → Mark all [x] → Commit
→ No git verification
```

✅ Do: Verify with git first
```
Good: git diff → Match to tasks → Mark verified [x]
```

❌ Don't: Lose discovered work
```
Bad: Added index during implementation → Not recorded
```

✅ Do: Capture all work
```
Good: Add "Discovered Tasks" → Update tasks.md
```

**Reference**

- Always run `git diff` and `git status` first

- Update tasks.md with actual completion status

- Conventional commit format: `type(scope): description`

- User says "yes" (go), "wait" (wait), "no" (no)

- Can commit multiple times per spec

- After commit, suggest `/rapidspec.review` for quality check

## Memory Bank Integration (Automatic)

After successful commit, automatically update the memory bank to record completed work:

**Automatic behavior:**
- After successful commit, call `/rapidspec.umb` automatically (no flags needed)
- This is not optional - commit progress is always logged to memory bank

**What gets logged automatically:**

```bash
/rapidspec.umb Work committed: $CHANGE_ID
- Commit: $COMMIT_HASH
- Message: $COMMIT_MESSAGE
- Tasks completed: [list of marked [x] tasks]
- Discovered work: [any unplanned work captured]
- Files modified: [count and types]
```

This will:
1. Append new entry to `progress.md` marking work as completed
2. Update `decisionLog.md` with discovered insights from implementation
3. Update `activeContext.md` to clear completed objectives

**Why automatic:**
- Ensures all committed work is recorded in memory bank
- Maintains continuous audit trail of all changes
- Enables project history reconstruction
- Supports team knowledge retention

**Example:**
```bash
# Create commit (always updates memory bank automatically)
/rapidspec.commit "feat: add OAuth2 authentication"

# Git commit succeeds
# Memory bank automatically updated:
#   - progress.md: "OAuth2 feature committed"
#   - decisionLog.md: "Implemented JWT token strategy"
#   - activeContext.md: "Objectives cleared, next task identified"
```

<!-- RAPIDSPEC:END -->
