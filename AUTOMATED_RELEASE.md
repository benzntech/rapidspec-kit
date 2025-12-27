# Automated Release Process

## Quick Start

Make a release with a single command:

```bash
# Bump patch version (0.0.11 → 0.0.12) and trigger release
make release-patch

# Or bump minor version (0.0.11 → 0.1.0)
make release-minor

# Or bump major version (0.1.0 → 1.0.0)
make release-major

# Or set explicit version
make release-version VERSION=1.0.0
```

**That's it!** The workflow handles everything else automatically.

---

## Available Commands

### Release Commands

#### `make release-patch`
Bumps the patch version (X.Y.Z → X.Y.Z+1)

```bash
make release-patch
# 0.0.11 → 0.0.12
# Creates: v0.0.12 release
```

#### `make release-minor`
Bumps the minor version (X.Y.Z → X.Y+1.0)

```bash
make release-minor
# 0.0.11 → 0.1.0
# Creates: v0.1.0 release
```

#### `make release-major`
Bumps the major version (X.Y.Z → X+1.0.0)

```bash
make release-major
# 0.1.0 → 1.0.0
# Creates: v1.0.0 release
```

#### `make release-version VERSION=X.Y.Z`
Sets explicit version number

```bash
make release-version VERSION=0.0.12
# Updates to exactly 0.0.12
# Creates: v0.0.12 release
```

### Status Commands

#### `make release-status`
Shows latest workflow and release status

```bash
make release-status
# Displays:
# - Latest workflow run status
# - Latest GitHub release
# - Created/published timestamps
```

#### `make release-check`
Shows current release readiness

```bash
make release-check
# Displays:
# - Current version
# - Git branch
# - Uncommitted changes
# - Release readiness info
```

### Utility Commands

#### `make help`
Shows all available commands

```bash
make help
# Displays complete command reference
```

#### `make clean`
Cleans build artifacts (optional)

```bash
make clean
# Removes __pycache__, .pyc files, etc.
```

---

## Step-by-Step Release Workflow

### Step 1: Check Status (Optional)
```bash
make release-check
```

Output shows:
- Current version
- Git branch (should be `main`)
- Any uncommitted changes (should be 0)

### Step 2: Bump Version
```bash
# Choose one:
make release-patch     # 0.0.11 → 0.0.12
make release-minor     # 0.0.11 → 0.1.0
make release-major     # 0.1.0 → 1.0.0
```

What happens:
1. ✅ Updates version in `pyproject.toml`
2. ✅ Creates conventional commit
3. ✅ Pushes to origin
4. ✅ Triggers workflow automatically

### Step 3: Monitor Progress (Optional)
```bash
# Check workflow status
make release-status

# Or use GitHub CLI directly
gh run list --workflow=release.yml --limit=1
gh release view v0.0.12
```

### Step 4: Done!
Release is automatically created with:
- ✅ 34 template packages (17 models × 2 scripts)
- ✅ GitHub release with all assets
- ✅ Git tag synchronized
- ✅ Release notes generated

---

## Examples

### Example 1: Patch Release

```bash
# Current: 0.0.11
make release-patch

# Output:
# Bumping patch version...
# ✓ Updated pyproject.toml
# ✓ Created commit
# ✓ Pushed to origin
# ✓ Workflow triggered automatically
#
# Release v0.0.12 is being prepared
# Next steps:
#   1. Wait for workflow to complete (1-2 minutes)
#   2. Check status: gh run list --workflow=release.yml --limit=1
#   3. View release: gh release view v0.0.12
```

### Example 2: Minor Release

```bash
# Current: 0.0.11
make release-minor

# Creates: 0.1.0
# Commit message: "feat: Bump version to 0.1.0"
# Release type: Feature release (minor)
```

### Example 3: Major Release

```bash
# Current: 0.1.0
make release-major

# Creates: 1.0.0
# Commit message: "feat!: Bump version to 1.0.0"
# Release type: Major release (breaking changes)
```

### Example 4: Explicit Version

```bash
# Set exact version
make release-version VERSION=2.0.0

# Creates: 2.0.0 exactly
# Useful for special releases (RC, beta, etc.)
```

---

## Implementation Details

### Scripts Involved

#### `scripts/bump-version.sh`
- **Purpose:** Automate version bumping
- **Location:** `/scripts/bump-version.sh`
- **Features:**
  - Version calculation (patch/minor/major)
  - Validation (format, direction)
  - Conventional commit creation
  - Workflow triggering
  - Status reporting

