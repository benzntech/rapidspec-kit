# Memory Bank User Guide

Learn how to use RapidSpec's memory bank system to track project context, decisions, and progress across development sessions.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Using the Memory Bank](#using-the-memory-bank)
- [Memory Bank Files](#memory-bank-files)
- [Viewing Your Memory Bank](#viewing-your-memory-bank)
- [Best Practices](#best-practices)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Overview

The memory bank is a project-level knowledge management system that records:

- **Technical Decisions**: Why decisions were made, alternatives considered, implications
- **Project Context**: Architecture, tech stack, organization standards
- **Development Progress**: Completed features, in-progress work, planned improvements
- **System Patterns**: Coding patterns, architectural approaches, anti-patterns to avoid
- **Active Work**: Current objectives, blockers, next actions

### Why Use a Memory Bank?

**For Individuals:**
- Resume work across sessions with full context
- Reference past decisions without rereading code
- Build a knowledge base of what works in your project

**For Teams:**
- Onboard new developers quickly
- Share architectural knowledge
- Maintain consistency across the team
- Document rationale for design decisions

**For Projects:**
- Track evolution of the system over time
- Understand why patterns were chosen
- Prevent repeated mistakes (anti-patterns)
- Support retrospectives and learning

## Getting Started

### Initialize Memory Bank

Create a memory bank for your project:

```bash
/rapidspec.constitution
```

This command:
1. Creates `.rapidspec/memory/` directory
2. Initializes 6 memory bank files
3. Analyzes your codebase
4. Auto-populates context from:
   - `package.json` / `pyproject.toml` (tech stack)
   - Directory structure (components, organization)
   - Git history (past decisions, commits)
   - README and documentation (goals, overview)

### Result

You'll have 6 files in `.rapidspec/memory/`:

```
.rapidspec/memory/
├── constitution.md        # Project governance (auto-copied)
├── productContext.md      # Project scope and architecture
├── activeContext.md       # Current work and objectives
├── systemPatterns.md      # Patterns and standards
├── decisionLog.md         # Decisions with rationale
└── progress.md            # Work tracking
```

All files are markdown (human-readable, git-friendly).

## Using the Memory Bank

### Automatic Logging

Some commands automatically log to the memory bank:

**Commits** (automatic):
```bash
/rapidspec.commit "feat: add OAuth2 authentication"
```
→ Logs to: `progress.md`, `decisionLog.md`, `activeContext.md`

**Archives** (automatic):
```bash
/rapidspec.archive feature-oauth2
```
→ Logs to: `progress.md`, `activeContext.md`

### Optional Logging

Optional commands log with a flag:

**Proposal with memory logging:**
```bash
/rapidspec.proposal --update-memory "add-user-notifications"
```
→ Logs decision, options analyzed, research findings

**Implementation progress:**
```bash
/rapidspec.apply feature-auth --track-progress
```
→ Updates every 5 checkpoints with task status

**Review findings:**
```bash
/rapidspec.review feature-auth --log-findings
```
→ Logs critical findings, patterns identified

### Manual Logging

Update memory bank anytime:

```bash
/rapidspec.umb "Completed authentication refactor, implemented JWT strategy"
```

Use for:
- Design decisions
- Pattern observations
- Lessons learned
- Mid-session context capture

## Memory Bank Files

### 1. constitution.md

**Purpose**: Project governance and principles

**Contains**:
- Core principles for development
- Quality standards
- Code organization guidelines
- Testing requirements
- Communication style

**Example section:**
```markdown
### II. Testing Standards

All features require:
- Unit tests for business logic
- Integration tests for APIs
- E2E tests for user flows
- Minimum 80% code coverage
```

**Who updates it**: Usually human-written during project setup, can be refined with `/rapidspec.constitution update`

### 2. productContext.md

**Purpose**: Project scope, architecture, and tech stack

**Contains**:
- Project description and goals
- Core components and modules
- Technology stack
- Architecture patterns
- Key dependencies
- Organization standards

**Example section:**
```markdown
## Technology Stack

- **Language**: TypeScript
- **Framework**: Next.js 15
- **Database**: PostgreSQL with Prisma ORM
- **Styling**: Tailwind CSS
- **Testing**: Vitest + Playwright
- **Auth**: NextAuth.js with JWT
```

**Who updates it**: Auto-populated on init, updated when architecture changes

### 3. activeContext.md

**Purpose**: Current work, objectives, and blockers

**Contains**:
- Current work being done
- Session objectives (checkboxes)
- Recent changes
- Open questions
- Known blockers
- Next actions

**Example section**:
```markdown
## Current Focus

### Active Work
- Change ID: feature-notifications
- Objective: Implement real-time notifications
- Status: In Progress - Checkpoint 15/20

## Known Blockers
- Websocket library choice: need to evaluate Socket.io vs ws package
- Database migration pending for notifications table
```

**Who updates it**: Auto-logged by `/rapidspec.apply`, `/rapidspec.umb`, etc.

### 4. systemPatterns.md

**Purpose**: Coding and architectural patterns used in the project

**Contains**:
- Error handling patterns
- State management approach
- API design patterns
- Module organization
- Testing patterns
- Anti-patterns to avoid

**Example section**:
```markdown
## API Design Pattern

### Endpoint Structure
```
POST /api/[resource] - Create
GET /api/[resource] - List
GET /api/[resource]/[id] - Fetch one
PATCH /api/[resource]/[id] - Update
DELETE /api/[resource]/[id] - Delete
```

### Error Response Format
```json
{
  "status": 400,
  "code": "VALIDATION_ERROR",
  "message": "Invalid input",
  "details": { "field": "email" }
}
```

## Anti-Pattern: Direct DB Queries
❌ Don't query database directly in API routes
✅ Do: Use service layer abstraction
```

**Who updates it**: Auto-logged when new patterns found during reviews

### 5. decisionLog.md

**Purpose**: Technical decisions with context and rationale

**Contains**:
- Decision title and timestamp
- Context (why needed)
- Decision (what was chosen)
- Rationale (why this approach)
- Alternatives considered
- Implications

**Example entry**:
```markdown
## [2025-12-23 14:30:00] - Choose JWT with Refresh Tokens for Auth

**Context:**
Need authentication system for API. Previously considered session-based auth.

**Decision:**
Implement JWT with refresh tokens strategy.

**Rationale:**
- Stateless (scales better)
- Works well with modern SPAs
- Refresh tokens prevent long-lived JWTs
- Matches industry best practices

**Alternatives Considered:**
- Session-based auth: Rejected (harder to scale)
- OAuth provider only: Rejected (need self-hosted option)

**Implications:**
- Must secure refresh token storage
- Need token rotation strategy
- Client must handle token refresh flow
- Cache tokens carefully to prevent memory leaks
```

**Who updates it**: Auto-logged by `/rapidspec.proposal`, `/rapidspec.commit`, etc.

### 6. progress.md

**Purpose**: Work tracking across all features

**Contains**:
- Completed features
- Current work status
- Planned features
- Issues and technical debt
- Test coverage gaps
- Performance concerns

**Example section**:
```markdown
## Completed Work

### Shipped Features
- **User Authentication** 2025-12-15
  - Change ID: feature-auth
  - Implemented: JWT + refresh tokens
  - Tests: 95% coverage
  - Impact: Secures all API endpoints

## Current Work

### Active Changes
- **Real-time Notifications** - In Progress (Checkpoints 1-15/20)
  - Change ID: feature-notifications
  - Progress: Core WebSocket connection working, testing UI

## Technical Debt

### Known Issues
- **Auth token not clearing on logout** - Critical
  - Impact: User data could be exposed
  - Workaround: Manual browser cache clear
  - Status: Blocked waiting for browser API clarification
```

**Who updates it**: Auto-logged by `/rapidspec.commit`, `/rapidspec.archive`, `/rapidspec.umb`

## Viewing Your Memory Bank

### In Terminal

View any memory file:

```bash
# View progress
cat .rapidspec/memory/progress.md

# View active context
cat .rapidspec/memory/activeContext.md

# Search for a decision
grep -A5 "OAuth" .rapidspec/memory/decisionLog.md
```

### In Your Editor

Open files directly:

```bash
# Open in VS Code
code .rapidspec/memory/

# Open in vim
vim .rapidspec/memory/progress.md
```

### Search Across Files

Find all decisions about authentication:

```bash
grep -r "authentication\|auth\|JWT" .rapidspec/memory/
```

Find all TODOs or issues:

```bash
grep -r "TODO\|FIXME\|Issue" .rapidspec/memory/
```

## Best Practices

### ✅ Do

- **Initialize early**: Set up memory bank when starting a project
- **Update regularly**: Use `/rapidspec.umb` for insights during work
- **Review periodically**: Check memory bank during retrospectives
- **Keep it accurate**: Edit files if information becomes stale
- **Use for onboarding**: Share memory bank with new team members
- **Reference decisions**: When questions arise, check decisionLog.md

### ❌ Don't

- **Don't manually edit during development**: Use `/rapidspec.umb` instead
- **Don't treat as source of truth**: Git is the source of truth
- **Don't ignore it**: Memory without usage provides no value
- **Don't make sensitive info commitments**: Don't store secrets in memory bank
- **Don't update without context**: Always explain what changed and why

## Examples

### Example 1: Team Onboarding

New developer joins team. Show them memory bank:

1. **Read productContext.md** for architecture overview
2. **Review systemPatterns.md** for coding standards
3. **Check decisionLog.md** for why design was chosen
4. **Look at progress.md** for current features and status

Saves hours of "walking through the codebase" time!

### Example 2: Resuming Work After Break

You return to a feature after 2 weeks. Check activeContext.md:

```markdown
## Current Focus
- Change ID: feature-notifications
- Current checkpoint: 15/20
- Last work: "Completed WebSocket connection, next: UI implementation"

## Known Blockers
- Database migration pending
- Need to decide on notification delivery strategy

## Next Actions
- Implement notification UI component
- Test with multiple concurrent users
```

Perfect! You're back up to speed in 2 minutes instead of 30.

### Example 3: Code Review

Reviewing someone's code? Check decisionLog.md for context:

```markdown
## [2025-12-15] - Use Cursor-Based Pagination

**Rationale:**
Offset pagination fails at scale (slow for large offsets)
Cursor-based: O(1) lookup regardless of position

**Implications:**
Client must track cursor, can't jump to specific page
Must maintain stable sort order
```

Now you understand the design intent, not just the code!

## Troubleshooting

### Memory bank was deleted, how do I recreate it?

```bash
# Reinitialize
/rapidspec.constitution

# It will:
# - Re-create .rapidspec/memory/ directory
# - Recover context from git history
# - Re-analyze codebase
# - You may lose session-specific notes but keep structural data
```

### How do I collaborate on memory bank with my team?

Memory bank is git-tracked (in `.rapidspec/memory/`), so:

1. **Commit memory bank files** like any other code
2. **Pull changes** when team updates them
3. **Resolve conflicts** if both update same file
4. **Share in PRs** - reference decisions when explaining code

### Memory bank is too large, should I archive old entries?

Memory bank growth is normal:

- **Progress.md**: Grows (archive old by summarizing quarterly)
- **DecisionLog.md**: Grows (older decisions stay relevant)
- **ActiveContext.md**: Mostly overwrites (usually same size)

Periodic cleanup:

```bash
# Summarize old work (keep last 6 months active, archive rest)
/rapidspec.umb "Archived 2025 Q1-Q2 work: 12 features, 45 bug fixes"
```

### What's the difference between memory bank and git history?

| Aspect | Git History | Memory Bank |
|--------|------------|-------------|
| What | Code changes | Context and reasoning |
| Format | Diffs | Narrative |
| Searchable | By commit message | By topic/keyword |
| Human-friendly | With good messages | Always |
| Editing | Immutable | Can update |
| Purpose | Track what changed | Understand why |

Use together! Git is "what", memory bank is "why".

## Advanced Usage

### Custom Memory Bank Initialization

Control how memory bank is initialized:

```bash
# Reinitialize with specific project scope
/rapidspec.constitution Update memory bank for microservices architecture

# Add specific context
/rapidspec.constitution Add governance for API versioning and backwards compatibility
```

### Multi-Phase Updates

Update memory during different phases:

```bash
# During planning
/rapidspec.umb "Evaluated 3 notification approaches, chose WebSocket for real-time requirements"

# During implementation
/rapidspec.umb "Implementing WebSocket with Socket.io library, fallback to polling"

# During review
/rapidspec.umb "Review identified security issue: token expiry validation missing"

# During deployment
/rapidspec.umb "Feature shipped in v2.1, users can now receive real-time notifications"
```

### Integration with Your Workflow

**With Git commits:**
```bash
# Commit code
git add .
git commit -m "feat: add WebSocket notifications"

# Update memory (automatic)
→ progress.md updated with commit info

# Additional context
/rapidspec.umb "Notifications architecture: one WebSocket per client, pub/sub for broadcasting"
```

**With team standup:**
```bash
# Before standup
cat .rapidspec/memory/activeContext.md | grep -A10 "Current Focus"

# After standup
/rapidspec.umb "Standup 2025-12-24: notifications 70% done, next: load testing"
```

---

## Resources

- [Memory Bank Integration Guide](../MEMORY_BANK_INTEGRATION.md) - Technical integration details
- [RapidSpec Instructions](../AGENTS.md) - AI agent workflow including memory bank
- [RapidSpec README](../README.md) - Project overview
