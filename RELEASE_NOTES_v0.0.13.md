# RapidSpec v0.0.13 Release Notes

**Release Date:** 2025-12-27
**Previous Version:** v0.0.12
**Status:** Stable

## Overview

RapidSpec v0.0.13 enhances the `/rapidspec.commit` command to support feature/fix branch workflows. All RapidSpec changes now go through feature branches and PR reviews before merging to main, following best practices for collaborative development.

## What's New

### 1. Enhanced `/rapidspec.commit` Command ✅

The commit command now automatically creates feature/fix branches instead of committing directly to main.

**Before (v0.0.12):**
```bash
/rapidspec.commit add-user-auth
# Commits directly to main (no PR review)
```

**After (v0.0.13):**
```bash
/rapidspec.commit add-user-auth
# Creates feature/add-user-auth branch
# Commits to that branch
# Pushes to origin
# Suggests creating PR
```

### 2. Automatic Branch Creation Strategy

Commits are mapped to appropriate branch types:

| Commit Type | Branch Prefix | Example |
|---|---|---|
| `feat(...)` | `feature/` | `feature/add-user-auth` |
| `fix(...)` | `fix/` | `fix/memory-leak-database` |
| `refactor(...)` | `refactor/` | `refactor/api-client` |
| `perf(...)` | `perf/` | `perf/query-optimization` |
| Other types | `chore/` | `chore/update-deps` |

### 3. Workflow Steps

The enhanced `/rapidspec.commit` now follows this workflow:

**Step 0: Create Feature/Fix Branch**
- Detects commit type from message
- Maps to appropriate branch prefix
- Creates branch if currently on main
- Validates we're not committing to main

**Step 1-6: Original Commit Steps** (unchanged)
- Review git changes
- Match changes to tasks
- Update tasks.md
- Generate commit message
- Wait for approval
- Create commit

**Step 7: Push to Feature Branch** (NEW)
- Validates branch is NOT main
- Pushes to feature branch on origin
- Prevents accidental main commits
- Shows branch name and status

**Step 8: Suggest Next Steps** (NEW)
- Recommend creating PR: `gh pr create`
- Suggest quality review: `/rapidspec.review`
- Suggest archival after deployment: `/rapidspec.archive`

### 4. Workflow Guard Rails

**Prevents:**
- ❌ Direct commits to main
- ❌ Skipping PR review
- ❌ Unorganized branch names
- ❌ Unclear commit types

**Ensures:**
- ✅ Feature branches for all work
- ✅ PR review before merge
- ✅ Clean git history
- ✅ Conventional branch names

### 5. Example Workflows

#### Feature Implementation Workflow
```bash
# 1. Create proposal
/rapidspec.proposal add-user-authentication

# 2. Implement with checkpoints
/rapidspec.apply add-user-authentication

# 3. Commit to feature branch
/rapidspec.commit add-user-authentication

# Output:
# ✓ Created branch: feature/add-user-authentication
# ✓ Committed: abc1234
# ✓ Pushed to: feature/add-user-authentication
# Next: gh pr create --title 'feat(auth): add user authentication'

# 4. Create PR for review
gh pr create --title 'feat(auth): add user authentication'

# 5. After review and merge, archive
/rapidspec.archive add-user-authentication
```

#### Bug Fix Workflow
```bash
# 1. Create proposal
/rapidspec.proposal fix-memory-leak

# 2. Implement fix
/rapidspec.apply fix-memory-leak

# 3. Commit to fix branch
/rapidspec.commit fix-memory-leak

# Output:
# ✓ Created branch: fix/fix-memory-leak
# ✓ Committed: def5678
# ✓ Pushed to: fix/fix-memory-leak
# Next: gh pr create --title 'fix: prevent memory leak in database queries'

# 4. Create and merge PR
gh pr create --title 'fix: prevent memory leak in database queries'
```

#### Partial Implementation with Multiple Commits
```bash
# Work on feature across multiple commits
/rapidspec.commit task-1          # Creates feature/task-1, commits, pushes
/rapidspec.commit task-2          # Adds to same feature branch
# ... more work ...
/rapidspec.commit final-tasks     # Final commit to feature branch

# All commits go to same feature branch
# Then create single PR for entire feature
gh pr create --title 'feat(api): implement new endpoints'
```

## Benefits

### For Individual Developers
- ✅ **Organized branches**: Conventional naming (feature/fix/refactor)
- ✅ **Clear history**: Easy to understand what each branch does
- ✅ **No main commits**: Can't accidentally break production branch
- ✅ **Checkpoints**: Reviews happen before merging

### For Teams
- ✅ **Code review**: All changes reviewed before merge
- ✅ **Better communication**: Branch names explain intent
- ✅ **Conflict prevention**: Features isolated in branches
- ✅ **Audit trail**: Clear decision history in PRs
- ✅ **Collaboration**: Multiple developers can work on same project

