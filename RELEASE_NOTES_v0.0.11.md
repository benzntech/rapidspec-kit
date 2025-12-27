# RapidSpec v0.0.11 Release Notes

**Release Date:** 2025-12-27  
**Previous Version:** v0.0.10  
**Status:** Stable

## Overview

RapidSpec v0.0.11 adds full project path support to init guides and creates the `.rapidspec/changes/` folder for proposal storage.

## What's New

### 1. Project Path in Init Guides ✅

All 17 model-specific initialization guides now display the full project path:

```
This project was initialized with **Claude Code** on 2025-12-27 13:47:33.

**Project Location:** `/Volumes/External/bensonmac/tmp/test-project-path`
```

**Benefits:**
- Users know exactly where their project was created
- Full path available for reference in commands
- Works across all 17 AI models
- Automatically populated during init

### 2. Create `.rapidspec/changes/` Folder ✅

The `changes/` folder is now created during `rapidspec init`:

```
.rapidspec/
├── memory/                  ← Memory bank (6 files)
├── changes/                 ← NEW - Proposals storage
├── scripts/                 ← Generated scripts
└── templates/               ← All templates
```

**Purpose:**
- Ready for `/rapidspec.proposal` command
- Stores proposal specs and change tracking
- Only created when agent folders exist
- Organized structure for development workflow

## Technical Changes

### Modified Files

**1. `pyproject.toml`**
- Version: 0.0.10 → 0.0.11

**2. `src/specify_cli/__init__.py`**
- Updated `create_model_init_guide()` function
  - Added `[PROJECT_PATH]` placeholder replacement (line 1135)
  - Gets full resolved path of project directory
- Added `create_changes_folder()` function (lines 1151-1177)
  - Creates `.rapidspec/changes/` directory
  - Only if `.rapidspec/` exists
  - Reports status via tracker

**3. `templates/init-docs/*.md` (All 17 files)**
- Added `**Project Location:** [PROJECT_PATH]` line
- Displays in all generated init guides

### Commits in This Release

- `256c57e` - feat: Create .rapidspec/changes folder during init
- Previous commits from v0.0.10

## Breaking Changes

None. This is a backward-compatible release.

## Deprecations

None.

## Known Issues

None reported.

## Installation

```bash
# Update via pip
pip install --upgrade rapidspec-cli

# Or install directly from GitHub
pip install git+https://github.com/benzntech/rapidspec-kit.git@v0.0.11
```

## Upgrade Guide

If upgrading from v0.0.10 to v0.0.11:

1. Update the CLI: `pip install --upgrade rapidspec-cli`
2. No changes needed to existing projects
3. New projects will display full project path in init guides
4. New projects will have `.rapidspec/changes/` folder ready for proposals

## Verification

Tested on:
- ✅ macOS (Apple Silicon and Intel)
- ✅ All 17 AI models
- ✅ Project path replacement in all guides
- ✅ Changes folder creation
- ✅ Path resolution (relative and absolute)

## Release Assets

- `rapidspec-template-claude-sh-v0.0.11.zip` (with project path)
- `rapidspec-template-claude-ps-v0.0.11.zip` (with project path)
- ... (34 total packages, 17 models × 2 script types)

All packages include:
- Updated init guides with project location display
- Changes folder structure ready for proposals
- Complete memory bank system
- All agent templates

## Project Structure After Init

```
/path/to/project/
├── .claude/                       ← Agent folder
├── .rapidspec/
│   ├── memory/                    ← Memory bank (6 files)
│   │   ├── constitution.md
│   │   ├── productContext.md
│   │   ├── activeContext.md
│   │   ├── systemPatterns.md
│   │   ├── decisionLog.md
│   │   └── progress.md
│   ├── changes/                   ← Proposals storage (NEW)
│   ├── scripts/                   ← Generated scripts
│   └── templates/                 ← All templates
├── CLAUDE.md                      ← Init guide with project path
└── ... (other project files)
```

## Example Init Guide Output

```markdown
# Claude Code - RapidSpec Quick Start

This project was initialized with **Claude Code** on 2025-12-27 13:47:33.

**Project Location:** `/Users/name/projects/my-app`

**Note:** The `.rapidspec/` folder with memory bank and configuration files has been created in this directory.
```

## Next Steps

For v0.0.12 and beyond:

1. Web UI dashboard for memory bank visualization
2. IDE extensions (VS Code, JetBrains)
3. Performance optimizations for large projects
4. Enhanced error messages and debugging
5. Proposal template improvements

## Questions & Support

- **GitHub Issues:** https://github.com/benzntech/rapidspec-kit/issues
- **Documentation:** https://github.com/benzntech/rapidspec-kit#readme
- **Discussions:** https://github.com/benzntech/rapidspec-kit/discussions

---

**Changelog:** [View all releases](https://github.com/benzntech/rapidspec-kit/releases)

*RapidSpec v0.0.11 - Better project context and proposal workflow*
