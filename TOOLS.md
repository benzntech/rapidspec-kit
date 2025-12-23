# RapidSpec-Kit Tools & Commands Reference

**Available for all AI coding agents**: Claude Code, Gemini CLI, Cursor, Copilot, Windsurf, Qwen, opencode, and all other supported tools.

## 📋 Quick Command Reference

### Workflow Commands (Use in this order)

```text

/rapidspec.constitution → /rapidspec.specify → /rapidspec.research → /rapidspec.verify →
/rapidspec.options → /rapidspec.plan → /rapidspec.apply → /rapidspec.review →
/rapidspec.commit → /rapidspec.archive

```text

---

## 🔄 Full 6-Phase Automation Workflow

### Phase 1️⃣: Specification Definition

**Command**: `/rapidspec.specify`

Define what you want to build, focusing on **requirements** and **user stories**.

**Input**: Natural language description of features and user needs
**Output**: `spec.md` with structured requirements

**When to use**: Start of new feature development
**Example**:

```text

/rapidspec.specify Build a photo album organizer with drag-and-drop support.
Albums are grouped by date and photos can be dragged between albums.
Photos are displayed in a tile grid with preview thumbnails.

```text

---

### Phase 2️⃣: Research & Technical Investigation

**Command**: `/rapidspec.research`

Conduct automated web research to gather evidence for technical decisions.

**Input**: Feature spec and architectural questions
**Output**: `research.md` with findings, trade-offs, and evidence

**When to use**: After spec is finalized
**Features**:

- Parallel agent execution for speed

- Web search automation

- Technology comparison

- Best practices research

- Evidence-based recommendations

**Example**:

```text

/rapidspec.research

```text

---

### Phase 3️⃣: Code Verification & Impact Analysis

**Command**: `/rapidspec.verify`

Verify actual code exists, detect frameworks, analyze git history, and identify risks (prevents hallucinations).

**Input**: Feature directory with existing code
**Output**: `verification.md` with verified paths, framework detection, git context

**When to use**: Before planning changes to existing code (brownfield)
**Features**:

- File existence verification

- Framework/version detection

- Git history analysis

- Breaking change detection

- Risk assessment

**Example**:

```text

/rapidspec.verify

```text

---

### Phase 4️⃣: Options Generation & Selection

**Command**: `/rapidspec.options`

AI generates 2-3 distinct implementation approaches with trade-off analysis.

**Input**: Research findings and requirements
**Output**: `options.md` with approach options and AI recommendation

**When to use**: After research completes
**Features**:

- AI-generated approaches (not templates)

- Pros/cons analysis

- Cost estimation (time, risk, complexity)

- AI recommendation with confidence score

- User can override recommendation

**Example**:

```text

/rapidspec.options

```text

---

### Phase 5️⃣: Planning & Task Generation

**Command**: `/rapidspec.plan`

Create technical implementation plans and generate actionable task lists.

**Input**: Tech stack selection and architecture choices
**Output**: `plan.md` and `tasks.md` with implementation breakdown

**When to use**: After selecting implementation approach
**Features**:

- Technical architecture planning

- Dependency management

- Task breakdown by user story

- Checkpoint validation points

- Parallel execution markers

**Example**:

```text

/rapidspec.plan Use React with TypeScript and Tailwind CSS.
Store data in SQLite with automatic syncing.

```text

---

### Phase 6️⃣: Checkpoint-Based Implementation

**Command**: `/rapidspec.apply`

Implement tasks one at a time with before→after diffs and user approval.

**Input**: `plan.md` and `tasks.md`
**Output**: Implemented code with real-time task tracking

**When to use**: When ready to write code
**Features**:

- Before→after diffs for every change

- User approval checkpoints

- Real-time task tracking (`[ ]` → `[x]`)

- Pause/test/continue workflow

- Discovers unplanned improvements

**Options during implementation**:

- `yes` - Proceed with the change

- `wait` - Pause and refine before continuing

- `skip` - Skip this task

- `test` - Pause for testing

- `help` - Show help and options

**Example**:

```text

/rapidspec.apply

```text

---

### Phase 7️⃣: Multi-Agent Quality Review

**Command**: `/rapidspec.review`

Automated security, architecture, and code quality review.

**Input**: Implemented code changes
**Output**: `review.md` with findings organized by severity

