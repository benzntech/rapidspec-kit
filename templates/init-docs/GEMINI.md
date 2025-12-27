# Gemini CLI - RapidSpec Quick Start

This project was initialized with **Gemini CLI** on [TIMESTAMP].

**Note:** The `.rapidspec/` folder with memory bank and configuration files has been created in this directory.

## RapidSpec Commands (10 Total)

This project includes **10 RapidSpec commands** designed for specification-first development with AI.

All commands are available as slash commands: `/rapidspec.*`

### Core Workflow (5 Essential Commands)

#### 1. `/rapidspec.constitution` - Define Project Principles

**What it does:**
- Initializes project governance and core principles
- Creates 6-file memory bank with project context
- Documents development standards and conventions
- Establishes team standards and workflow

**When to use:** **FIRST** - After initializing the project

**Output Files:**
- `.rapidspec/memory/constitution.md` - Project governance
- `.rapidspec/memory/productContext.md` - Architecture & tech stack
- `.rapidspec/memory/activeContext.md` - Current work tracking
- `.rapidspec/memory/systemPatterns.md` - Coding patterns
- `.rapidspec/memory/decisionLog.md` - Decision history
- `.rapidspec/memory/progress.md` - Work tracking

---

#### 2. `/rapidspec.proposal` - Create Change Proposal

**What it does:**
1. Verifies actual code (prevents hallucinations)
2. Researches best practices
3. Checks git history
4. Proposes 2-3 implementation options
5. Waits for your decision

**When to use:** **BEFORE any implementation** - For every new feature

**Example:**
```
/rapidspec.proposal add authentication system
→ Receives 3 options with pros/cons
→ You choose option 1
→ Gets proposal.md, tasks.md, spec deltas
```

---

#### 3. `/rapidspec.apply` - Implement with Checkpoints

**What it does:**
- Reads proposal and implements step-by-step
- Shows diffs before each change
- Pauses at checkpoints for approval
- Supports direction changes mid-implementation

**Checkpoint Controls:**
- `"gg"` or `"go"` - Continue to next task
- `"wait"` or `"잠깐"` - Pause and revise
- `"no"` or `"아니"` - Skip or change approach

**When to use:** **AFTER proposal is approved**

---

#### 4. `/rapidspec.review` - Quality Assurance (Optional)

**What it does:**
- Runs multi-agent code review
- Checks: Security, Architecture, Performance, Testing
- Identifies Critical vs Warning issues
- Provides actionable fixes

**When to use:** **OPTIONAL** - Recommended for major changes

**Reviewers:**
- 🔒 Security Auditor
- 🏗️ Architecture Strategist
- 💻 Code Reviewer
- 📊 Database Architect
- 🧪 Test Reviewer
- ⚡ Performance Oracle
- ✔️ Code Verifier

---

#### 5. `/rapidspec.commit` - Document Changes

**What it does:**
- Creates conventional commit message
- Updates memory bank automatically
- Records decision rationale with timestamp
- Preserves context for future team members

**When to use:** **AFTER apply and review**

**Memory Bank Updates:**
- `decisionLog.md` - Decision recorded
- `activeContext.md` - Work status updated
- `progress.md` - Completed work logged

---

### Advanced Commands (5 Additional)

#### 6. `/rapidspec.archive` - Mark Feature Complete

Move feature to completed work log after deployment.

#### 7. `/rapidspec.triage` - Categorize Issues

Intelligent issue classification and prioritization.

#### 8. `/rapidspec.finalize` - Prepare Release

Release preparation and deployment workflow.

#### 9. `/rapidspec.resolve-parallel` - Merge Parallel Features

Handle conflicts when multiple features are in progress.

#### 10. `/rapidspec.umb` - Update Memory Bank

Manual memory bank updates during work.

---

## Workflow: Correct vs. Incorrect

### ✅ CORRECT WORKFLOW

```
Constitution (principles)
    ↓
Proposal (plan + options)
    ↓
Apply (implement with checkpoints)
    ↓
Review (quality check - optional)
    ↓
Commit (save + document)
    ↓
Archive (mark complete)
```

### ❌ NEVER DO THIS

- ❌ Skip proposal, jump straight to apply (leads to hallucinations)
- ❌ Use old `speckit.*` commands (removed in v0.0.8)
- ❌ Ignore review for major changes (misses critical issues)
- ❌ Skip memory bank updates (loses context)
- ❌ Implement without proposal (wrong approach)

---

## Memory Bank System

**6-file memory bank** in `.rapidspec/memory/`:

| File | Purpose |
|------|---------|
| `constitution.md` | Project principles & governance |
| `productContext.md` | Architecture & tech stack |
| `activeContext.md` | Current work & objectives |
| `systemPatterns.md` | Coding patterns & conventions |
| `decisionLog.md` | Technical decisions with rationale |
| `progress.md` | Work history & roadmap |

**Usage:**
- Read at session start to understand context
- Update with `/rapidspec.umb` during work
- Auto-updated by `/rapidspec.commit` and `/rapidspec.archive`

---

## Troubleshooting

### Q: Commands Not Appearing?

**A:** 
1. Verify you're in project root directory
2. Check `.gemini/commands/` folder exists
3. Gemini CLI may need to refresh context
4. All `/rapidspec.*.md` files should be present

### Q: Which Command to Use?

**A:** Decision tree:
- New feature? → `/rapidspec.proposal`
- Know what to build? → `/rapidspec.apply`
- Want quality check? → `/rapidspec.review`
- Ready to save? → `/rapidspec.commit`
- Feature deployed? → `/rapidspec.archive`
- Recording decision? → `/rapidspec.umb`

### Q: Memory Bank Not Updating?

**A:** Auto-updates with:
- `/rapidspec.commit` - After implementation
- `/rapidspec.archive` - When feature completes
- `/rapidspec.umb` - For manual updates

### Q: Made a Mistake in Apply?

**A:** Use checkpoint controls:
- `"wait"` - Pause and revise
- `"no"` - Skip or restart
- Continue or change direction

---

## Pro Tips

### 💡 Tip 1: Test at Checkpoints

Use apply checkpoints to test locally before continuing.

### 💡 Tip 2: Read Proposal First

Always read `proposal.md` before running apply to understand the plan.

### 💡 Tip 3: Update Memory During Work

Use `/rapidspec.umb` to capture decisions as you work.

### 💡 Tip 4: Review Before Commit

For major features: apply → review → commit

### 💡 Tip 5: Check Progress Anytime

View `.rapidspec/memory/progress.md` for completed and planned work.

---

## Learn More

**In Your Project:**
- Full workflow: `AGENTS.md`
- Project info: `.rapidspec/memory/productContext.md`
- Past decisions: `.rapidspec/memory/decisionLog.md`
- Code patterns: `.rapidspec/memory/systemPatterns.md`

**External:**
- Gemini CLI: [geminicli.com/docs](https://geminicli.com/docs/)
- RapidSpec GitHub: [github.com/benzntech/rapidspec-kit](https://github.com/benzntech/rapidspec-kit)
- Google AI: [ai.google.dev](https://ai.google.dev)

---

## Next Steps

1. Read `AGENTS.md` - Full RapidSpec workflow
2. Run `/rapidspec.constitution` - Set up principles
3. Create first proposal - `/rapidspec.proposal [feature]`
4. Follow the workflow - Apply → Review → Commit → Archive
5. Update memory bank - Use `/rapidspec.umb` during work

---

*Generated for Gemini CLI on [TIMESTAMP] by RapidSpec Init*

*Questions? Check [geminicli.com/docs](https://geminicli.com/docs/) or your project's AGENTS.md file*
