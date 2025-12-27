# RapidSpec-Kit Decision Log

## Project Decisions and Rationale

Records of technical and architectural decisions made during RapidSpec-Kit development, including context, alternatives considered, and rationale.

---

## [2025-12-27 11:48:00] - Fix Init-Guide Template Discovery Bug

**Context:**
The `create_model_init_guide()` function in v0.0.8 was failing to create model-specific initialization guides (CLAUDE.md, GEMINI.md, etc.) during `rapidspec init` command execution. The function existed but couldn't locate template files due to incorrect path discovery logic.

**Decision:**
Restore and fix the init-guide feature by correcting the template path discovery strategy to check the extracted project `.rapidspec/templates/` directory FIRST (where templates are actually located after extraction) before falling back to the installed package location.

**Rationale:**
- The bug affected all users (100% failure rate for init-guide creation)
- Direct Python function calls worked perfectly, indicating the logic was sound but paths were wrong
- The most reliable location for templates is the extracted project structure, not the installed package
- Fallback to package installation ensures feature works in both fresh installs and --here scenarios

**Alternatives Considered:**
1. **Remove init-guide feature entirely** - REJECTED
   - Would lose valuable model-specific documentation
   - Users want guided onboarding for their specific AI assistant
   - Feature is core to RapidSpec workflow

2. **Document manual workaround** - REJECTED
   - Undermines "auto-population" principle
   - Creates friction in onboarding experience
   - v0.0.8 users would be stuck without proper guides

3. **Defer fix to v0.1.0** - REJECTED
   - Bug blocks all new project initialization
   - Simple fix available now; no architectural blocker
   - Users need this working immediately

**Implications:**
- All 17 AI models now auto-create init guides on `rapidspec init`
- Users receive model-specific documentation immediately after project creation
- No manual steps required in init workflow
- Better onboarding experience for new RapidSpec users

**Technical Details:**
- Modified path discovery in `create_model_init_guide()` function (src/specify_cli/__init__.py:1087-1090)
- Search order: project `.rapidspec/templates/init-docs/` → package location → home directory → cwd
- Commits: b929b60 (restore with fix), 3dfd033 (version bump)

**Testing:**
- All 17 models verified: ✅ CLAUDE.md, GEMINI.md, COPILOT.md, CURSOR.md, QWEN.md, OPENCODE.md, CODEX.md, WINDSURF.md, KILOCODE.md, AUGGIE.md, CODEBUDDY.md, QODER.md, ROO.md, AMAZONQ.md, AMP.md, SHAI.md, BOB.md
- Tested in `/tmp/`, `/Volumes/External/bensonmac/perpelxity/` (production path)
- Verified file content has correct timestamps and model names

**Related:**
- Version: v0.0.9
- Release: https://github.com/benzntech/rapidspec-kit/releases/tag/v0.0.9

---

## [2025-12-27 11:45:00] - Release v0.0.9 with Init-Guide Fix

**Context:**
v0.0.8 was released as "Latest" but contained broken init-guide functionality. Source code had fixes but users couldn't access them until a new release was published and marked as Latest.

**Decision:**
Create and publish v0.0.9 release with the init-guide fix and mark it as the Latest release on GitHub. This ensures `rapidspec init` fetches the correct version via `/releases/latest` API endpoint.

**Rationale:**
- Users run `rapidspec init` which fetches from `/releases/latest`
- If v0.0.8 is Latest but broken, users get broken version regardless of source code fixes
- Publishing v0.0.9 and marking it Latest ensures users get working code immediately
- Clean release process follows semantic versioning

**Implications:**
- v0.0.9 becomes the minimum recommended version for users
- Users updating existing installations get the fix
- New installations get working init-guide feature
- Release velocity maintained (patch fixes in minor releases)

**Technical Details:**
- Updated pyproject.toml version: 0.0.5 → 0.0.9
- Created release notes documenting the fix and all 17 verified models
- Generated 34 template packages (17 models × 2 script types: sh + ps)
- Commits: 3dfd033 (version bump), ca48d5c (release trigger)

**Related:**
- Release URL: https://github.com/benzntech/rapidspec-kit/releases/tag/v0.0.9

---

## [2025-12-24 14:50:00] - Add Model-Specific Initialization Guides

**Context:**
Users need clear, model-specific guidance on how to use RapidSpec with their chosen AI assistant (Claude Code, Gemini CLI, etc.). Generic documentation doesn't provide AI-assistant-specific command examples or workflows.

**Decision:**
Create 17 model-specific initialization guide templates (CLAUDE.md, GEMINI.md, etc.) that auto-populate during `rapidspec init` based on the selected AI assistant. Each guide contains RapidSpec commands tailored to that model with exact slash command syntax.

