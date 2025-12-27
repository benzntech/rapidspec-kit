# RapidSpec v0.0.12 Release Notes

**Release Date:** 2025-12-27  
**Previous Version:** v0.0.11  
**Status:** Stable

## Overview

RapidSpec v0.0.12 introduces automatic UV (Python package manager) version checking and auto-update during project initialization. This ensures users always have the latest UV version before setting up RapidSpec projects.

## What's New

### 1. Automatic UV Version Checking & Auto-Update ✅

The init command now automatically checks if UV is installed and up-to-date:

```bash
specify init my-project

# Output during initialization:
# uv-check          → Check UV package manager
#                     ✓ Updated to v0.1.9
```

**Features:**
- **Version Detection**: Gets current UV version via `uv --version`
- **Latest Version Check**: Queries GitHub API for latest release
- **Automatic Update**: Runs `uv self update` if outdated
- **Non-Blocking**: Init continues even if UV check fails
- **Full Feedback**: Status shown in StepTracker UI

### 2. Intelligent Version Comparison

Version comparison handles all scenarios:

- **Outdated**: v0.1.5 < v0.1.9 → Auto-updates
- **Current**: v0.1.9 = v0.1.9 → Continues immediately
- **Newer**: v0.1.10 > v0.1.9 → Continues (development builds)

Comparison algorithm converts X.Y.Z to integers for reliability:
```
0.1.5 → 000001005
1.2.3 → 001002003
```

### 3. GitHub API Integration

Latest UV version fetched from public API:
```
https://api.github.com/repos/astral-sh/uv/releases/latest
```

Benefits:
- Single source of truth for latest version
- No authentication required (public API)
- 5-second timeout for reliability
- Graceful fallback if API unavailable

### 4. Comprehensive Documentation

New documentation file: `docs/UV_AUTO_UPDATE.md`

**Covers:**
- How the feature works
- Implementation details
- Version comparison logic
- API integration
- Error handling and troubleshooting
- Performance impact analysis
- Future enhancements

## Technical Implementation

### New Functions in `src/specify_cli/__init__.py`

**`check_uv_version(tracker: StepTracker | None) -> bool`**
- Checks if UV is installed in system PATH
- Detects current version
- Fetches latest from GitHub API
- Auto-updates if outdated via `uv self update`
- Returns True if available/updated, False if failed

**`_compare_versions(current: str, latest: str) -> str`**
- Compares two semantic version strings
- Returns: "outdated", "current", or "newer"
- Handles edge cases and version formatting

### Integration Points

- **Init Command**: UV check runs early in initialization
- **StepTracker**: "uv-check" step added to progress tracking
- **Error Handling**: Non-blocking design ensures init succeeds even if UV check fails
- **Timeouts**: 5s for version check, 5s for API call, 30s for update

## Behavior

### When UV is Up-to-Date

```bash
$ specify init my-project --ai claude

Initialize Specify Project
├─ precheck                     ✓ ok
├─ uv-check                     ✓ v0.1.9 (up-to-date)
├─ ai-select                    ✓ claude
├─ script-select                ✓ sh
└─ ... (continues with template download)
```

**Result:** Continues immediately, no delay

### When UV is Outdated

```bash
$ specify init my-project --ai claude

Initialize Specify Project
├─ precheck                     ✓ ok
├─ uv-check                     ✓ Updated to v0.1.10
├─ ai-select                    ✓ claude
├─ script-select                ✓ sh
└─ ... (continues with template download)
```

**Result:** Auto-updates UV, then continues

### When UV is Not Installed

```bash
$ specify init my-project --ai claude

Initialize Specify Project
├─ precheck                     ✓ ok
├─ uv-check                     ⚠ UV not installed
├─ ai-select                    ✓ claude
├─ script-select                ✓ sh
└─ ... (continues with template download)
```

**Result:** Logs warning, continues (non-blocking)

## Performance Impact

