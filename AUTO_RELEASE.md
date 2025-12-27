# Automatic Release on Push

## Overview

**Releases now happen automatically whenever you push a version change to main.**

No additional steps needed - just update the version and push!

---

## How It Works

### The Flow

```
1. You push pyproject.toml change to main
   ↓
2. GitHub detects version change in pyproject.toml
   ↓
3. auto-release.yml workflow triggers automatically
   ↓
4. Workflow checks if release already exists
   ├─ If exists: Skip (no duplicate)
   └─ If not: Trigger release.yml workflow
   ↓
5. Release workflow starts automatically
   ├─ Generate 34 template packages
   ├─ Create GitHub release
   ├─ Sync git tags
   └─ Complete in 1-2 minutes
   ↓
6. Release ready with all assets!
```

### What You Do

```bash
# 1. Bump version using Makefile
make release-patch

# 2. Done! Everything else is automatic:
#    - Version updated in pyproject.toml
#    - Commit created
#    - Pushed to main
#    - Release workflow triggered
#    - Packages generated
#    - GitHub release created
#    - Git tags synchronized
```

---

## Usage Examples

### Example 1: Simple Release

```bash
# Current: v0.0.11
make release-patch

# Automatic sequence:
# → Bumps to v0.0.12
# → Pushes to main
# → auto-release.yml detects change
# → release.yml workflow triggers
# → 1-2 minutes later: Release v0.0.12 ready!
```

### Example 2: Minor Release

```bash
# Current: v0.0.11
make release-minor

# Automatic sequence:
# → Bumps to v0.1.0
# → Pushes to main
# → auto-release.yml detects change
# → release.yml workflow triggers
# → Release v0.1.0 ready!
```

### Example 3: Major Release

```bash
# Current: v0.1.0
make release-major

# Automatic sequence:
# → Bumps to v1.0.0
# → Pushes to main
# → auto-release.yml detects change
# → release.yml workflow triggers
# → Release v1.0.0 ready!
```

---

## Workflow Details

### Trigger Conditions

The `auto-release.yml` workflow triggers when:
- ✅ Push to `main` branch
- ✅ Changes include `pyproject.toml`
- ✅ Version line has changed

### What It Does

#### 1. Detects Version Change
```bash
# Reads current version from pyproject.toml
VERSION=$(grep -m 1 'version = ' pyproject.toml | sed 's/.*version = "\([^"]*\)".*/\1/')
# Example: 0.0.12
```

#### 2. Checks if Release Exists
```bash
# Queries GitHub for existing release
gh release view v0.0.12

# If not found: Triggers release workflow
# If found: Skips (prevents duplicates)
```

#### 3. Triggers Release Workflow
```bash
# Automatically calls the main release.yml workflow
gh workflow run release.yml
```

#### 4. Monitors Completion
```bash
# Waits up to 30 minutes for release workflow
# Reports status in GitHub Actions summary
# Fails if release workflow fails
```

#### 5. Creates Summary
```bash
# Posts summary to GitHub Actions workflow log
# Shows version, release tag, trigger commit
# Reports release status
```

---

## Monitoring Release Progress

### During Release

Once you push, you can monitor progress:

```bash
# Check workflow status
make release-status

# Or use GitHub CLI
gh run list --workflow=auto-release.yml --limit=1
gh run list --workflow=release.yml --limit=1

# Or watch in real-time
gh run watch --workflow=release.yml
```

### Check Workflow Logs

```bash
# View auto-release workflow
gh run view --workflow=auto-release.yml

# View release workflow
gh run view --workflow=release.yml --log

# Search for specific version
gh run list --workflow=release.yml --json 'name' | grep v0.0.12
```

### Verify Release Created

```bash
# View release
gh release view v0.0.12

# List releases
gh release list

# Download packages
gh release download v0.0.12 --dir ~/releases/v0.0.12
```

---

## Workflow Architecture

### auto-release.yml (NEW)
- **Trigger:** Version change in pyproject.toml on main
- **Purpose:** Detect and trigger release workflow
- **Time:** ~5 minutes (includes waiting for release workflow)
- **Result:** Release workflow triggered

### release.yml (EXISTING)
- **Trigger:** Automatic from auto-release.yml OR manual
- **Purpose:** Generate packages and create release
- **Time:** ~2 minutes
- **Result:** Complete release with 34 packages

### Workflow Sequence

