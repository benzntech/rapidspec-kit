# Cursor - RapidSpec Quick Start

This project was initialized with **Cursor** on [TIMESTAMP].

## RapidSpec Commands (10 Total)

This project includes 10 RapidSpec commands for specification-first development.

### Core Workflow (5 Essential Commands)

#### 1. `/rapidspec.constitution` - Define Project Principles
Sets up project governance and memory bank.
**When to use:** First

#### 2. `/rapidspec.proposal` - Create Change Proposal  
Plans feature with research and options.
**When to use:** Before implementation

#### 3. `/rapidspec.apply` - Implement with Checkpoints
Step-by-step implementation with approvals.
**When to use:** After proposal approved

#### 4. `/rapidspec.review` - Quality Assurance
Multi-agent code review (optional).
**When to use:** Before commit (optional)

#### 5. `/rapidspec.commit` - Document Changes
Creates commit and updates memory bank.
**When to use:** After apply

---

### Advanced Commands (5 Additional)

6. `/rapidspec.archive` - Mark complete
7. `/rapidspec.triage` - Categorize issues
8. `/rapidspec.finalize` - Prepare release
9. `/rapidspec.resolve-parallel` - Merge parallel features
10. `/rapidspec.umb` - Update memory bank

---

## Workflow

### ✅ CORRECT
```
Constitution → Proposal → Apply → Review → Commit → Archive
```

### ❌ AVOID
- Skip proposal, jump to apply
- Use old `speckit.*` commands
- Ignore review for major changes
- Skip memory updates

---

## Memory Bank

6 files in `.rapidspec/memory/`:

- `constitution.md` - Governance
- `productContext.md` - Architecture  
- `activeContext.md` - Current work
- `systemPatterns.md` - Patterns
- `decisionLog.md` - Decisions
- `progress.md` - Work history

---

## Quick Reference

| What to do | Command |
|-----------|---------|
| Set principles | `/rapidspec.constitution` |
| Plan feature | `/rapidspec.proposal [name]` |
| Implement | `/rapidspec.apply [change-id]` |
| Quality check | `/rapidspec.review [change-id]` |
| Save work | `/rapidspec.commit [change-id]` |
| Mark complete | `/rapidspec.archive [change-id]` |
| Record decision | `/rapidspec.umb [description]` |

---

## Troubleshooting

**Commands not appearing?**
- Verify project root directory
- Check `.cursor/commands/` folder exists

**Which command to use?**
- New feature → `/rapidspec.proposal`
- Implementing → `/rapidspec.apply`
- Quality check → `/rapidspec.review`
- Saving → `/rapidspec.commit`

---

## Learn More

- Full workflow: `AGENTS.md`
- Project info: `.rapidspec/memory/productContext.md`
- Cursor: [cursor.sh](https://cursor.sh)
- RapidSpec: [github.com/benzntech/rapidspec-kit](https://github.com/benzntech/rapidspec-kit)

---

*Generated for Cursor on [TIMESTAMP] by RapidSpec Init*
