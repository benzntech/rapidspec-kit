# Claude Code - RapidSpec Quick Start

This project was initialized with **Claude Code** on [TIMESTAMP].

## RapidSpec Commands (10 Total)

This project includes **10 RapidSpec commands** designed for specification-first development with AI.

All commands are available as slash commands in Claude Code: `/rapidspec.*`

### Core Workflow (5 Essential Commands)

#### 1. `/rapidspec.constitution` - Define Project Principles

```
/rapidspec.constitution Create principles focused on code quality, testing, and user experience
```

**What it does:**
- Initializes project governance and core principles
- Creates 6-file memory bank with project context
- Documents development standards and conventions
- Establishes team standards and workflow

**When to use:** **FIRST** - After initializing the project

**Output Files Created:**
- `.rapidspec/memory/constitution.md` - Project governance
- `.rapidspec/memory/productContext.md` - Architecture & tech stack
- `.rapidspec/memory/activeContext.md` - Current work tracking
- `.rapidspec/memory/systemPatterns.md` - Coding patterns
- `.rapidspec/memory/decisionLog.md` - Decision history
- `.rapidspec/memory/progress.md` - Work tracking

**Key Point:** This command only needs to run **once per project**. It populates the memory bank with intelligent defaults based on your codebase.

---

#### 2. `/rapidspec.proposal` - Create Change Proposal

```
/rapidspec.proposal add user authentication system
```

**What it does:**
1. **Verifies actual code** - Reads your files to prevent hallucinations
2. **Researches best practices** - WebSearch for patterns and examples
3. **Checks git history** - Understands past decisions
4. **Proposes 2-3 options** - With pros/cons/costs for each
5. **Waits for your decision** - Responds to: `1`, `2`, `3`, or `yes`

**When to use:** **BEFORE any implementation** - For every new feature or major change

**Example Flow:**
```
You: /rapidspec.proposal add user authentication
Claude: Running investigation and research...
Claude: Here are 3 options for auth:
  Option 1: JWT with RS256 ⭐ (Time: 3h, Risk: Low)
  Option 2: Session-based (Time: 2h, Risk: Medium)
  Option 3: OAuth2 (Time: 4h, Risk: Medium)
You: 1
Claude: Creates proposal.md, tasks.md, and spec deltas
```

**Output:**
- `rapidspec/changes/<change-id>/proposal.md` - Full proposal with research
- `rapidspec/changes/<change-id>/tasks.md` - Step-by-step tasks
- `rapidspec/changes/<change-id>/investigation.md` - Code analysis findings
- `rapidspec/changes/<change-id>/research.md` - Best practices researched

---

#### 3. `/rapidspec.apply` - Implement with Checkpoints

```
/rapidspec.apply add-user-authentication
```

**What it does:**
1. **Reads proposal** - Understands the plan
2. **Implements step-by-step** - Each task is 5-10 minutes
3. **Shows diffs** - Before → After for each change
4. **Pauses at checkpoints** - Waits for approval before next step
5. **Supports direction changes** - Can modify approach mid-implementation

**Checkpoint Controls:**
- `"gg"` or `"go"` - Continue to next task
- `"wait"` or `"잠깐"` - Pause and revise current task
- `"no"` or `"아니"` - Skip this task or change approach

**When to use:** **AFTER proposal is approved** - For implementation

**Example Flow:**
```
Claude: Implementing task 1/5: Create database schema
        [Shows diff]
        Ready? (gg/wait/no)
You: gg

Claude: Implementing task 2/5: Create API endpoints
        [Shows diff]
        Ready? (gg/wait/no)
You: wait
Claude: What needs to change?
You: Add error handling for duplicate emails
Claude: [Revises current task]
```

**Key Features:**
- ✅ Incremental implementation (easy to review)
- ✅ Early exit (can pause and test)
- ✅ Reversible (each checkpoint is a save point)
- ✅ Adaptive (can change direction)

---

#### 4. `/rapidspec.review` - Quality Assurance (Optional)

```
/rapidspec.review add-user-authentication
```

**What it does:**
- Runs **multi-agent code review** (7+ specialized reviewers)
- Checks: Security, Architecture, Performance, Testing, Database Safety
- Identifies **Critical** issues (must fix) vs **Warning** issues (should fix)
- Provides actionable fixes with code examples