```
[auto-release.yml]
├─ Detect version from pyproject.toml
├─ Check if release exists
├─ Trigger release.yml if new
└─ Wait for completion
    ↓
[release.yml]
├─ Generate 34 packages
├─ Create GitHub release
├─ Sync git tags
└─ Complete
```

---

## Important Features

### 1. No Duplicate Releases
```
If version already released:
✓ auto-release.yml detects it
✓ Skips workflow trigger
✓ No duplicate release created
```

### 2. Automatic Version Reading
```
Reads from single source of truth:
✓ pyproject.toml is authoritative
✓ No manual tag creation needed
✓ No version mismatches possible
```

### 3. Commit-Based Triggering
```
Release created from exact commit:
✓ Know exactly what's in release
✓ Reproducible builds
✓ Full git history preserved
```

### 4. Status Reporting
```
Each workflow logs status:
✓ GitHub Actions summary page
✓ Workflow run details
✓ Clear success/failure indication
```

---

## Combined Workflow

### Complete Release Process (Start to Finish)

```
Time  Action                           Status
────────────────────────────────────────────────────
0:00  make release-patch               Local
      ├─ Update pyproject.toml
      ├─ Create commit
      └─ Push to main                  PUSHED
      
0:01  [auto-release.yml starts]        GitHub Actions
      ├─ Detect version v0.0.12
      ├─ Check if exists: No
      └─ Trigger [release.yml]         TRIGGERED
      
0:05  [release.yml starts]             GitHub Actions
      ├─ Generate 34 packages
      ├─ Create release
      ├─ Sync git tags
      └─ Complete                      COMPLETE
      
1:30  Release v0.0.12 ready!           Available
      ├─ 34 packages uploaded
      ├─ Git tag v0.0.12 created
      └─ Ready to download              READY
```

---

## Comparison: Old vs New

### BEFORE (Manual)
```
Step 1: Edit pyproject.toml
Step 2: Create commit
Step 3: Push to main
Step 4: Wait for release workflow
Step 5: Check GitHub
Step 6: Create git tag manually
Step 7: Push git tag
Result: Involved, many manual steps
```

### AFTER (Automatic)
```
Step 1: make release-patch
Step 2: Done! Everything else automatic:
  - Version bumped
  - Commit created
  - Pushed to main
  - auto-release.yml triggers
  - release.yml automatically runs
  - Packages generated
  - Release created
  - Tags synchronized
  - Ready in 1-2 minutes
```

---

## Error Handling

### Release Already Exists

If you accidentally push the same version twice:

```bash
# auto-release.yml detects existing release
# Logs: "Release v0.0.12 already exists"
# Result: No duplicate release created
```

### Workflow Fails

If release workflow fails:

```bash
# auto-release.yml reports failure
# Check logs: gh run view --log
# Fix issue and re-run:
make release-patch  # Push new version
```

### Network Issues

If push fails:

```bash
# auto-release.yml never triggers
# Just retry the push:
git push origin main
```

---

## Frequently Asked Questions

### Q: Do I still use make release-patch?

**A:** Yes! `make release-patch` is still the way to release. It now triggers auto-release automatically.

```bash
make release-patch  # Still use this
# The rest (git push, auto-release, etc.) happens automatically
```

### Q: What if I want to release without pushing?

**A:** You can't with the automatic system. This is intentional - prevents forgotten releases.

```bash
# Recommended: Just push and let it auto-release
make release-patch  # Push + auto-release

# If you need to test locally:
./scripts/bump-version.sh patch  # Test without pushing
git reset --soft HEAD~1          # Undo
git checkout pyproject.toml      # Restore
```

### Q: How long until release is ready?

**A:** Usually 1-2 minutes from push:
- 30 seconds: auto-release.yml runs
- 1-2 minutes: release.yml generates packages
- Total: 1.5-2.5 minutes

### Q: Can I release multiple times in one day?

**A:** Yes! Each `make release-patch` creates a new release:

```bash
make release-patch  # v0.0.11 → v0.0.12 (auto-releases)
# ... later ...
make release-patch  # v0.0.12 → v0.0.13 (auto-releases)
```

### Q: What if I want to skip auto-release?

**A:** Edit version WITHOUT pushing, then manually trigger:

```bash
# Dangerous! Not recommended - can cause version mismatches
vim pyproject.toml  # Edit manually
git add pyproject.toml
git commit -m "..."
# Don't push yet
# ... do other things ...
git push            # When ready
```

