# RapidSpec-Kit System Patterns

## Architecture & Design Patterns

Recurring patterns, conventions, and architectural decisions used throughout RapidSpec-Kit codebase.

---

## [2025-12-27 11:48:00] - Multi-Model Template Discovery Pattern

**Pattern Name:** Ordered Path Fallback Discovery

**Description:** 
Template and resource location discovery uses a prioritized search strategy, checking multiple locations in order of reliability. Most specific/reliable locations are checked first, falling back to broader locations only if needed.

**Usage Context:**
Finding configuration, templates, or resource files that may exist in multiple locations depending on installation type or environment.

**Implementation:**
```python
# Example: Init-guide template discovery
search_paths = [
    # First: Check project's extracted location (most reliable)
    project_path / ".rapidspec" / "templates" / "init-docs" / template_filename,
    # Then: Check installed package location
    Path(__file__).parent.parent.parent / "templates" / "init-docs" / template_filename,
    # Then: Check user home directory
    Path.home() / ".rapidspec" / "templates" / "init-docs" / template_filename,
    # Finally: Check current working directory
    Path.cwd() / "templates" / "init-docs" / template_filename,
]

for template_path in search_paths:
    if template_path.exists():
        return template_path

# Not found in any location
return None
```

**When to Use:**
- Locating files that might be in project, installation, or user-config locations
- Configuration loading with local overrides
- Resource files (templates, guides, examples)
- Fallback mechanisms for missing files

**Why This Works:**
- Prioritizes project-specific overrides (most specific)
- Falls back to installation defaults (most reliable)
- Supports user customization via home directory
- Works in all scenarios: fresh init, --here init, package installation
- Clear and predictable resolution order

**Related Code:**
- `src/specify_cli/__init__.py:1087-1090` - Init-guide template discovery
- Used by: `create_model_init_guide()` function

**Lessons Learned:**
- v0.0.8 failure: Checked only installed package location, missed extracted templates
- v0.0.9 fix: Put project location first, fixed all failures
- Pattern applies to any multi-location resource discovery

---

## [2025-12-24 14:50:00] - Model-Specific Template Generation Pattern

**Pattern Name:** Placeholder-Based Template System

**Description:**
Generate model-specific variations of documents (guides, configs, examples) from a single template by replacing placeholders with model-specific values.

**Usage Context:**
Creating 17 different model-specific initialization guides from a single template structure.

**Implementation:**
```python
# Template placeholders
PLACEHOLDERS = {
    "[TIMESTAMP]": "Dynamic timestamp when file is created",
    "[Model Name]": "Human-readable model name (Claude Code, Gemini CLI, etc)",
}

# Template loading
template_path = "templates/init-docs/CLAUDE.md"  # Same structure for all models
with open(template_path, "r") as f:
    template_content = f.read()

# Placeholder replacement
content = template_content
for placeholder, value in PLACEHOLDERS.items():
    content = content.replace(placeholder, value)

# Write model-specific output
output_path = project_path / f"{MODEL_NAME}.md"
with open(output_path, "w") as f:
    f.write(content)
```

**Benefits:**
- Single source of truth for guide structure
- Easy to update all models by editing one file
- Model-specific content without duplication
- Consistent structure across all 17 models

**Configuration:**
```python
AGENT_TO_TEMPLATE = {
    "claude": "CLAUDE",
    "gemini": "GEMINI",
    "copilot": "COPILOT",
    # ... (14 more models)
}

AGENT_CONFIG = {
    "claude": {"name": "Claude Code"},
    "gemini": {"name": "Gemini CLI"},
    "copilot": {"name": "GitHub Copilot"},
    # ... (14 more models)
}
```

**When to Use:**
- Generating multiple variations of a document
- Model-specific or environment-specific configurations
- User-facing documentation that references environment details
- Any scenario with high-duplication that can be templated

**Related Code:**
- `src/specify_cli/__init__.py:1044-1120` - `create_model_init_guide()` function
- `templates/init-docs/*.md` - 17 template files (one per model)

---

## [2025-12-22 14:00:00] - Consistent Naming Convention Pattern

**Pattern Name:** Unified Namespace Transformation

**Description:**
When rebranding or renaming a project, use consistent transformation rules across all components and artifacts. Old names are replaced with new names systematically across code, commands, directories, and documentation.

**Usage Context:**
Rebrand from SpecKit to RapidSpec across entire project.

**Transformation Rules:**
```
speckit → rapidspec  (lowercase)
Speckit → Rapidspec  (title case)
SpecKit → RapidSpec  (both capitalized)
SPECKIT → RAPIDSPEC  (all caps)

Directory: .specify/ → .rapidspec/
CLI: specify → rapidspec
Package: specify-cli → rapidspec-cli
Commands: /speckit.* → /rapidspec.*
Release: spec-kit-template → rapidspec-template
```

**Implementation Strategy:**
1. Find all occurrences of old name patterns
2. Replace with corresponding new name patterns
3. Verify in all artifact types:
   - Source code
   - Configuration files
   - Release packages
   - Command namespaces
   - Directory names
   - Documentation