#### `Makefile`
- **Purpose:** Provide easy commands
- **Location:** `/Makefile`
- **Commands:** All `make release-*` and `make release-*`

### Workflow Integration

When you run `make release-patch`:

```
1. Makefile calls scripts/bump-version.sh patch
2. Script updates pyproject.toml
3. Script commits changes
4. Script pushes to origin
5. GitHub detects push
6. release.yml workflow triggers
7. Workflow reads version from pyproject.toml
8. Workflow generates packages
9. Workflow creates release
10. Workflow syncs git tags
11. Done! Release available in 1-2 minutes
```

---

## Error Handling

### Problem: "Not in a git repository"

**Cause:** Command run outside git repo

**Solution:**
```bash
cd /path/to/rapidspec-kit
make release-patch
```

### Problem: "pyproject.toml not found"

**Cause:** Running from wrong directory

**Solution:**
```bash
# Must be in project root
cd /path/to/rapidspec-kit
make release-patch
```

### Problem: "New version is older than current version"

**Cause:** Trying to bump to version less than current

**Solution:**
```bash
# Can't go: 0.0.12 → 0.0.11
# Instead:
make release-patch  # 0.0.11 → 0.0.12
```

### Problem: "New version is same as current version"

**Cause:** Version already released

**Solution:**
```bash
# Check current: make release-check
# Then bump: make release-patch
```

---

## Git Integration

### What Gets Committed

When you run `make release-patch`, this commit is created:

```
commit a1b2c3d
Author: Your Name <your@email.com>
Date:   Fri Dec 27 14:15:00 2025 +0000

    chore: Bump version to 0.0.12

    Patch release with bug fixes and improvements.
```

**Commit message format:**
- Patch: `chore: Bump version to X.Y.Z`
- Minor: `feat: Bump version to X.Y.Z`
- Major: `feat!: Bump version to X.Y.Z`