**When to use**: After implementation completes
**Features**:

- **Core Agents** (always run):
  - Code reviewer: readability, duplication, error handling, performance
  - Security auditor: OWASP Top 10, secrets, vulnerabilities
  - Architecture strategist: design patterns, coupling, SOLID principles

- **Conditional Agents** (run if detected):
  - Database reviewer: schema, migrations, query optimization
  - API reviewer: REST conventions, auth, error handling
  - Component reviewer: props, state, hooks, accessibility
  - Test reviewer: coverage, quality, alignment

**Findings Format**:

- Critical ❌ (must fix)

- Warning ⚠️ (should fix)

- Info 💡 (nice to have)

**Example**:

```text

/rapidspec.review

```text

---

### Phase 8️⃣: Git Integration & Auto-Commits

**Command**: `/rapidspec.commit`

Verify changes, generate conventional commits, create pull requests.

**Input**: Implemented code and completed tasks
**Output**: Git commits + pull request with auto-generated description

**When to use**: After review passes
**Features**:

- Git change verification

- Task matching validation

- Conventional commit generation (feat, fix, refactor, docs, test, chore)

- Pull request with auto-description

- Links to tasks and issues

**Commit Types**:

- `feat:` - New user-facing feature

- `fix:` - Bug fix

- `refactor:` - Code restructure

- `docs:` - Documentation only

- `test:` - Test additions

- `chore:` - Build, deps, config

- `perf:` - Performance improvement

- `ci:` - CI/CD pipeline

**Example**:

```text

/rapidspec.commit

```text

---

### Phase 9️⃣: Archive & Deployment

**Command**: `/rapidspec.archive`

Archive completed work, merge specs, close issues, prepare for production.

**Input**: Merged pull request
**Output**: Feature archived with metadata, specs merged

**When to use**: After PR is merged to main
**Features**:

- Archive validation

- Feature artifact backup

- Spec merging to canonical location

- GitHub issue closing

- Feature branch cleanup

- Deployment readiness report

**Creates**:

- `specs/archive/TIMESTAMP-feature-name/` directory

- `manifest.json` with metadata

- Updated `specs/index.md`

**Example**:

```text

/rapidspec.archive

```text

---

## 🛠️ Setup & Configuration Commands

### Project Principles

**Command**: `/rapidspec.constitution`

Create or update project governing principles and development guidelines.

**Input**: Principles for code quality, testing, UX, performance
**Output**: `constitution.md` with project standards

**When to use**: At project start
**Example**:

```text

/rapidspec.constitution Create principles focused on:

- Code quality: type safety, clear naming, minimal duplication

- Testing: comprehensive unit tests, integration tests

- UX: consistency, accessibility, performance

- Performance: <2s page load, smooth animations

```text

---

### Task Breakdown

**Command**: `/rapidspec.tasks`

Generate actionable task lists from implementation plan (auto-run by `/rapidspec.plan`).

**Input**: `plan.md` with implementation details
**Output**: `tasks.md` with structured task breakdown

**Note**: This is typically generated automatically by `/rapidspec.plan`, but can be run independently.

**Example**:

```text

/rapidspec.tasks

```text

---

## 📁 Generated Artifacts

### Specification Phase

- **spec.md** - Requirements, user stories, functional specifications

- **constitution.md** - Project principles and standards

### Research Phase

- **research.md** - Web research findings, technology analysis, evidence

### Verification Phase

- **verification.md** - Verified file paths, frameworks, git history, risks

### Options Phase

- **options.md** - Implementation approaches with trade-offs, recommendation

### Planning Phase

- **plan.md** - Technical architecture and implementation strategy

- **tasks.md** - Task breakdown with dependencies and checkpoints

### Implementation Phase

- **Updated tasks.md** - Real-time task completion tracking

### Review Phase

- **review.md** - Security, architecture, code quality findings

### Commit Phase

- **Git commits** - Conventional format commits

- **Pull request** - Auto-generated PR description

### Archive Phase