**Reviewers:**
- 🔒 **Security Auditor** - Checks auth, permissions, input validation
- 🏗️ **Architecture Strategist** - Reviews structure and patterns
- 💻 **Code Reviewer** - Checks code quality and maintainability
- 📊 **Database Architect** - Validates schema and migrations
- 🧪 **Test Reviewer** - Checks test coverage
- ⚡ **Performance Oracle** - Identifies performance issues
- ✔️ **Code Verifier** - Prevents "imaginary code"

**When to use:** **OPTIONAL** - Recommended for major changes

**Severity Levels:**
- ❌ **Critical** (red) - Blocks commit, must fix
- ⚠️ **Warning** (yellow) - Should fix, non-blocking
- ℹ️ **Info** (blue) - Nice to have

---

#### 5. `/rapidspec.commit` - Document Changes

```
/rapidspec.commit add-user-authentication
```

**What it does:**
1. **Creates conventional commit** - Proper git message format
2. **Updates memory bank** - Logs decision with timestamp
3. **Records rationale** - Why this approach was chosen
4. **Preserves context** - For future team members

**Memory Bank Updates:**
- `decisionLog.md` - Records the decision made
- `activeContext.md` - Updates current work status
- `progress.md` - Logs completed work

**When to use:** **AFTER apply and review** - Before pushing to git

---

### Advanced Commands (5 Additional)

#### 6. `/rapidspec.archive` - Mark Feature Complete

```
/rapidspec.archive add-user-authentication
```

Move feature to completed work log after deployment.

#### 7. `/rapidspec.triage` - Categorize Issues

```
/rapidspec.triage
```

Intelligent issue classification and prioritization.

#### 8. `/rapidspec.finalize` - Prepare Release

```
/rapidspec.finalize v1.0.0
```

Release preparation and deployment workflow.

#### 9. `/rapidspec.resolve-parallel` - Merge Parallel Features

```
/rapidspec.resolve-parallel
```

Handle conflicts when multiple features are in progress.

#### 10. `/rapidspec.umb` - Update Memory Bank

```
/rapidspec.umb Decided to use JWT with RS256 for better cross-domain support
```

Manual memory bank updates during work (between commits).

---

## Workflow: Correct vs. Incorrect

### ✅ CORRECT WORKFLOW (Always Follow This)

```
┌─────────────────────────────────┐
│ Step 1: Constitution            │ ← Run ONCE per project
│ /rapidspec.constitution         │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│ Step 2: Proposal                │ ← Run for each feature
│ /rapidspec.proposal [feature]   │
│ Choose: 1, 2, or 3              │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│ Step 3: Apply                   │ ← Implementation
│ /rapidspec.apply [change-id]    │
│ Approve each checkpoint          │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│ Step 4: Review (Optional)       │ ← Quality check
│ /rapidspec.review [change-id]   │
│ Fix critical issues             │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│ Step 5: Commit                  │ ← Save & document
│ /rapidspec.commit [change-id]   │
│ Memory bank auto-updated        │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│ Step 6: Archive (After Deploy)  │ ← Completion
│ /rapidspec.archive [change-id]  │
│ Feature marked complete         │
└─────────────────────────────────┘
```

### ❌ INCORRECT PATTERNS (Never Do This)

| ❌ Mistake | 📝 Why It's Wrong | ✅ Correct Approach |
|-----------|------------------|-------------------|
| Skip `/rapidspec.proposal`, jump straight to `/rapidspec.apply` | No specification = hallucinations, incorrect implementation, wasted time | Always start with proposal to understand options |
| Use old `speckit.*` commands | Commands removed in v0.0.8, not available | Use `/rapidspec.*` instead (with dot) |
| Ignore `/rapidspec.review` for major changes | Security/architecture issues caught during review, too late to fix | Run review before commit |
| Skip memory bank updates | Team loses context, decision rationale is forgotten | Use `/rapidspec.commit` which auto-updates |
| Make code changes without proposal | Works in small projects, breaks at scale | Verify with proposal first |
| Implement without reading proposal tasks | Miss important steps, implement wrong approach | Read tasks.md before implementing |

---

## Memory Bank System

Your project has a **6-file memory bank** in `.rapidspec/memory/`:

