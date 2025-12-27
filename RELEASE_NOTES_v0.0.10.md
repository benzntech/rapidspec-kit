# RapidSpec v0.0.10 Release Notes

**Release Date:** 2025-12-27  
**Previous Version:** v0.0.9  
**Status:** Stable

## Overview

RapidSpec v0.0.10 includes documentation improvements for init guides and strict enforcement of `.rapidspec/` folder creation only when agent folders exist.

## What's New

### 1. Init Guide Documentation ✅

All 17 model-specific initialization guides now include a clear note about `.rapidspec/` folder creation:

```
**Note:** The `.rapidspec/` folder with memory bank and configuration files has been created in this directory.
```

This clarifies:
- Where the `.rapidspec/` folder is created (current directory where `rapidspec init` is run)
- Memory bank files are stored in `.rapidspec/memory/` (internal, not at root)
- All files are auto-populated and ready to use

**Updated Guides:**
- CLAUDE.md - Claude Code quick start
- GEMINI.md - Gemini CLI quick start
- COPILOT.md - GitHub Copilot quick start
- CURSOR.md - Cursor quick start
- QWEN.md - Qwen Code quick start
- OPENCODE.md - OpenAI Code quick start
- CODEX.md - Codex quick start
- WINDSURF.md - Windsurf quick start
- KILOCODE.md - Kilo Code quick start
- AUGGIE.md - IBM Auggie quick start
- CODEBUDDY.md - CodeBuddy quick start
- QODER.md - QODer quick start
- ROO.md - Roo Code quick start
- AMAZONQ.md - Amazon Q quick start
- AMP.md - AMP quick start
- SHAI.md - SHAI quick start
- BOB.md - IBM Bob quick start

### 2. Strict Agent Folder Check ✅

The `rapidspec init` command now enforces strict logic:

**`.rapidspec/` folder is ONLY created if agent folders exist:**
- `.claude/` OR
- `.gemini/` OR
- `.github/` (Copilot) OR
- `.cursor/` OR
- `.qwen/` OR
- `.opencode/` OR
- `.codex/` OR
- `.windsurf/` OR
- `.kilocode/` OR
- `.augment/` OR
- `.codebuddy/` OR
- `.qoder/` OR
- `.roo/` OR
- `.q/` OR
- `.shai/` OR
- `.bob/` OR
- `.amp/`

**If NO agent folders exist:**
- `.rapidspec/` folder is NOT created
- Memory bank initialization is skipped
- Init-guide creation is skipped
- Both show as "skipped" in the output

**Behavior:**
```
If agent folders present:
├── ● Initialize memory bank (6/6 files populated) ✅
├── ● Create model-specific guide (MODEL.md created) ✅

If NO agent folders:
├── ○ Initialize memory bank (skipped - no agent folders found)
├── ○ Create model-specific guide (skipped - no agent folders found)
```

## Technical Changes

### Modified Files

**1. `pyproject.toml`**
- Version: 0.0.9 → 0.0.10

**2. `templates/init-docs/*.md` (All 17 files)**
- Added single-line documentation about `.rapidspec/` folder creation
- Clarifies that memory bank is stored in `.rapidspec/memory/`

**3. `src/specify_cli/__init__.py`**
- Updated `auto_populate_memory_bank()` function
  - Added agent folder existence check (lines 981-994)
  - Skip if no agent folders found
- Updated `create_model_init_guide()` function
  - Added agent folder existence check (lines 1074-1083)
  - Skip if no agent folders found

## Commits in This Release

- `a0f9db4` - docs: Add note to all init guides about .rapidspec folder creation
- `35c7178` - feat: Only create .rapidspec folder if agent folders exist
- `0da3bd7` - docs: Add complete memory bank with session analysis and decision log

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
pip install git+https://github.com/benzntech/rapidspec-kit.git@v0.0.10
```

## Upgrade Guide

If upgrading from v0.0.9 to v0.0.10:

1. Update the CLI: `pip install --upgrade rapidspec-cli`
2. No changes needed to existing projects
3. New projects will use the updated init guides with documentation

## Verification

Tested on:
- ✅ macOS (Apple Silicon and Intel)
- ✅ All 17 AI models
- ✅ Both `sh` and `ps` script types
- ✅ Agent folder detection logic
- ✅ Memory bank auto-population

## Release Assets

- `rapidspec-template-claude-sh-v0.0.10.zip` (with updated guides)
- `rapidspec-template-claude-ps-v0.0.10.zip` (with updated guides)
- ... (34 total packages, 17 models × 2 script types)

All packages include:
- Updated init guides with `.rapidspec/` documentation
- Complete memory bank system
- All agent templates
- Configuration and scripts

## Special Notes

### Memory Bank Location

Projects initialized with v0.0.10 will have:

```
project-root/
├── .rapidspec/
│   ├── memory/                 ← Memory bank files
│   │   ├── constitution.md
│   │   ├── productContext.md
│   │   ├── activeContext.md
│   │   ├── systemPatterns.md
│   │   ├── decisionLog.md
│   │   └── progress.md
│   └── templates/
│       └── ... (all templates)
├── CLAUDE.md (or GEMINI.md, etc)
└── ... (other project files)
```

Memory files are stored in `.rapidspec/memory/` for organization and discoverability within the project structure.

## Credits

- Init guide documentation updates
- Strict agent folder validation
- Memory bank system refinements

## Next Steps

For v0.0.11 and beyond:

1. Web UI dashboard for memory bank visualization
2. IDE extensions (VS Code, JetBrains)
3. Performance optimizations for large projects
4. Enhanced error messages and debugging

## Questions & Support

- **GitHub Issues:** https://github.com/benzntech/rapidspec-kit/issues
- **Documentation:** https://github.com/benzntech/rapidspec-kit#readme
- **Discussions:** https://github.com/benzntech/rapidspec-kit/discussions

---

**Changelog:** [View all releases](https://github.com/benzntech/rapidspec-kit/releases)

*RapidSpec v0.0.10 - Specification-first development made simple*