**When to Use:**
- Major project rebranding
- Namespace changes to avoid conflicts
- Consolidation of related projects
- Adopting new naming conventions

**Related Code:**
- Constitution amendment v1.1.0 documents the rebrand
- Multiple commits December 20-24

---

## [2025-12-24 06:35:00] - Specification-Driven Implementation Pattern

**Pattern Name:** Proposal-Before-Code Workflow

**Description:**
RapidSpec enforces specification-first development where:
1. Proposal is created with research, alternatives, and impact analysis
2. User selects preferred approach
3. Only then is code implemented
4. Implementation follows proposal exactly
5. Tests and reviews verify adherence to proposal

**Purpose:**
Prevent "hallucination" where AI generates code based on assumptions instead of verified facts.

**Implementation:**
```
1. Proposal Phase
   - Read actual codebase files
   - Research best practices
   - Check git history
   - Propose 2-3 alternatives with trade-offs
   - Wait for user decision

2. Implementation Phase
   - Follow proposal exactly
   - Show diffs before applying changes
   - Pause at checkpoints for approval
   - One small task at a time (5-10 min)

3. Review Phase (optional)
   - Multi-agent review for quality
   - Security, architecture, testing checks
   - Block on critical issues

4. Commit Phase
   - Generate conventional commits
   - Link to proposal ID
   - Document decisions made

5. Archive Phase
   - Move change to completed log
   - Update specs/ directory
   - Close related issues
```

**Benefits:**
- Prevents assumptions and hallucinations
- Gives users control over approach
- Creates documentation of rationale
- Enables easy rollback or changes
- Ensures quality before deployment

**Related Code:**
- Constitution.md - Core principle #1: Specification-First Development
- AGENTS.md - Full workflow documentation
- `/rapidspec.proposal` command - Create proposals
- `/rapidspec.apply` command - Implement with checkpoints

---

## [2025-12-20 10:00:00] - Multi-Agent Code Review Pattern

**Pattern Name:** Specialized Agent Review

**Description:**
Code review is performed by multiple specialized agents, each focusing on specific aspects:
- Security Auditor: Vulnerability and security checks
- Architecture Strategist: Design and architectural soundness
- Code Reviewer: Code quality and style
- Database Architect: Data model and query safety
- Test Reviewer: Test coverage and quality
- Performance Oracle: Performance implications
- Code Verifier: Verification that code works

**Purpose:**
Catch issues that single reviewers might miss, with each agent bringing specialist expertise.

**Implementation:**
```python
REVIEW_AGENTS = {
    "security": "Security Auditor",
    "architecture": "Architecture Strategist",
    "code_quality": "Code Reviewer",
    "database": "Database Architect",
    "testing": "Test Reviewer",
    "performance": "Performance Oracle",
    "verification": "Code Verifier",
}

# Each agent reviews the changes and reports:
# - Critical issues (block deployment)
# - Warnings (should be addressed)
# - Suggestions (nice-to-have improvements)
```

**When to Use:**
- Major features
- Security-critical code
- Performance-sensitive code
- Complex architectural changes
- Code affecting multiple systems

**Related Code:**
- `/rapidspec.review` command - Trigger multi-agent review
- AGENTS.md - Review agent details

---

## [2025-12-20 09:00:00] - Checkpoint-Based Implementation Pattern

**Pattern Name:** Pausable Workflow with Diffs

**Description:**
Implementation is broken into small tasks (5-10 minute chunks) with explicit checkpoints. Before each change, a diff is shown. User can:
- Continue (gg/go)
- Pause and revise (wait)
- Skip or redirect (no)

**Purpose:**
Give users control during implementation, enable course correction, prevent batch changes.

**Benefits:**
- No surprises - user sees every change before it's applied
- Direction can change mid-implementation
- Users can test locally at each checkpoint
- Easy to rollback or modify specific changes
- Builds confidence in AI-generated code

**Related Code:**
- `/rapidspec.apply` command - Implementation with checkpoints
- AGENTS.md - Checkpoint control details

---

## General Principles

### 1. Verification Over Assumptions
Always read actual files before making decisions. Never assume implementations exist or work in specific ways.

### 2. Explicit Tradeoffs
When multiple approaches exist, document pros/cons/effort for each. Let users decide, don't assume.

### 3. Checkpoint Verification
Break work into small steps with verification between each. Show diffs, wait for approval.

### 4. Documentation as Code
Keep specifications, decisions, and progress in tracked files, not in separate docs. Specs are source of truth.

### 5. Template Systems
Use templates for anything that has variations (models, environments, configurations). Single source of truth, multiple outputs.

### 6. Fallback Mechanisms
Design systems that gracefully handle missing resources. Ordered fallbacks from most-specific to most-general.

### 7. Consistent Conventions
Apply naming and structure conventions consistently across all components. Easy to predict where things are.

---

