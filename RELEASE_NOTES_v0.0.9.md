# RapidSpec v0.0.9 Release Notes

**Release Date:** December 27, 2025  
**Release Tag:** v0.0.9  
**Status:** Stable Release

---

## 🎉 Overview

RapidSpec v0.0.9 is a **bug fix and stability release** that fixes critical issues with model-specific initialization guide generation. This release ensures that all 17 AI models correctly receive their initialization guides during project setup.

**Key Fix:** The `create_model_init_guide()` function now correctly discovers guide templates in the extracted project structure, solving the "template not found" error from v0.0.8.

---

## 🔧 What's Fixed

### 1. Init-Guide Template Discovery Bug (CRITICAL) 🐛

**Problem in v0.0.8:**
- `rapidspec init` showed "Create model-specific guide (template not found: CLAUDE.md)" error
- Templates existed in `.rapidspec/templates/init-docs/` but function couldn't find them
- Function was checking wrong directories: `package_root / "templates"` instead of `project_path / ".rapidspec" / "templates"`
- Result: No CLAUDE.md, GEMINI.md, etc. files created in project root

**Solution in v0.0.9:**
- Improved template discovery logic with correct path checking
- Now checks `project_path / ".rapidspec" / "templates" / "init-docs"` **FIRST** (where templates are actually extracted)
- Added fallback to `package_root / "templates" / "init-docs"` (installed package location)
- **Result:** All 17 AI models now correctly create their initialization guides

**Before:**
```bash
$ rapidspec init my-project --ai claude
...
├── ○ Create model-specific guide (template not found: CLAUDE.md)  ❌
...
$ ls my-project/
.claude
.rapidspec
perplexity-mcp-zerver
# ❌ No CLAUDE.md file!
```

**After:**
```bash
$ rapidspec init my-project --ai claude
...
├── ● Create model-specific guide (CLAUDE.md created)  ✅
...
$ ls my-project/
CLAUDE.md      ✅ 14 KB - Claude Code quick start guide
.claude
.rapidspec
perplexity-mcp-zerver
```

### 2. Path Discovery Improvements

**Enhanced path checking strategy:**
1. **Primary:** `project_path / ".rapidspec" / "templates" / "init-docs" / template.md` ← Most reliable
2. **Fallback:** `package_root / "templates" / "init-docs" / template.md` ← Package installation
3. **Result:** Works in all scenarios (fresh init, --here, package install)

**Code changes:**
```python
# OLD (v0.0.8) - BROKEN
cli_dir = Path(__file__).parent
package_root = cli_dir.parent.parent
template_path = package_root / "templates" / "init-docs" / template_filename
if not template_path.exists():
    # Try alternatives... but doesn't include project path!
    ...

# NEW (v0.0.9) - FIXED
search_paths = [
    # First: Check project's extracted templates
    project_path / ".rapidspec" / "templates" / "init-docs" / template_filename,
    # Then: Check installed package location  
    Path(__file__).parent.parent.parent / "templates" / "init-docs" / template_filename,
    # Then: Try user home directory
    Path.home() / ".rapidspec" / "templates" / "init-docs" / template_filename,
    # Finally: Try current working directory
    Path.cwd() / "templates" / "init-docs" / template_filename,
]
```

### 3. Verification & Testing

**All 17 AI models tested and working:**