Follows [Conventional Commits](https://www.conventionalcommits.org/) format.

### Git Tags

**Automatic tag creation:**
- After release is created, tag `v0.0.12` is created
- No manual `git tag` command needed
- Tag is automatically pushed to remote

**Verify tag:**
```bash
git tag -l | grep v0.0.12
git show v0.0.12
```

---

## Workflow Example: Full Release Cycle

### Before Release
```bash
$ make release-check
Current Version: 0.0.11
Git Branch: main
Git Status: 0 files changed
```

### Make Release
```bash
$ make release-patch

→ Updating version: 0.0.11 → 0.0.12
✓ Updated pyproject.toml
✓ Created commit
✓ Pushed to origin
✓ Workflow triggered automatically

Release v0.0.12 is being prepared
Next steps:
  1. Wait for workflow to complete (1-2 minutes)
  2. Check status: gh run list --workflow=release.yml --limit=1
  3. View release: gh release view v0.0.12
```

### Check Status
```bash
$ make release-status
Latest Workflow Run: success - completed

Latest Release: v0.0.12 - Release v0.0.12 - 2025-12-27T14:15:30Z
```

### Download Release
```bash
# View release
gh release view v0.0.12

# Download packages
gh release download v0.0.12 --dir ~/releases/v0.0.12
```

---

## Comparison: Before vs After

### BEFORE (Manual)
```bash
# 1. Edit file manually
vim pyproject.toml
# change version = "0.0.11" to "0.0.12"

# 2. Stage changes
git add pyproject.toml

# 3. Create commit manually
git commit -m "chore: Bump version to 0.0.12"

# 4. Push manually
git push origin main

# 5. Create tag manually
git tag v0.0.12
git push origin v0.0.12

# 6. Wait for workflow
# 7. Check GitHub
# 8. Done (but lots of manual steps)

Time: ~10 minutes
Error risk: High
```

### AFTER (Automated)
```bash
# 1. Single command
make release-patch

# Automatic:
# - Updates pyproject.toml
# - Creates commit
# - Pushes to origin
# - Triggers workflow
# - Generates packages
# - Creates release
# - Syncs git tags
# - Done!

Time: ~5 seconds (setup) + 1-2 minutes (workflow)
Error risk: Very low
```

---

## Advanced Usage

### Custom Version Numbers

```bash
# Release v1.0.0-beta
make release-version VERSION=1.0.0-beta

# Note: Version format must be X.Y.Z or X.Y.Z-suffix
# Invalid: make release-version VERSION=1.0.0-rc+123
```

### Release Only (No Commit)

If you want to release without creating a commit:

```bash
# Manual approach (not recommended):
# 1. Update pyproject.toml manually
# 2. Commit manually
# 3. Push manually
# GitHub Actions will still trigger

# Better: Use the automated approach
make release-patch
```

### Check What Version Would Be

```bash
# Without committing:
grep 'version = ' pyproject.toml
# Output: version = "0.0.11"

# So next patch would be:
# 0.0.12 (if you run: make release-patch)
```

---

## Troubleshooting

### Issue: Command Not Found

```bash
# If you get: make: command not found
# Solution: Install make
# macOS:
brew install make

# Linux:
sudo apt-get install make

# Windows:
# Use WSL or install GNU Make for Windows
```

### Issue: Permission Denied on bump-version.sh

```bash
# Solution: Make script executable
chmod +x scripts/bump-version.sh

# Then try again:
make release-patch
```

### Issue: Workflow Didn't Trigger

```bash
# Check git status:
git status

# Verify push was successful:
git log -1 --oneline origin/main

# If push failed:
git push origin main

# Manually trigger workflow:
gh workflow run release.yml
```

### Issue: Wrong Version Was Released

```bash
# If you released v0.0.13 by mistake but wanted v0.0.12:

# 1. Delete the wrong release
gh release delete v0.0.13 --yes

# 2. Delete the git tag
git tag -d v0.0.13
git push origin :v0.0.13

# 3. Fix pyproject.toml back to previous version
# (edit manually or revert commit)
git revert <commit-hash>

# 4. Try again with correct version
make release-version VERSION=0.0.12
```

---

## Best Practices

### 1. Always Check Status First
```bash
make release-check
# Verify current version and git branch
```

### 2. Use Appropriate Release Type
- **Patch**: Bug fixes, small improvements
- **Minor**: New features (backwards compatible)
- **Major**: Breaking changes, major updates

### 3. Commit Related Changes First
```bash
# Make sure all related changes are committed
git status  # Should show "nothing to commit"

# Then release
make release-patch
```

### 4. Monitor Workflow
```bash
# After release, check status
make release-status

# Or watch it in real-time
gh run watch --workflow=release.yml
```

### 5. Document Release Notes
For major releases, update release notes:
```bash
# Edit release notes (optional)
gh release edit v0.0.12 --notes "Release notes here"
```

---

## Integration with CI/CD

The automated release process integrates seamlessly with GitHub Actions:

1. **Local:** You run `make release-patch`
2. **Push:** Changes pushed to origin
3. **Trigger:** GitHub Actions workflow starts automatically
4. **Build:** Generates 34 template packages
5. **Create:** Creates GitHub release with assets
6. **Tag:** Syncs git tags

No manual GitHub Actions trigger needed!

---

## FAQ

### Q: Can I release multiple times in a day?

**A:** Yes! Each release bumps the version automatically.

```bash
make release-patch  # v0.0.11 → v0.0.12
# ... (workflow completes)
make release-patch  # v0.0.12 → v0.0.13
```

### Q: What if I commit something after release?

**A:** Just release again:

```bash
make release-patch  # v0.0.11 → v0.0.12
# ... new work ...
git commit -m "fix: Bug fix"
make release-patch  # v0.0.12 → v0.0.13
```

### Q: Can I skip the workflow?

**A:** No, but you don't need to - it's automatic!

The workflow always runs when you push to main with version changes.

### Q: How do I revert a release?

**A:** Delete release and git tag:

```bash
gh release delete v0.0.12 --yes
git tag -d v0.0.12
git push origin :v0.0.12
```

Then bump to previous version and re-release.

### Q: Do I need to be on main branch?

**A:** The script checks but doesn't enforce it. Best practice: always release from `main`.

```bash
git checkout main
make release-patch
```

---

## Related Documentation

- [RELEASE_PROCESS.md](RELEASE_PROCESS.md) - Detailed release workflow docs
- [PERMANENT_RELEASE_SOLUTION.md](PERMANENT_RELEASE_SOLUTION.md) - Technical implementation
- [Makefile](Makefile) - Release command definitions
- [scripts/bump-version.sh](scripts/bump-version.sh) - Automation script

---

## Summary

**Old way (manual):**
```bash
vim pyproject.toml && git add . && git commit -m "..." && git push && git tag v0.0.12 && git push origin v0.0.12
# Many steps, error-prone, takes ~10 minutes
```

**New way (automated):**
```bash
make release-patch
# One command, reliable, takes ~5 seconds
```

**The workflow handles everything else automatically!**
