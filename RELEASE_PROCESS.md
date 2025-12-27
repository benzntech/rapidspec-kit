# RapidSpec Release Process

## Overview

This document describes the **permanent solution** for RapidSpec-Kit releases. The process ensures that:
- Releases are always triggered by version updates in `pyproject.toml`
- Git tags stay synchronized with releases
- Template packages are automatically generated
- No manual tag creation is needed

## Key Principle: Single Source of Truth

**`pyproject.toml` is the source of truth for version numbers.**

The release workflow:
1. Reads the version from `pyproject.toml`
2. Checks if a release exists for that version
3. If not, creates the release and all assets
4. Automatically synchronizes git tags

## Release Workflow

### Automatic Release Trigger

The workflow is triggered automatically when you push changes to `main` that affect:
- `memory/**` - Memory bank documentation
- `scripts/**` - Release scripts
- `templates/**` - Template files
- `.github/workflows/**` - Workflow definitions

### Manual Release Trigger

To trigger the workflow manually without code changes:
```bash
gh workflow run release.yml --repo benzntech/rapidspec-kit
```

## Making a Release

### Step 1: Update Version in `pyproject.toml`

```bash
# Edit pyproject.toml
vim pyproject.toml

# Change the version line:
# Before: version = "0.0.10"
# After:  version = "0.0.11"
```

### Step 2: Commit and Push

```bash
git add pyproject.toml
git commit -m "chore: Bump version to 0.0.11"
git push origin main
```

### Step 3: Workflow Runs Automatically

The GitHub Actions workflow will:
1. ✅ Read version from `pyproject.toml` (0.0.11)
2. ✅ Check if release v0.0.11 exists
3. ✅ Generate 34 template packages (17 models × 2 script types)
4. ✅ Create GitHub release with all assets
5. ✅ Create/sync git tag v0.0.11
6. ✅ Update version in documentation

**That's it!** No manual tag creation needed.

## Workflow Components

### Scripts

#### `get-next-version.sh` (IMPROVED)

**Purpose:** Read version from `pyproject.toml`

**What it does:**
- Reads version from `pyproject.toml` (single source of truth)
- Validates version format (X.Y.Z)
- Outputs version info for GitHub Actions
- No longer calculates versions from git tags

**Why improved:**
- Previous version: Incremented from git tags (could miss versions)
- New version: Always reads from `pyproject.toml`
- Prevents version mismatch issues

#### `sync-git-tags.sh` (NEW)

**Purpose:** Keep git tags synchronized with releases

**What it does:**
- Takes version tag (e.g., v0.0.11) as argument
- Checks if tag exists locally
- Creates tag if missing
- Pushes tag to remote
- Reports sync status

**Why needed:**
- Workflow now reads from `pyproject.toml`, not git tags
- This ensures git tags are created after releases
- Prevents manual tag creation overhead

#### `check-release-exists.sh`

**Purpose:** Avoid duplicate releases

**What it does:**
- Queries GitHub API for existing release
- Returns `exists=true` or `exists=false`
- Skips package generation if release exists

#### `create-release-packages.sh`

**Purpose:** Generate template packages

**What it does:**
- Creates 17 model-specific template directories
- For each model: creates `.sh` and `.ps` (PowerShell) variants
- Generates 34 ZIP files total
- Stores in `.genreleases/` directory

#### `create-github-release.sh`

**Purpose:** Create GitHub release and upload assets

**What it does:**
- Creates GitHub release for version tag
- Uploads all 34 template packages as assets
- Sets release as "Latest" if applicable
- Publishes release notes

## Permanent Solution Benefits

### Problem: Version Mismatch

**Before (BROKEN):**
```
┌─────────────────────┐
│ pyproject.toml      │
│ version = "0.0.11"  │ ← You update this
└─────────────────────┘
              ↓ (ignored)
┌─────────────────────┐
│ Workflow reads from │
│ git tags            │ ← Latest tag was v0.0.9
│ Calculates v0.0.10  │ ← Wrong!
└─────────────────────┘
              ↓
Result: Release skipped, no packages generated
```

**After (FIXED):**
```
┌─────────────────────┐
│ pyproject.toml      │
│ version = "0.0.11"  │ ← Single source of truth
└─────────────────────┘
              ↓ (always read first)
┌─────────────────────┐
│ Workflow reads from │
│ pyproject.toml      │
│ Uses v0.0.11        │ ← Correct!
└─────────────────────┘
              ↓
┌─────────────────────┐
│ Generate 34 packages│
│ Create release      │
│ Sync git tag        │
└─────────────────────┘
Result: Complete release with all assets
```

### Benefits

1. **Single Source of Truth**: Version lives in `pyproject.toml` only
2. **Automatic Tag Sync**: Git tags created automatically after release
3. **No Manual Steps**: No need to manually create git tags
4. **Version Validation**: Workflow validates version format
5. **Clear Logging**: Workflow logs show what version was used and why
6. **Prevents Duplicates**: Won't create release if one already exists