| Model | Status | Notes |
|-------|--------|-------|
| Claude Code | ✅ PASS | CLAUDE.md created (14 KB) |
| Gemini CLI | ✅ PASS | GEMINI.md created (7 KB) |
| GitHub Copilot | ✅ PASS | COPILOT.md created (3.3 KB) |
| Cursor | ✅ PASS | CURSOR.md created (2.7 KB) |
| Qwen Code | ✅ PASS | QWEN.md created (2.2 KB) |
| OpenCode | ✅ PASS | OPENCODE.md created (1.6 KB) |
| Codex | ✅ PASS | CODEX.md created (1.4 KB) |
| Windsurf | ✅ PASS | WINDSURF.md created (1.6 KB) |
| Kilo Code | ✅ PASS | KILOCODE.md created (1.2 KB) |
| Auggie | ✅ PASS | AUGGIE.md created (1.1 KB) |
| CodeBuddy | ✅ PASS | CODEBUDDY.md created (1.1 KB) |
| QODer | ✅ PASS | QODER.md created (1.1 KB) |
| Roo Code | ✅ PASS | ROO.md created (1.1 KB) |
| Amazon Q | ✅ PASS | AMAZONQ.md created (1.2 KB) |
| AMP | ✅ PASS | AMP.md created (2.3 KB) |
| SHAI | ✅ PASS | SHAI.md created (2.3 KB) |
| IBM Bob | ✅ PASS | BOB.md created (2.4 KB) |

**Test Results:**
```
✅ Direct function calls: 17/17 models pass
✅ File creation: All files created successfully
✅ Template discovery: All templates found in correct location
✅ Placeholder replacement: [TIMESTAMP] and [Model Name] replaced correctly
✅ Project structure: Compatible with --here, --force, and fresh init
```

---

## 📋 Commits

**Main Fix:**
- `b929b60` - "Restore init-guide feature with fixed template discovery"
  - Fixed template path discovery logic
  - Checks project .rapidspec/ first (correct location)
  - Tests all 17 models successfully

**Version Bump:**
- `3dfd033` - "chore: Bump version to v0.0.9 for release"
  - Updated pyproject.toml: 0.0.5 → 0.0.9

---

## 📈 Changes Summary

### Files Modified
- `src/specify_cli/__init__.py` - Fixed `create_model_init_guide()` function
- `pyproject.toml` - Version bump to 0.0.9

### Lines Changed
- **+81 lines** - Improved template discovery implementation
- **-7 lines** - Removed broken path logic
- **Net: +74 lines**

### Quality Metrics
- ✅ All 17 AI models: PASS
- ✅ Path discovery: PASS
- ✅ Template detection: PASS
- ✅ File creation: PASS
- ✅ Placeholder replacement: PASS
- ✅ Tracker integration: PASS
- ✅ Project structure: PASS

---

## 🚀 Installation & Usage

### Update Installation

```bash
# Update existing installation
pip install --upgrade rapidspec-cli

# Or with uv
uv tool upgrade rapidspec-cli

# Or install fresh
uv tool install rapidspec-cli
```

### Verify the Fix

```bash
# Create a new project
rapidspec init test-project --ai claude

# Check that the init guide was created
ls test-project/
# You should see:
# - CLAUDE.md (✅ NEW - this was missing in v0.0.8)
# - .rapidspec/
# - .claude/

# Read the guide
cat test-project/CLAUDE.md
```

### All 17 Models Now Work

```bash
# Each of these now creates the correct initialization guide
rapidspec init my-project --ai claude        # Creates CLAUDE.md
rapidspec init my-project --ai gemini        # Creates GEMINI.md
rapidspec init my-project --ai copilot       # Creates COPILOT.md
rapidspec init my-project --ai cursor        # Creates CURSOR.md
rapidspec init my-project --ai qwen          # Creates QWEN.md
rapidspec init my-project --ai opencode      # Creates OPENCODE.md
rapidspec init my-project --ai codex         # Creates CODEX.md
rapidspec init my-project --ai windsurf      # Creates WINDSURF.md
rapidspec init my-project --ai kilocode      # Creates KILOCODE.md
rapidspec init my-project --ai auggie        # Creates AUGGIE.md
rapidspec init my-project --ai codebuddy     # Creates CODEBUDDY.md
rapidspec init my-project --ai qoder         # Creates QODER.md
rapidspec init my-project --ai roo           # Creates ROO.md
rapidspec init my-project --ai q             # Creates AMAZONQ.md
rapidspec init my-project --ai amp           # Creates AMP.md
rapidspec init my-project --ai shai          # Creates SHAI.md
rapidspec init my-project --ai bob           # Creates BOB.md
```

---

## 🔄 Upgrade Notes

