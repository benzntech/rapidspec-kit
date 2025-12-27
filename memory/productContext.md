# RapidSpec-Kit Product Context

## Project Overview

**Project Name:** RapidSpec-Kit  
**Version:** 0.0.9  
**Release Status:** Stable  
**Last Updated:** 2025-12-27 11:50:00

**Description:**  
RapidSpec-Kit is a specification-first development toolkit that enables AI-assisted software engineering through structured workflows, multi-model support, and memory-bank-driven development. The toolkit provides commands for proposal creation, checkpoint-based implementation, quality review, and automated documentation.

---

## Core Goals & Vision

### Primary Goal
Enable efficient, high-quality software development with AI assistance by enforcing specification-first methodology, preventing hallucination, and providing clear checkpoints for user control.

### Secondary Goals
1. Support 17 different AI assistants (Claude Code, Gemini CLI, etc) with model-specific guidance
2. Automate quality review with specialized agents (security, architecture, testing, etc)
3. Create self-documenting development through memory bank systems
4. Provide pausable, resumable workflows that respect user control
5. Make AI-assisted development reproducible and auditable

### Success Metrics
- All 17 AI models have auto-generated initialization guides
- v0.0.9 released and marked as Latest
- Init-guide feature working in all scenarios
- Zero critical blockers for production use
- User onboarding friction eliminated

---

## Technology Stack

### Languages
- **Python 3.10+** - CLI implementation
- **Markdown** - Specifications, documentation, memory bank
- **Bash/PowerShell** - Generated project scripts

### Core Libraries
- **Typer** - CLI framework (Python)
- **Rich** - Terminal UI and formatting
- **Click** - CLI utilities (dependency of Typer)
- **Requests** - HTTP client for GitHub API
- **PyYAML** - Configuration parsing (future)

### Infrastructure
- **GitHub API** - Release management and template distribution
- **GitHub Releases** - Package hosting and version management
- **ZIP Archives** - Template packaging and distribution

### Development Tools
- **uv** - Python package management
- **Git** - Version control
- **GitHub Actions** - CI/CD and release automation
- **Docker** - Development containers (optional)

### Supported Platforms
- macOS (Apple Silicon and Intel)
- Linux (Ubuntu, Debian, etc)
- Windows (via Git Bash, WSL, or native Python)

---

## System Architecture

### Components

#### 1. CLI Tool (`rapidspec`)
- **Location:** `src/specify_cli/`
- **Entry Point:** `src/specify_cli/__init__.py`
- **Commands:**
  - `rapidspec init` - Initialize new RapidSpec project
  - `rapidspec version` - Show version
  - Other commands implemented in agents

- **Core Functions:**
  - `init()` - Project initialization with template download and setup
  - `create_model_init_guide()` - Generate model-specific guides
  - `fetch_latest_release()` - Get latest release from GitHub
  - `download_release_asset()` - Download template ZIP files
  - `extract_templates()` - Extract and process templates

#### 2. Templates System
- **Location:** `templates/init-docs/`
- **Count:** 17 model-specific guides + configuration templates
- **Structure:**
  ```
  templates/
  ├── init-docs/
  │   ├── CLAUDE.md
  │   ├── GEMINI.md
  │   ├── COPILOT.md
  │   └── ... (14 more models)
  └── ... (other templates)
  ```

#### 3. Memory Bank System
- **Location:** `.rapidspec/memory/` in generated projects
- **Files:**
  - `constitution.md` - Project principles and governance
  - `productContext.md` - Architecture and tech stack
  - `activeContext.md` - Current work and objectives
  - `systemPatterns.md` - Coding patterns and conventions
  - `decisionLog.md` - Technical decisions with rationale
  - `progress.md` - Work history and tracking

#### 4. Release Management
- **GitHub Release URL:** `https://github.com/benzntech/rapidspec-kit/releases/tag/v{version}`
- **Assets:**
  - `rapidspec-template-{model}-{script-type}-v{version}.zip` (34 total per release)
  - Script types: `sh` (Bash) and `ps` (PowerShell)
  - Models: All 17 supported AI assistants

#### 5. Documentation
- **Location:** `docs/`, `*.md` files in root
- **Key Files:**
  - `README.md` - Project overview
  - `AGENTS.md` - Complete workflow documentation
  - `RELEASE_NOTES_v0.0.*.md` - Release information

---

## Supported AI Models

### All 17 Models
1. **Claude Code** - Anthropic (CLAUDE.md)
2. **Gemini CLI** - Google (GEMINI.md)
3. **GitHub Copilot** - GitHub (COPILOT.md)
4. **Cursor** - Cursor (CURSOR.md)
5. **Qwen Code** - Alibaba (QWEN.md)
6. **OpenCode** - OpenAI (OPENCODE.md)
7. **Codex** - OpenAI (CODEX.md)
8. **Windsurf** - Codeium (WINDSURF.md)
9. **Kilo Code** - Kilo (KILOCODE.md)
10. **Auggie** - IBM (AUGGIE.md)
11. **CodeBuddy** - CodeBuddy (CODEBUDDY.md)
12. **QODer** - QODer (QODER.md)
13. **Roo Code** - Roo Code (ROO.md)
14. **Amazon Q** - AWS (AMAZONQ.md)
15. **AMP** - AMP (AMP.md)
16. **SHAI** - SHAI (SHAI.md)
17. **IBM Bob** - IBM (BOB.md)

### Model-Specific Guides
Each model has a dedicated initialization guide with:
- Model-specific command syntax
- Quick-start instructions
- RapidSpec workflow overview
- Troubleshooting tips
- Links to relevant documentation

