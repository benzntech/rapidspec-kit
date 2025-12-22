# RapidSpec-Kit Constitution

## Core Principles

### I. Specification-First Development

Specifications are the source of truth and foundation for all development. Before any code is written:
- All requirements, design decisions, and behavioral expectations are documented in proposal.md and spec files
- Proposals include research, alternatives, impact analysis, and explicit tradeoffs
- Code verification prevents "imaginary code" - AI agents must read actual files, not assume implementations
- Specifications generate implementations, not the reverse

### II. Checkpoint-Based Implementation

All code changes follow a pausable, verifiable workflow with explicit checkpoints:
- Each implementation task is small (5-10 minutes) and independently testable
- Before-and-after diffs are shown for every file change requiring user approval
- Users can pause (wait), skip (no), or redirect (custom) at any checkpoint
- No batch changes without intermediate verification - one task, one checkpoint, one approval cycle
- Direction changes are welcomed mid-implementation; the process adapts, not abandons

### III. Automated Quality Review

Quality review is systematic and specialized, not ad-hoc:
- Multi-agent review covers security, architecture, code quality, database safety, testing, APIs, and components
- Review is optional but recommended: users choose based on risk/time tradeoff
- Critical findings block commits; warnings are informational; suggestions are nice-to-have
- Review agents verify actual code changes, not design documents

### IV. Explicit Verification & Prevention of Hallucination

AI agents must verify before proposing; hallucination is a critical failure:
- Agents read actual codebase files before making design decisions
- Git history is checked to understand existing patterns and avoid reimplementing
- Best practices are researched (not assumed) via web search or reference repositories
- Code verification agents explicitly check that proposed changes are actually implementable
- If a file doesn't exist or code isn't as described, this is surfaced immediately

### V. Traceable & Recoverable Changes

All changes are tracked, documented, and can be reverted or resumed:
- Each change has a unique ID with proposal.md, tasks.md, and spec delta files
- Completed changes are archived (timestamped) after deployment
- specs/ directory maintains canonical state; changes/ tracks proposals
- Git commits are conventional format with links to proposal IDs
- Progress is tracked through task.md with before/after checkboxes

### VI. Task-Driven Implementation

Implementation follows an explicit, checkpointed task breakdown:
- proposal.md generates tasks.md with estimated effort for each task
- Each task has a clear acceptance criterion (checkpoint)
- Tasks are marked complete only when actually implemented and verified
- Discovered work (unplanned tasks) is captured during implementation, not ignored
- Tasks can be reordered, skipped, or modified based on user direction

## Development Workflow Standards

### Proposal Phase
- Must include: What, Why, Impact, 2-3 Options with pros/cons/effort estimates
- Must verify actual code state; no assumptions about existing implementations
- Must research best practices for the specific technology/pattern
- User chooses option before implementation begins

### Implementation Phase
- Implement one task at a time (5-10 minute tasks)
- Show diff before applying each change
- Pause at checkpoints for approval
- Update tasks.md as you complete each task
- Capture discovered work (unplanned tasks that emerge during implementation)

### Review Phase (Optional)
- Run after implementation if risk/complexity warrants review
- Covers: security, architecture, code quality, database, testing, APIs, components
- Surfaced findings are triaged: accept/defer/skip
- Critical issues block commit; others are documented

### Commit Phase
- Generate conventional commits matching tasks completed
- Link to proposal ID in commit message
- Match commits to actual task completion (not just file changes)
- Include discovered work in commit message

### Archive Phase
- Archive change after deployment: move to changes/archive/TIMESTAMP-id/
- Merge spec deltas into canonical specs/ directory
- Validate merged state matches deployment reality
- Close related issues/tickets

## Code Quality Standards

### Verification
- All proposed solutions must be verified against actual codebase
- Complex logic must be shown in diffs before changes are applied
- Edge cases and error scenarios must be considered in proposals

### Testing
- New features should have tests (unit, integration, or e2e as appropriate)
- Test coverage is reviewed but not required to be 100%
- Critical paths (auth, payment, security) require explicit test coverage

### Documentation
- Complex implementations require explanation in code comments or README updates
- API changes require documentation updates
- Breaking changes require migration guides

## Technology Standards

### Language & Framework Agnostic
- RapidSpec works with any language or framework
- Each project defines its own tech stack standards (documented in constitution amendments)
- Tool-specific guidance is captured in GUIDANCE.md file, not this constitution

### CLI & Observability
- Tools and libraries should expose CLI interfaces where feasible
- Errors go to stderr; results to stdout
- Support both JSON and human-readable output formats

## Governance

### Constitution Authority
- This constitution supersedes all other development practices and guidelines
- Changes to this constitution require explicit documentation of the amendment, rationale, and migration plan
- New projects may extend this constitution with project-specific amendments in a "Project Constitution" section
- Amendment history is tracked with dates and rationale

### Code Review & Compliance
- All PRs must verify alignment with this constitution
- Complexity introduced by code must be justified against constitutional principles
- Trade-offs that deviate from constitution must be explicit and approved

### Amendment Process
1. Identify the principle or standard that needs change
2. Document proposed amendment with rationale
3. Update constitution with new version number and date
4. Notify project team of changes
5. Document any migration steps needed for existing projects

## Amendment History

### v1.1.0 (2025-12-22)
**Amendment**: Complete project rebrand from "speckit" to "rapidspec"

**Rationale**: Align all technical artifacts with RapidSpec-Kit brand identity across the entire toolchain, including command namespaces, CLI tools, package names, directory structures, and release packages.

**Impact**:
- All command namespaces changed: `/speckit.*` → `/rapidspec.*`
- CLI tool renamed: `specify` → `rapidspec`
- Package name renamed: `specify-cli` → `rapidspec-cli`
- User project directory: `.specify/` → `.rapidspec/`
- Release packages: `spec-kit-template-*` → `rapidspec-template-*`
- Version: 0.0.22 → 0.1.0 (breaking change)

**Migration**: Deprecation period in v0.1.0 supports both `/speckit.*` and `/rapidspec.*` commands with warnings on old commands. Old commands will be removed in v0.2.0.

**Version**: 1.1.0 | **Ratified**: 2025-12-22 | **Last Amended**: 2025-12-22
