# GitHub Copilot - RapidSpec Quick Start
**Note:** The `.rapidspec/` folder with memory bank and configuration files has been created in this directory.


This project was initialized with **GitHub Copilot** on [TIMESTAMP].

**Project Location:** `[PROJECT_PATH]`

## RapidSpec Commands (10 Total)

This project includes **10 RapidSpec commands** for specification-first development.

### Core Workflow (5 Essential Commands)

#### 1. `/rapidspec.constitution` - Define Project Principles

Creates project governance and 6-file memory bank.

**When to use:** First - after initializing project

#### 2. `/rapidspec.proposal` - Create Change Proposal

Plans feature with research and 2-3 options.

**When to use:** Before any implementation

#### 3. `/rapidspec.apply` - Implement with Checkpoints

Implements step-by-step with approval at each checkpoint.

**Controls:** `gg` (continue), `wait` (pause), `no` (skip)

**When to use:** After proposal approved

#### 4. `/rapidspec.review` - Quality Assurance

Multi-agent code review covering security, architecture, performance.

**When to use:** Optional - recommended for major changes

#### 5. `/rapidspec.commit` - Document Changes

Creates commit message and updates memory bank.

**When to use:** After apply and review

---

### Advanced Commands (5 Additional)

6. `/rapidspec.archive` - Mark feature complete
7. `/rapidspec.triage` - Categorize issues
8. `/rapidspec.finalize` - Prepare release
9. `/rapidspec.resolve-parallel` - Merge parallel features
10. `/rapidspec.umb` - Update memory bank

---

## Workflow

### ✅ CORRECT

```
Constitution → Proposal → Apply → Review (optional) → Commit → Archive
```

### ❌ INCORRECT

- Skip proposal, jump to apply
- Use old `speckit.*` commands
- Ignore review for major changes
- Skip memory bank updates

---

## Memory Bank System

6 files in `.rapidspec/memory/`:

- `constitution.md` - Governance
- `productContext.md` - Architecture
- `activeContext.md` - Current work
- `systemPatterns.md` - Patterns
- `decisionLog.md` - Decisions
- `progress.md` - Work history

---

## Quick Reference

| Command | Purpose | When to Use |
|---------|---------|-----------|
| `/rapidspec.constitution` | Set principles | First |
| `/rapidspec.proposal` | Plan feature | Before implementation |
| `/rapidspec.apply` | Implement | After proposal |
| `/rapidspec.review` | Quality check | Before commit (optional) |
| `/rapidspec.commit` | Save + document | After apply |
| `/rapidspec.archive` | Mark complete | After deploy |
| `/rapidspec.umb` | Update memory | Anytime during work |

---

## Troubleshooting

**Q: Commands not appearing?**
- Verify in project root
- Check `.github/commands/` folder exists
- Copilot may need refresh

**Q: Which command to use?**
- New feature? → `/rapidspec.proposal`
- Implementing? → `/rapidspec.apply`
- Quality check? → `/rapidspec.review`
- Saving work? → `/rapidspec.commit`

**Q: Memory not updating?**
- Auto-updates with `/rapidspec.commit` and `/rapidspec.archive`
- Manual: `/rapidspec.umb`

---

## Learn More

**In Project:**
- Full workflow: `AGENTS.md`
- Project info: `.rapidspec/memory/productContext.md`
- Decisions: `.rapidspec/memory/decisionLog.md`

**External:**
- Copilot Docs: [docs.github.com/copilot](https://docs.github.com/copilot)
- RapidSpec: [github.com/benzntech/rapidspec-kit](https://github.com/benzntech/rapidspec-kit)

---

*Generated for GitHub Copilot on [TIMESTAMP] by RapidSpec Init*