- **specs/archive/TIMESTAMP-feature/** - Complete feature backup

- **specs/index.md** - Updated catalog of completed features

---

## 🔑 Key Features

### Evidence-Based Decisions

- All recommendations grounded in research findings

- Web search automation for current best practices

- No hallucinations or assumptions

### Safety First

- **Verification**: Confirm code exists before planning

- **Before→After**: Show exact changes before applying

- **Checkpoints**: User approval required before each change

- **Validation**: Comprehensive review before deployment

### Efficiency

- **Parallel Agents**: Multiple reviewers run simultaneously

- **Conditional Logic**: Only relevant agents run based on changes

- **Real-Time Tracking**: Tasks update as work progresses

- **Auto-Documentation**: PRs generated from completed work

### Quality

- **Multi-Agent Review**: Security, architecture, code, database, API, components, tests

- **Severity Levels**: Critical issues must be fixed before merge

- **Conventional Commits**: Semantic versioning for release automation

- **Task Linking**: Git commits linked to specific tasks

---

## 💡 Usage Tips

### For Greenfield (New) Projects

```text

1. /rapidspec.constitution
2. /rapidspec.specify
3. /rapidspec.research
4. /rapidspec.options
5. /rapidspec.plan
6. /rapidspec.apply
7. /rapidspec.review
8. /rapidspec.commit
9. /rapidspec.archive

```text

### For Brownfield (Existing) Projects

```text

1. /rapidspec.verify         ← Important! Verify existing code
2. /rapidspec.specify        ← Define changes needed
3. /rapidspec.research       ← Gather evidence
4. /rapidspec.options        ← Generate approaches
5. /rapidspec.plan           ← Plan changes
6. /rapidspec.apply          ← Apply with diffs
7. /rapidspec.review         ← Quality check
8. /rapidspec.commit         ← Create PR
9. /rapidspec.archive        ← Deploy

```text

### For Quick Prototypes

```text

1. /rapidspec.specify        ← What to build
2. /rapidspec.plan           ← How to build (skip research)
3. /rapidspec.apply          ← Write code
4. Skip review if internal prototype
5. /rapidspec.commit         ← Save progress

```text

---

## 🎯 Workflow Examples

### Adding a New Feature

```text

/rapidspec.specify Add user authentication with email and password

/rapidspec.research

# Reviews OAuth, JWT, sessions, hashing approaches

/rapidspec.options

# Generates 3 auth approaches with trade-offs

/rapidspec.plan Use JWT with refresh tokens and bcrypt hashing

/rapidspec.apply

# Implements step-by-step with diffs

/rapidspec.review

# Security audit, architecture check

/rapidspec.commit

# Creates commit and PR

/rapidspec.archive

# Archives when PR merged

```text

### Fixing a Bug

```text

/rapidspec.verify

# Confirms code structure and git history

/rapidspec.specify Fix: Authentication fails when email has uppercase letters

/rapidspec.plan Normalize email to lowercase during login and signup

/rapidspec.apply

# Implements fix with tests

/rapidspec.review

# Checks security implications

/rapidspec.commit

# Creates fix: commit

/rapidspec.archive

# Archives when merged

```text

### Refactoring Code

```text

/rapidspec.specify Refactor: Extract component state management to custom hook

/rapidspec.plan Use React hooks pattern for reusable state logic

/rapidspec.apply

# Applies refactoring with before/after comparison

/rapidspec.review

# Checks code quality, performance

/rapidspec.commit

# Creates refactor: commit

/rapidspec.archive

# Archives completion

```text

---

## 🚀 Getting Started

1. **Initialize project**: `rapidspec init <project-name> --ai <your-tool>`
2. **Set principles**: `/rapidspec.constitution`
3. **Define feature**: `/rapidspec.specify`
4. **Follow the workflow**: Research → Verify → Options → Plan → Apply → Review → Commit → Archive

---

## 📚 Available for All AI Tools

These commands work with:

- ✅ Claude Code

- ✅ Gemini CLI

- ✅ Cursor

- ✅ GitHub Copilot

- ✅ Windsurf

- ✅ Qwen CLI

- ✅ opencode

- ✅ Codex CLI

- ✅ Qoder CLI

- ✅ IBM Bob

- ✅ And all other supported AI agents

**No tool-specific configuration needed** - all commands work the same across all platforms.

---

## 📖 For More Information

- **[README.md](./README.md)** - Overview and quick start

- **[AGENTS.md](./AGENTS.md)** - Agent documentation

- **[CONTRIBUTING.md](./CONTRIBUTING.md)** - Contribution guidelines

- **[Spec-Driven Development Guide](./docs/spec-driven.md)** - Complete methodology

---

## 💾 Memory Bank Commands (v0.2.0+)

RapidSpec includes integrated memory bank system for tracking project context and decisions.

### Memory Bank Initialization

**Command**: `/rapidspec.constitution`

Initialize and manage project memory bank with intelligent analysis.

**What it does**:
1. Creates `.rapidspec/memory/` directory with 6 files
2. Analyzes your codebase (tech stack, structure, patterns)
3. Reviews git history for decisions
4. Auto-populates context files
5. Sets up governance and principles

**When to use**: Start of project, after major architecture changes
**Output**: 6 memory bank files (productContext, activeContext, systemPatterns, decisionLog, progress, constitution)

**Example**:
```text
/rapidspec.constitution Create memory bank for Next.js e-commerce platform
```

---

### Memory Bank Session Updates

**Command**: `/rapidspec.umb`

Update memory bank during development sessions.

**What it does**:
1. Analyzes recent work and decisions
2. Updates memory bank files with:
   - Decisions made (decisionLog.md)
   - Work completed (progress.md)
   - Current focus and blockers (activeContext.md)
   - Patterns identified (systemPatterns.md)
3. Maintains timestamps for audit trail

**When to use**: End of work session, after decisions made, when resuming work
**Input**: Summary of work done or decisions made (optional)

**Examples**:
```text
/rapidspec.umb
# Updates memory with all session changes

/rapidspec.umb Completed auth refactor, implemented JWT tokens
# Updates memory with specific context

/rapidspec.umb Decision: Use cursor-based pagination for better performance
# Records specific decision
```

---

## Memory Bank Files Reference

The memory bank creates 6 files in `.rapidspec/memory/`:

| File | Purpose | Auto-Updated | Updated By |
|------|---------|--------------|-----------|
| **constitution.md** | Project governance and principles | No | Manual or `/rapidspec.constitution` |
| **productContext.md** | Project scope, architecture, tech stack | Partial | `/rapidspec.constitution`, `/rapidspec.umb` |
| **activeContext.md** | Current work, objectives, blockers | Yes | Commands (`commit`, `archive`, `apply`, etc.) |
| **systemPatterns.md** | Coding and architecture patterns | Yes | `/rapidspec.review`, `/rapidspec.umb` |
| **decisionLog.md** | Technical decisions with rationale | Yes | `/rapidspec.proposal`, `/rapidspec.commit`, `/rapidspec.umb` |
| **progress.md** | Work tracking, completed features | Yes | `/rapidspec.commit`, `/rapidspec.archive`, `/rapidspec.umb` |

---

## Memory Bank Integration with Commands

Commands support optional memory bank integration:

### Automatic Logging (No Flags)
- **`/rapidspec.commit`** - Auto-logs committed work
- **`/rapidspec.archive`** - Auto-logs completed features

### Optional Logging (with Flags)
- **`/rapidspec.proposal --update-memory`** - Log decision analysis
- **`/rapidspec.apply --track-progress`** - Update at checkpoint intervals
- **`/rapidspec.review --log-findings`** - Record findings and patterns
- **`/rapidspec.triage --log-triage`** - Log priority decisions
- **`/rapidspec.resolve-parallel --track-waves`** - Log wave progress

### Manual Logging
- **`/rapidspec.umb [description]`** - Manual memory updates anytime

---

## ❓ FAQ

**Q: What's the difference between /rapidspec.plan and /rapidspec.apply?**
A: `/rapidspec.plan` creates the detailed blueprint and task list. `/rapidspec.apply` actually implements it step-by-step with diffs.

**Q: Can I skip phases?**
A: For prototypes, yes. For production, follow the full workflow for quality.

**Q: What if a phase fails?**
A: Go back one phase and refine, then continue. The workflow is designed to catch issues early.

**Q: How do I pause implementation?**
A: During `/rapidspec.apply`, choose `wait` to pause. You can test, adjust, and resume from the same point.

**Q: Are these commands available in my tool?**
A: Yes! After running `rapidspec init`, all `/rapidspec.*` commands are available in any supported AI agent.

---

**Last Updated**: December 21, 2025
**RapidSpec-Kit Version**: 6.0.0
**Automation Parity**: 100% feature parity with RapidSpec
