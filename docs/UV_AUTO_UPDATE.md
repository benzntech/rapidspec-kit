# UV Auto-Update Feature

## Overview

RapidSpec now automatically checks and updates UV (the Python package manager) during project initialization. This ensures users always have the latest UV version before setting up their RapidSpec projects.

## How It Works

When you run `specify init`, the initialization process now:

1. **Checks if UV is installed** - Verifies UV is available in the system PATH
2. **Gets current version** - Runs `uv --version` to detect the installed version
3. **Fetches latest version** - Queries GitHub API for the latest UV release
4. **Compares versions** - Intelligently compares X.Y.Z version strings
5. **Auto-updates if outdated** - Automatically runs `uv self update` if a newer version is available
6. **Reports status** - Shows the UV check result in the initialization tracker

## Implementation Details

### Version Comparison

The implementation uses a robust version comparison function that converts semantic versions (X.Y.Z) to integers for comparison:

```
0.1.5 → 000001005
1.2.3 → 001002003
```

This handles all comparison scenarios:
- **Outdated**: Current version < Latest version → Auto-updates
- **Current**: Current version = Latest version → Continues
- **Newer**: Current version > Latest version → Continues (development builds)

### GitHub API Integration

Latest UV version is fetched from:
```
https://api.github.com/repos/astral-sh/uv/releases/latest
```

Features:
- 5-second timeout for reliability
- Graceful fallback if API is unavailable
- No authentication required (public API)

### Auto-Update Command

UV provides a built-in self-update mechanism:
```bash
uv self update
```

This command:
- Downloads the latest UV binary
- Replaces the current installation
- Verifies the update
- Returns exit code 0 on success

## Usage

### During Project Initialization

```bash
# UV check runs automatically
specify init my-project

# Output in tracker:
# uv-check          → Check UV package manager
#                     ✓ Updated to v0.1.9
# 
# (Or if already current)
# uv-check          → Check UV package manager
#                     ✓ v0.1.8 (up-to-date)
```

### Manual UV Update (if needed)

If you want to manually update UV outside of project initialization:

```bash
uv self update
```

## Error Handling

The UV check is designed to be non-blocking:

| Scenario | Behavior |
|----------|----------|
| UV not installed | Error logged, init continues (UV is optional) |
| Network unavailable | Falls back to assuming current version is OK |
| Update times out | Error logged, init continues with current version |
| Update fails | Error logged, init continues with current version |

### Why Non-Blocking?

While UV is the recommended package manager for RapidSpec projects, users can still initialize projects without it. The feature prioritizes successful initialization over forcing a UV update.

## Tracker Integration

The UV check is integrated into RapidSpec's `StepTracker` system:

```
Initialize Specify Project
├─ precheck
├─ uv-check                    ← NEW
│  ├─ v0.1.9 (up-to-date)
│  ├─ Updated to v0.1.9
│  └─ Update failed: [error message]
├─ ai-select
└─ ... (other steps)
```

Status indicators:
- ✓ **Complete**: UV is up-to-date or successfully updated
- ⚠ **Warning**: UV check failed (still proceeds)
- ⏩ **Skip**: UV functionality skipped if not available

## Technical Implementation

### Function: `check_uv_version()`

Located in `src/specify_cli/__init__.py`

**Signature:**
```python
def check_uv_version(tracker: StepTracker | None = None) -> bool:
    """Check if UV is installed and up-to-date. Auto-update if outdated.
    
    Args:
        tracker: Optional StepTracker to update with results
        
    Returns:
        True if UV is available and up-to-date (or successfully updated)
        False if UV is not available or update failed
    """
```

**Parameters:**
- `tracker`: Optional `StepTracker` instance for status updates

**Return Value:**
- `True`: UV is available and current/updated
- `False`: UV unavailable or update failed

### Function: `_compare_versions()`

Utility function for version comparison:

```python
def _compare_versions(current: str, latest: str) -> str:
    """Compare two version strings in X.Y.Z format.
    
    Returns:
        "outdated" if current < latest
        "current" if current == latest
        "newer" if current > latest
    """
```

## Performance Impact

- **Network call**: ~1-2 seconds to GitHub API
- **Local checks**: <100ms for version detection
- **Update operation**: ~5-30 seconds depending on network
- **Total impact**: 2-5 seconds for up-to-date UV, 10-35 seconds if update needed

All operations have timeouts to prevent hanging:
- Version check: 5 seconds
- GitHub API call: 5 seconds
- Update operation: 30 seconds

## Troubleshooting

### UV Check Takes Too Long

If the UV check appears to hang:

1. Check your network connection
2. Verify GitHub API is accessible: `curl https://api.github.com/repos/astral-sh/uv/releases/latest`
3. If network is unreliable, the check will timeout after 5 seconds and continue

### UV Update Failed

If the auto-update fails:

```bash
# Try manual update
uv self update

# Or reinstall UV
# macOS/Linux with homebrew:
brew install astral-sh/uv/uv

# Or using the official installer:
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### UV Not Found After Update

If UV is still not found after auto-update:

1. Close and reopen your terminal
2. Verify UV is installed: `which uv`
3. Check PATH includes UV location: `echo $PATH`

## Configuration

Currently, the UV auto-update feature has no configuration options. Future versions may include:

- `--skip-uv-check` flag for init command
- Configuration file for UV check behavior
- Environment variable to disable checks

## Future Enhancements

Planned improvements for the UV auto-update feature:

1. **Offline mode** - Cache latest version info locally
2. **Scheduled checks** - Check for updates only once per day
3. **Update notifications** - Notify users about available updates without auto-updating
4. **Statistics** - Track update frequency and success rates
5. **IDE integration** - Show UV status in IDE extensions

## References

- **UV Documentation**: https://docs.astral.sh/uv/
- **UV GitHub Repository**: https://github.com/astral-sh/uv
- **UV Installation**: https://astral.sh/uv/install
- **RapidSpec Documentation**: https://github.com/benzntech/rapidspec-kit

---

**Version**: 0.0.11  
**Last Updated**: 2025-12-27  
**Status**: Stable