### For Automation
- ✅ **Consistent structure**: Standard branch naming
- ✅ **CI/CD friendly**: Can trigger on branch patterns
- ✅ **Release ready**: Can auto-detect release-ready branches
- ✅ **Integration ready**: Works with GitHub Actions, CI systems

## Technical Changes

### Modified Files

**templates/commands/commit.md** (+158 lines)
- Added Step 0: Create Feature/Fix Branch
- Added Step 7: Push to Feature Branch
- Added Step 8: Suggest Next Steps
- Updated all 3 examples to show feature branch workflow
- Enhanced descriptions for feature branch strategy

### No Breaking Changes

- ✅ Same commit message format
- ✅ Same task verification logic
- ✅ Same discovered work capture
- ✅ Same review/archive workflow
- ✅ Only difference: commits go to feature branch (better!)

## Installation

### Update Existing Installation

```bash
# Via pip
pip install --upgrade rapidspec-cli

# Via uv
uv tool install --upgrade rapidspec-cli

# Via GitHub
pip install --upgrade git+https://github.com/benzntech/rapidspec-kit.git@v0.0.13
```

### Fresh Installation

```bash
# Via pip
pip install rapidspec-cli

# Via uv
uv tool install rapidspec-cli --from git+https://github.com/benzntech/rapidspec-kit.git@v0.0.13
```

## Upgrade Guide

If upgrading from v0.0.12 to v0.0.13:

1. **Update the CLI**:
   ```bash
   pip install --upgrade rapidspec-cli
   ```

2. **No changes to existing projects**
   - All RapidSpec commands work as before
   - Enhanced workflow only applies to new `/rapidspec.commit` calls

3. **New commit behavior**
   - When you use `/rapidspec.commit`, it creates feature branches
   - Old projects using main commits: create PR manually then merge
   - New projects: automatic feature branch workflow

## Verification

Tested on:
- ✅ macOS (Apple Silicon and Intel)
- ✅ All commit types (feat, fix, refactor, perf, chore)
- ✅ Feature branch creation
- ✅ Push to feature branch
- ✅ PR creation suggestions
- ✅ Git validation logic
- ✅ Error handling

## Release Assets

All packages include:
- Enhanced `/rapidspec.commit` command
- Feature branch workflow
- Updated examples and documentation
- All 17 AI model templates
- Complete memory bank system

## What's Next

### v0.0.14 (Planned)
- Auto-create PRs from `/rapidspec.commit`
- Branch protection rules validation
- Automated merge workflows

### v0.1.0 (Planned)
- IDE extensions (VS Code, JetBrains)
- Web UI for commit and branch management
- Enhanced PR templates

### v0.2.0 (Planned)
- Collaborative workflows
- Cloud-based project management
- Advanced branch strategies (git flow, trunk-based)

## Known Limitations

- Branch names derived from commit message (must be valid Git branch name)
- Requires Git to be installed and functional
- GitHub CLI (`gh`) recommended for PR creation (can use web UI alternative)

## Migration Guide

### For Existing v0.0.12 Projects

**If you have pending commits on main:**
```bash
# Option 1: Create feature branch manually first
git checkout -b feature/my-change

# Option 2: Let /rapidspec.commit create branch automatically
/rapidspec.commit my-change
```

**Projects using feature branches already:**
- ✅ No changes needed - your workflow already aligns!
- ✅ Can now use `/rapidspec.commit` for branch creation
- ✅ Reduces manual branch management

## Questions & Support

- **GitHub Issues**: https://github.com/benzntech/rapidspec-kit/issues
- **Documentation**: https://github.com/benzntech/rapidspec-kit#readme
- **Discussions**: https://github.com/benzntech/rapidspec-kit/discussions
- **AGENTS.md**: See project's `AGENTS.md` for workflow details

## Contributors

This release includes enhancements to improve the RapidSpec workflow and align with best practices for collaborative development.

## Changelog

### Features
- Add automatic feature/fix branch creation in `/rapidspec.commit`
- Add branch type detection from commit message
- Add push to feature branch workflow
- Add PR creation suggestions

### Improvements
- Better validation of branch names
- Clearer error messages for branch operations
- Enhanced documentation with examples
- More robust git operations

### Documentation
- Updated commit command documentation
- Added feature branch strategy guide
- Added workflow examples
- Added migration guide for existing projects

## Related Changes

This release includes:
- **PR #1**: Fix workflow script permissions (merged in v0.0.12 patch)
- **PR #2**: Enhance /rapidspec.commit with feature branch support (merged in v0.0.13)
- **Memory Bank**: Updated activeContext.md with enhancement details

---

**RapidSpec v0.0.13 - Feature Branch Workflows**

*Better collaboration through automatic branch management and PR-based workflows.*

Release date: 2025-12-27
Status: Stable
Upgrade recommended for teams using collaborative workflows