**Rationale:**
- Different AI assistants have different command interfaces (Claude Code uses `/rapidspec.*`, Gemini CLI has different slash commands)
- Auto-generation during init ensures guides are always up-to-date and consistent
- Reduces friction in onboarding - users get instant guidance without searching docs
- Template system allows easy updates to all 17 guides simultaneously

**Alternatives Considered:**
1. **Generic single guide** - REJECTED
   - Doesn't address model-specific command syntax
   - Users have to mentally translate examples to their tool

2. **Require users to read external docs** - REJECTED
   - Poor onboarding experience
   - Friction point for new users
   - Against RapidSpec principle of auto-population

3. **Hardcode model guides in CLI** - REJECTED
   - Makes CLI binary large
   - Difficult to update across installations
   - Less flexible for future model additions

**Implications:**
- All 17 supported AI models have dedicated onboarding guides
- Guides are auto-created and customized per project
- Consistent workflow across all model types
- Improved user retention during initial setup

**Technical Details:**
- 17 template files in templates/init-docs/ (CLAUDE.md, GEMINI.md, etc.)
- Placeholders for [TIMESTAMP] and [Model Name] replaced on generation
- Auto-generation as final step in `rapidspec init` workflow
- Commit: 3443a1a (initial implementation)

**Status:**
- ✅ Feature implemented
- ❌ Broken in v0.0.8 (path discovery bug)
- ✅ Fixed in v0.0.9
- ✅ All 17 models verified working

---

## [2025-12-27] Automatic UV Package Manager Checking During Init

**Context:**
Users needed to manually manage UV (Python package manager) versions. RapidSpec projects are best used with the latest UV for optimal performance and feature support. Without auto-updating, users might have outdated UV versions during project initialization.

**Decision:**
Implement automatic UV version checking and auto-update as an integrated step in the `rapidspec init` command.

**Rationale:**
1. **User Experience**: Eliminate manual UV management - users get latest version automatically
2. **Reliability**: GitHub API provides single source of truth for latest version
3. **Non-Blocking**: UV is optional (users can initialize without it), so check must not fail init
4. **Performance**: Early check catches outdated versions before template download
5. **Transparency**: Full StepTracker integration shows users what's happening

**Alternatives Considered:**

1. **Warn users about outdated UV** - REJECTED
   - Users might ignore warnings
   - Extra manual step required
   - Reduces setup friction reduction benefit

2. **Force UV update (blocking)** - REJECTED
   - Init would fail if UV unavailable
   - Users without UV couldn't initialize projects
   - Violates RapidSpec principle of flexible tooling

3. **Skip UV checking entirely** - REJECTED
   - Users might miss important updates
   - Defeats purpose of optimizing project setup
   - No benefit to project initialization experience

**Implementation Strategy:**
- Version detection: `uv --version` command
- Latest version source: GitHub API (astral-sh/uv/releases/latest)
- Update mechanism: `uv self update` (built-in command)
- Version comparison: Convert X.Y.Z to integers for reliable comparison
- Error handling: Non-blocking with graceful fallbacks

**Technical Details:**
- Function: `check_uv_version(tracker)` in src/specify_cli/__init__.py
- Helper: `_compare_versions(current, latest)` for semantic version comparison
- Integration point: Early in init try block, before template download
- Tracker step: "uv-check" added to StepTracker
- Timeouts: 5s for version check, 5s for API call, 30s for update

**Version Comparison Logic:**
- Converts semantic versions to 9-digit integers for comparison
- Example: 0.1.5 → 000001005, 1.2.3 → 001002003
- Handles outdated, current, and newer versions appropriately

**API Integration:**
- Endpoint: `https://api.github.com/repos/astral-sh/uv/releases/latest`
- Public API: No authentication required
- Fallback: If API unavailable, assumes current version is acceptable
- Timeout: 5 seconds to prevent hanging

**Implications:**
- Network call adds ~2 seconds to init time (1-2s if up-to-date, 10-35s if update needed)
- All timeouts have fallbacks to prevent blocking
- UV updates happen in background during init
- Users always have latest UV after successful init
- Non-blocking design means init succeeds even if UV check fails

**Status:**
- ✅ Feature implemented (commit: ac5f3bb)
- ✅ Syntax validation passed
- ✅ Integration tested in workflow
- ✅ Documentation complete (docs/UV_AUTO_UPDATE.md)
- ⏳ Production deployment pending

**Related:**
- Files: src/specify_cli/__init__.py, docs/UV_AUTO_UPDATE.md, .github/workflows/scripts/check-uv-version.sh
- Commits: ac5f3bb (main implementation)
- Issue/Proposal: User request to auto-update UV during init

---