---

## Core Workflows

### Workflow 1: Project Initialization
```
1. User runs: rapidspec init my-project --ai claude
2. CLI fetches latest release from GitHub
3. Downloads template ZIP for Claude + sh
4. Extracts templates to .rapidspec/
5. Initializes memory bank (6 files)
6. Auto-creates CLAUDE.md in project root
7. Project ready for development
```

### Workflow 2: Specification-First Development
```
1. User defines feature with /rapidspec.proposal
2. AI reads actual code and proposes alternatives
3. User chooses preferred approach
4. Implementation runs with /rapidspec.apply
5. Checkpoints pause before each change for approval
6. Optional: /rapidspec.review for quality check
7. /rapidspec.commit documents changes
8. /rapidspec.archive marks feature complete
```

### Workflow 3: Multi-Agent Code Review
```
1. After implementation with /rapidspec.apply
2. User runs /rapidspec.review
3. 7 specialized agents review the changes:
   - Security Auditor
   - Architecture Strategist
   - Code Reviewer
   - Database Architect
   - Test Reviewer
   - Performance Oracle
   - Code Verifier
4. Issues categorized: Critical, Warning, Suggestion
5. User decides which to address
```

---

## Data Flow

### Release Download Flow
```
User Command
    ↓
GitHub Releases API
    ├── Fetch: /releases/latest
    ├── Get: rapidspec-template-{model}-{script}-v{version}.zip
    └── Check: size, integrity
    ↓
Download & Cache
    ├── Check cache first
    ├── Download if missing
    └── Verify checksum
    ↓
Extract to Project
    ├── Unzip to project/.rapidspec/
    ├── Set executable permissions
    └── List extracted files
    ↓
Initialize Memory Bank
    ├── Create 6 memory files
    ├── Populate with defaults
    └── Ready for use
    ↓
Create Init Guides
    ├── Find template in .rapidspec/templates/init-docs/
    ├── Replace placeholders
    └── Write to project root
    ↓
Project Ready
```

### Memory Bank Update Flow
```
Development Work
    ↓
User runs /rapidspec.umb
    ↓
Analyze Session
    ├── Read git history
    ├── Extract decisions made
    ├── Identify completed work
    └── Document patterns
    ↓
Update Memory Files
    ├── decisionLog.md (APPEND)
    ├── progress.md (APPEND)
    ├── activeContext.md (MODIFY)
    ├── systemPatterns.md (APPEND)
    └── productContext.md (MODIFY if needed)
    ↓
Cross-File Sync
    ├── Link decisions to patterns
    ├── Mark objectives complete
    └── Resolve questions
    ↓
Memory Bank Updated
```

---

## Integration Points

### GitHub Integration
- Fetch releases from `https://github.com/benzntech/rapidspec-kit/releases`
- Get latest version from `/releases/latest` endpoint
- Download template assets from release
- Future: Create PR comments with review results

### IDE Integration (Future)
- VS Code extension for slash commands
- JetBrains plugin support
- Cursor integration for model-specific commands

### AI Assistant Integration
- Each AI assistant gets model-specific guides
- Command syntax tailored to each tool
- Integration with native command systems

---

## Deployment & Distribution

### Release Process
1. Version bump in `pyproject.toml`
2. Create `RELEASE_NOTES_v{version}.md`
3. Trigger GitHub Actions workflow
4. Generate template packages for all 17 models × 2 script types
5. Create GitHub Release with assets
6. Mark as "Latest" if stable release

### Package Distribution
- **Method:** GitHub Releases (no PyPI publish)
- **Format:** ZIP files with templates
- **Versioning:** Semantic versioning (v0.0.9)
- **Latest Release:** Marked on GitHub for API discovery

### Update Mechanism
```bash
# Users install/update via:
pip install --upgrade rapidspec-cli
# or
uv tool upgrade rapidspec-cli

# CLI then fetches templates from:
https://github.com/benzntech/rapidspec-kit/releases/latest
```

---

## Known Limitations

1. **Python 3.10+ Required** - Uses modern Python features
2. **No Windows Native Support** - Requires bash environment
3. **GitHub Dependency** - Requires internet to download releases
4. **Single Release Version** - Can't pin to specific versions yet
5. **No Offline Mode** - Must download templates online

---

## Future Roadmap (v0.1.0+)

### Short Term (Next Release)
- Web UI dashboard for memory bank
- IDE extensions (VS Code, JetBrains)
- Better error messages and debugging

### Medium Term (Future Releases)
- Performance optimizations for large projects
- Offline template caching
- Custom model registration
- Advanced memory bank querying

### Long Term (Aspirational)
- Multi-user project support
- Cloud sync for memory bank
- Integration with project management tools
- Enterprise features (audit logs, permissions)

---

## Quality Metrics (v0.0.9)

### Release Quality
- All 17 AI models: ✅ VERIFIED
- Init-guide creation: ✅ WORKING
- Path discovery: ✅ FIXED
- Release assets: ✅ 34 PACKAGES GENERATED
- Code quality: ✅ CLEAN

### Testing Coverage
- Manual testing: All 17 models
- Production path testing: ✅ VERIFIED
- File content verification: ✅ TIMESTAMPS CORRECT
- Git integration: ✅ WORKING

### Known Issues
- None for v0.0.9

---

## Team & Ownership

**Primary Maintainer:** RapidSpec-Kit Contributors  
**Repository:** https://github.com/benzntech/rapidspec-kit  
**License:** MIT  

---

[2025-12-27 11:50:00] - Updated with v0.0.9 release information and complete init-guide feature verification