### For v0.0.8 Users

**Good news:** You can safely upgrade with no configuration needed.

```bash
# Update your installation
pip install --upgrade rapidspec-cli

# Option 1: Re-initialize existing projects to get the missing guide
rapidspec init . --here --ai claude --force

# Option 2: Manually use the function to create it
python3 << 'EOF'
from pathlib import Path
from specify_cli import create_model_init_guide
create_model_init_guide(Path("."), "claude")
EOF
```

### Breaking Changes

**None.** This is a pure bug fix release.
- All existing functionality preserved
- No API changes
- No removal of features
- Fully backward compatible

---

## ✅ What's Verified

### Functionality
- ✅ Template discovery works for all 17 models
- ✅ Files created with correct content
- ✅ Placeholders replaced correctly
- ✅ Tracker reports success
- ✅ Git integration still works

### Compatibility
- ✅ Works with `rapidspec init`
- ✅ Works with `rapidspec init --here`
- ✅ Works with `rapidspec init --force`
- ✅ Works with all 17 AI models
- ✅ Works with bash and PowerShell scripts

### Project Structure
- ✅ `.rapidspec/templates/init-docs/` templates found
- ✅ Placeholder files replaced
- ✅ Files written to project root
- ✅ No conflicts with existing files
- ✅ Memory bank files created correctly

---

## 📊 Release Comparison

| Feature | v0.0.8 | v0.0.9 |
|---------|--------|--------|
| Init-Guide Creation | ❌ Broken | ✅ Fixed |
| Template Discovery | ❌ Wrong path | ✅ Correct path |
| All 17 Models Support | ❌ Failed | ✅ Working |
| Model-Specific Guides | ❌ Not created | ✅ Created |
| Memory Bank Auto-Populate | ✅ | ✅ |
| Multi-Agent Review | ✅ | ✅ |
| 10 RapidSpec Commands | ✅ | ✅ |

---

## 🐞 Bugs Fixed

### Critical Bugs
- **Bug:** Init-guide template not found error (ALL USERS AFFECTED)
  - **Impact:** No CLAUDE.md, GEMINI.md, etc. files created
  - **Root Cause:** Wrong directory path in template discovery
  - **Fix:** Check project .rapidspec/ first
  - **Status:** ✅ FIXED in v0.0.9

---

## 📝 Known Issues

None known. This release is stable.

---

## 🔗 Links

- **GitHub Release:** https://github.com/benzntech/rapidspec-kit/releases/tag/v0.0.9
- **GitHub Repository:** https://github.com/benzntech/rapidspec-kit
- **Issue Tracker:** https://github.com/benzntech/rapidspec-kit/issues
- **Documentation:** https://github.com/benzntech/rapidspec-kit/tree/main/docs

---

## 💬 Support

### Getting Help
1. Read the model-specific init guide created in your project
2. Check [AGENTS.md](./AGENTS.md) for full workflow
3. Review [README.md](./README.md) for overview
4. Search [GitHub Issues](https://github.com/benzntech/rapidspec-kit/issues)

### Report Issues
- Open [GitHub Issue](https://github.com/benzntech/rapidspec-kit/issues/new)
- Include RapidSpec version: `rapidspec --version`
- Include your AI model
- Include steps to reproduce

---

## 📄 License

RapidSpec is licensed under the MIT License. See [LICENSE](./LICENSE).

---

## 🎯 Next Steps

### This Release (v0.0.9)
- ✅ Fix init-guide template discovery
- ✅ Test all 17 AI models
- ✅ Update release notes

### Upcoming (v0.1.0+)
- Web UI dashboard for memory bank
- IDE extensions (VS Code, JetBrains, etc.)
- Performance improvements for large projects
- Enhanced error messages and debugging
- Video tutorials for each AI model

---

**Thank you for using RapidSpec! Happy spec-driven development! 🚀**

---

*Release Notes for RapidSpec v0.0.9*  
*Generated: December 27, 2025*  
*Commits: b929b60, 3dfd033*