| File | Purpose | Who Updates It | When |
|------|---------|---|---|
| **constitution.md** | Project principles, governance, standards | Team consensus | Rarely (major principle changes) |
| **productContext.md** | Architecture, tech stack, components | Auto-populated + manual | During init, then rarely |
| **activeContext.md** | Current work, objectives, blockers | `/rapidspec.umb`, `/rapidspec.commit` | Every session |
| **systemPatterns.md** | Coding patterns, conventions | `/rapidspec.umb` | When new patterns emerge |
| **decisionLog.md** | Technical decisions with rationale | `/rapidspec.commit`, `/rapidspec.archive` | After each feature |
| **progress.md** | Work history, completed features | `/rapidspec.commit`, `/rapidspec.archive` | After each feature |

**How to Use:**
- **Read at start of session**: Understand current context and goals
- **Update during work**: Use `/rapidspec.umb` for decisions
- **Auto-update on commit**: `/rapidspec.commit` logs everything
- **Archive when done**: `/rapidspec.archive` marks completion

---

## Common Questions & Troubleshooting

### Q: Commands Not Appearing in Claude Code?

**A:** 
1. Make sure you're in the project root directory
2. Claude Code may need to refresh context (try reopening the project)
3. Verify `.claude/commands/` folder exists with RapidSpec files
4. Check that all `/rapidspec.*.md` files are present

### Q: Which Command Should I Use?

**A:** Use this decision tree:

```
What do you want to do?
├─ Starting new feature? → /rapidspec.proposal
├─ Know what to build? → /rapidspec.apply
├─ Want quality check? → /rapidspec.review
├─ Ready to save work? → /rapidspec.commit
├─ Feature deployed? → /rapidspec.archive
├─ Have a decision? → /rapidspec.umb
└─ Not sure? → Read this file again!
```

### Q: Memory Bank Not Updating?

**A:** Memory bank auto-updates with:
- `/rapidspec.commit` - After implementation
- `/rapidspec.archive` - When feature completes
- `/rapidspec.umb` - For manual updates anytime

### Q: Made a Mistake in `/rapidspec.apply`?

**A:** During apply, use checkpoint controls:
- `"wait"` - Pause and revise current task
- `"no"` - Skip task or change approach
- Can continue or restart the feature

### Q: Not Sure I'm Using RapidSpec Correctly?

**A:** Check these resources:

**In Your Project:**
- **Full workflow**: See `AGENTS.md` in project root
- **Project info**: `.rapidspec/memory/productContext.md`
- **Past decisions**: `.rapidspec/memory/decisionLog.md`
- **Code patterns**: `.rapidspec/memory/systemPatterns.md`

**External:**
- **RapidSpec GitHub**: [github.com/benzntech/rapidspec-kit](https://github.com/benzntech/rapidspec-kit)
- **Claude Code Docs**: [code.claude.com/docs](https://code.claude.com/docs/en/overview)
- **Best Practices**: [Anthropic Engineering Blog](https://www.anthropic.com/engineering/claude-code-best-practices)

---

## Pro Tips

### 💡 Tip 1: Use Checkpoints for Testing

In `/rapidspec.apply`, pause at checkpoints to test your changes:

```
Claude: Implemented task 2/5: Add user endpoints
        Ready? (gg/wait/no)
You: wait
[You test the endpoints locally]
You: gg (continue if tests pass)
```

### 💡 Tip 2: Read Proposal Before Applying

Always read `rapidspec/changes/<change-id>/proposal.md` before running apply:
- Understand why options were chosen
- Review tasks before implementation
- Clarify any questions

### 💡 Tip 3: Update Memory During Development

Use `/rapidspec.umb` to capture decisions during work:

```
/rapidspec.umb Chose PostgreSQL for user data because of JSONB support for preferences
```

This creates a decision trail even before final commit.

### 💡 Tip 4: Review Before Committing

For major features, run review before commit:

```
/rapidspec.apply [change-id]  ← Implement
/rapidspec.review [change-id] ← Check quality
/rapidspec.commit [change-id] ← Save
```

### 💡 Tip 5: Check Progress Anytime

See what's been completed:

```
View: .rapidspec/memory/progress.md
Shows: Completed features, current WIP, planned work
```

---

## Next Steps

1. **Read AGENTS.md** - Full RapidSpec workflow documentation
2. **Run `/rapidspec.constitution`** - Set up project principles
3. **Create first proposal** - `/rapidspec.proposal [feature]`
4. **Follow the workflow** - Apply → Review → Commit → Archive
5. **Update memory bank** - Use `/rapidspec.umb` during work

---

*Generated for Claude Code on [TIMESTAMP] by RapidSpec Init*

*Questions? Check [code.claude.com/docs](https://code.claude.com/docs/en/overview) or your project's AGENTS.md file*