**Better approach:** Just let auto-release happen. It's safe and reliable.

### Q: How do I check if auto-release triggered?

**A:** Check GitHub Actions:

```bash
# View recent workflows
gh run list --limit=5

# Or view auto-release specifically
gh run list --workflow=auto-release.yml --limit=1

# View details
gh run view <run-id> --log
```

---

## Best Practices

### 1. Always Use make release-* Commands

```bash
# ✓ Good: Use automation
make release-patch

# ✗ Bad: Manual edits
vim pyproject.toml
git add .
git commit -m "..."
git push
```

### 2. Verify Version Before Pushing

```bash
# Check status first
make release-check

# Then release
make release-patch
```

### 3. Monitor Workflow After Push

```bash
# Watch progress (optional)
gh run watch --workflow=auto-release.yml

# Or just wait 1-2 minutes and check:
gh release list
```

### 4. Use Appropriate Version Types

- **Patch**: Bug fixes → `make release-patch`
- **Minor**: Features → `make release-minor`
- **Major**: Breaking changes → `make release-major`

### 5. Commit Messages Matter

auto-release.yml respects commit message format:
- Patch: `chore: Bump version to X.Y.Z`
- Minor: `feat: Bump version to X.Y.Z`
- Major: `feat!: Bump version to X.Y.Z`

(Automatically created by `make release-*`)

---

## Integration Points

### With Git

- ✅ Commits on main trigger auto-release
- ✅ Git tags created automatically
- ✅ No manual tag management needed

### With GitHub Actions

- ✅ auto-release.yml: Detects version change
- ✅ release.yml: Creates release
- ✅ Both workflows coordinate seamlessly

### With Make Commands

- ✅ `make release-patch/minor/major`: Trigger auto-release
- ✅ `make release-status`: Monitor progress
- ✅ `make release-check`: Verify readiness

### With GitHub Release

- ✅ Release automatically created
- ✅ All 34 packages uploaded
- ✅ Release notes generated
- ✅ Available immediately after workflow completes

---

## Troubleshooting

### Problem: Release didn't trigger

```bash
# Check if pyproject.toml was actually changed
git diff HEAD~1 pyproject.toml

# Check auto-release workflow
gh run list --workflow=auto-release.yml

# If missing, manually trigger
gh workflow run auto-release.yml
```

### Problem: Release already exists error

```bash
# This is normal if you released same version twice
# Solution: Bump to new version

make release-patch  # Will create v0.0.13 if stuck on v0.0.12
```

### Problem: Workflow stuck

```bash
# Wait up to 30 minutes (normal for first runs)
# Check logs:
gh run view <run-id> --log

# If truly stuck, manually trigger:
gh workflow run release.yml
```

---

## Technical Details

### Workflow Trigger

```yaml
on:
  push:
    branches: [ main ]
    paths:
      - 'pyproject.toml'
```

**Triggers only when:**
- Push to `main` branch
- Changes include `pyproject.toml`

### Version Detection

```bash
VERSION=$(grep -m 1 'version = ' pyproject.toml | sed 's/.*version = "\([^"]*\)".*/\1/')
```

Reads exact version from pyproject.toml.

### Release Check

```bash
gh release view v$VERSION
```

Queries GitHub API to check if release exists.

### Workflow Trigger

```bash
gh workflow run release.yml --repo benzntech/rapidspec-kit --ref main
```

Triggers release.yml if new release needed.

---

## Summary

| Aspect | Benefit |
|--------|---------|
| **Automatic** | No manual release steps |
| **Triggered by version change** | Push and forget |
| **Detects duplicates** | Prevents release mistakes |
| **Full automation** | Packages, release, tags all automatic |
| **Clear status** | GitHub Actions logs everything |
| **Fast** | 1-2 minutes from push to release |
| **Reliable** | Proven workflow, no manual errors |

---

## Next Steps

Simply use `make release-patch` as before:

```bash
make release-patch

# That's it! Everything else is automatic:
# ✓ Version bumped
# ✓ Commit created
# ✓ Pushed to main
# ✓ auto-release.yml detects change
# ✓ release.yml creates release
# ✓ 34 packages generated
# ✓ Release ready in 1-2 minutes
```

**Status: ✅ Completely Automated - Push Version Changes and Release Happens Automatically**