## Troubleshooting

### Release didn't generate packages

**Possible causes:**

1. **Release already exists**
   - Check: `gh release view v0.0.11`
   - If release exists but has no assets, delete and re-run workflow
   ```bash
   gh release delete v0.0.11 --yes
   git tag -d v0.0.11
   git push origin :v0.0.11
   gh workflow run release.yml
   ```

2. **Version format is invalid**
   - Check: `grep version pyproject.toml`
   - Must be `version = "X.Y.Z"` format
   - Example: `version = "0.0.11"` ✅
   - Wrong: `version = "0.0.11-rc1"` ❌

3. **Workflow didn't trigger**
   - Workflow only triggers on changes to watched paths:
     - `memory/**`
     - `scripts/**`
     - `templates/**`
     - `.github/workflows/**`
   - Alternative: Manually trigger with `gh workflow run release.yml`

### Git tag not synchronized

**Solution:**
```bash
# Manually run the tag sync script
.github/workflows/scripts/sync-git-tags.sh v0.0.11

# Or manually create and push
git tag v0.0.11
git push origin v0.0.11
```

## Version Bumping Examples

### Patch Release (0.0.10 → 0.0.11)
```bash
# Edit pyproject.toml
sed -i 's/version = "0.0.10"/version = "0.0.11"/' pyproject.toml

# Commit
git add pyproject.toml
git commit -m "chore: Bump version to 0.0.11"
git push origin main
```

### Minor Release (0.0.11 → 0.1.0)
```bash
# Edit pyproject.toml
sed -i 's/version = "0.0.11"/version = "0.1.0"/' pyproject.toml

# Commit
git add pyproject.toml
git commit -m "feat: Bump to 0.1.0 with new features"
git push origin main
```

### Major Release (0.1.0 → 1.0.0)
```bash
# Edit pyproject.toml
sed -i 's/version = "0.1.0"/version = "1.0.0"/' pyproject.toml

# Commit
git add pyproject.toml
git commit -m "feat!: Release 1.0.0 - Production ready"
git push origin main
```

## Workflow Steps Explained

When you push to `main`, the workflow does this:

```
1. Checkout code
   ↓
2. Read version from pyproject.toml (e.g., 0.0.11)
   ↓
3. Check if release v0.0.11 already exists
   ├─ If yes: Stop (already released)
   └─ If no: Continue to step 4
   ↓
4. Generate 34 template packages
   - 17 models (claude, gemini, copilot, etc.)
   - 2 script types (sh, ps)
   - Total: 17 × 2 = 34 ZIP files
   ↓
5. Create GitHub release v0.0.11
   - Upload all 34 packages as assets
   - Set as "Latest" release
   ↓
6. Synchronize git tag v0.0.11
   - Create tag if missing
   - Push to remote
   ↓
7. Done! Release is ready for download
```

## Release Checklist

Before releasing, verify:

- [ ] Version updated in `pyproject.toml`
- [ ] Changes committed to `main` branch
- [ ] Changes pushed to remote
- [ ] All tests passing (if applicable)
- [ ] Release notes prepared (if major/minor release)

The workflow handles the rest automatically.

## FAQ

### Q: Do I need to create git tags manually?

**A:** No! The workflow creates tags automatically via `sync-git-tags.sh`.

### Q: What if I update `pyproject.toml` but don't push?

**A:** Workflow won't trigger. You must commit and push to `main`.

### Q: Can I release the same version twice?

**A:** No. Workflow checks if release exists and skips if it does.

### Q: What if version format is wrong (e.g., "1.0.0-alpha")?

**A:** Workflow fails with clear error message. Fix the format and try again.

### Q: How do I re-release if something goes wrong?

**A:** Delete the release and git tag, then trigger workflow again:
```bash
gh release delete v0.0.11 --yes
git tag -d v0.0.11
git push origin :v0.0.11
gh workflow run release.yml
```

## Workflow Configuration

Location: `.github/workflows/release.yml`

**Trigger:** Automatic on push to `main` with changes to:
- `memory/**`
- `scripts/**`
- `templates/**`
- `.github/workflows/**`

**Manual trigger:**
```bash
gh workflow run release.yml
```

**Permissions:**
- `contents: write` - Create releases and tags
- `pull-requests: write` - For future PR integrations

## Scripts Location

All workflow scripts are in `.github/workflows/scripts/`:

- `get-next-version.sh` - Read version from pyproject.toml
- `sync-git-tags.sh` - Synchronize git tags
- `check-release-exists.sh` - Check if release already exists
- `create-release-packages.sh` - Generate template packages
- `generate-release-notes.sh` - Create release notes
- `create-github-release.sh` - Create GitHub release
- `update-version.sh` - Update documentation versions

## Related Documentation

- [Quick Start](CLAUDE.md) - User-facing quick start guide
- [Release Notes](RELEASE_NOTES_v0.0.11.md) - Latest release notes
- [GitHub Workflows](/.github/workflows) - All CI/CD workflows