- **Network call**: ~1-2 seconds to GitHub API
- **Local checks**: <100ms for version detection
- **Update operation**: ~5-30 seconds (if update needed)
- **Total impact**: 
  - Up-to-date: +2-5 seconds
  - Needs update: +10-35 seconds

All operations have timeouts to prevent hanging:
- Version check: 5 seconds
- GitHub API: 5 seconds
- Update: 30 seconds

## Files Changed

### Modified

- **pyproject.toml**
  - Version: 0.0.11 → 0.0.12

- **src/specify_cli/__init__.py** (+122 lines)
  - Added `check_uv_version()` function
  - Added `_compare_versions()` utility
  - Updated init command to call UV check
  - Added "uv-check" to StepTracker

### Added

- **docs/UV_AUTO_UPDATE.md** (237 lines)
  - Comprehensive feature documentation
  - Implementation details
  - Troubleshooting guide
  - Performance analysis
  - Future enhancements

- **.github/workflows/scripts/check-uv-version.sh** (150 lines)
  - Standalone UV checking script
  - Reference implementation for shell

## Breaking Changes

None. This is a fully backward-compatible release.

## Deprecations

None.

## Known Issues

None reported.

## Installation

### Update Existing Installation

```bash
# Via pip
pip install --upgrade rapidspec-cli

# Via uv
uv tool install --upgrade rapidspec-cli

# Via GitHub
pip install --upgrade git+https://github.com/benzntech/rapidspec-kit.git@v0.0.12
```

### Fresh Installation

```bash
# Via pip
pip install rapidspec-cli

# Via uv
uv tool install rapidspec-cli --from git+https://github.com/benzntech/rapidspec-kit.git@v0.0.12

# Via homebrew (if available)
brew install rapidspec-cli
```

## Upgrade Guide

If upgrading from v0.0.11 to v0.0.12:

1. **Update the CLI**:
   ```bash
   pip install --upgrade rapidspec-cli
   ```

2. **No changes needed for existing projects**
   - Your existing RapidSpec projects will work as-is
   - UV checking only applies to new `specify init` commands

3. **New projects will have UV checking**
   - When you run `specify init my-new-project`, UV will be auto-checked and updated
   - Existing projects are unaffected

## Verification

Tested on:
- ✅ macOS (Apple Silicon and Intel)
- ✅ Python 3.11+
- ✅ UV auto-detection
- ✅ GitHub API connectivity
- ✅ Update mechanism
- ✅ Error handling and timeouts
- ✅ Non-blocking behavior

## Release Assets

All packages include:
- UV auto-check functionality
- Updated init command
- Comprehensive documentation
- All 17 AI model templates
- Complete memory bank system

## Roadmap for Future Releases

### v0.0.13
- Web UI dashboard for memory bank
- Offline mode for UV checks
- Update notifications without auto-updates

### v0.1.0
- IDE extensions (VS Code, JetBrains)
- Performance optimizations
- Enhanced error messages

### v0.2.0
- Web-based project initialization UI
- Cloud-based template management
- Collaborative memory bank features

## Questions & Support

- **GitHub Issues**: https://github.com/benzntech/rapidspec-kit/issues
- **Documentation**: https://github.com/benzntech/rapidspec-kit#readme
- **Discussions**: https://github.com/benzntech/rapidspec-kit/discussions
- **Feature Guide**: See `docs/UV_AUTO_UPDATE.md`

## Contributors

This release includes contributions focused on improving the initialization experience and package manager integration.

## Changelog

### Features
- Add automatic UV version checking during init
- Add UV auto-update functionality
- Add version comparison utility
- Add UV feature documentation

### Improvements
- Better init feedback with UV status
- More robust error handling in init
- GitHub API integration for version info

### Documentation
- New `docs/UV_AUTO_UPDATE.md` guide
- Updated init documentation
- Added troubleshooting section

---

**RapidSpec v0.0.12 - Automatic Package Manager Updates**

*Better developer experience through automatic dependency management.*

Release date: 2025-12-27  
Status: Stable
