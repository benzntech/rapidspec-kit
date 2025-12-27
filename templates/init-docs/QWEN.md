# Qwen Code - RapidSpec Quick Start
**Note:** The `.rapidspec/` folder with memory bank and configuration files has been created in this directory.


This project was initialized with **Qwen Code** on [TIMESTAMP].

## RapidSpec Commands (10 Total)

### Core Workflow (5 Commands)

1. `/rapidspec.constitution` - Define principles | **First**
2. `/rapidspec.proposal` - Plan feature | **Before impl**
3. `/rapidspec.apply` - Implement with checkpoints | **After proposal**
4. `/rapidspec.review` - Quality check (optional) | **Before commit**
5. `/rapidspec.commit` - Save & document | **After apply**

### Advanced (5 Commands)

6. `/rapidspec.archive` - Mark complete
7. `/rapidspec.triage` - Categorize issues
8. `/rapidspec.finalize` - Prepare release
9. `/rapidspec.resolve-parallel` - Merge parallel features
10. `/rapidspec.umb` - Update memory bank

---

## Workflow

✅ **CORRECT**: Constitution → Proposal → Apply → Review → Commit → Archive

❌ **AVOID**: Skip proposal | Use old commands | Ignore review | Skip memory updates

---

## Memory Bank (6 files in `.rapidspec/memory/`)

- `constitution.md` - Governance
- `productContext.md` - Architecture
- `activeContext.md` - Current work
- `systemPatterns.md` - Patterns
- `decisionLog.md` - Decisions
- `progress.md` - Work history

---

## Quick Reference

| Task | Command |
|------|---------|
| Set principles | `/rapidspec.constitution` |
| Plan feature | `/rapidspec.proposal [name]` |
| Implement | `/rapidspec.apply [change-id]` |
| Quality check | `/rapidspec.review [change-id]` |
| Save work | `/rapidspec.commit [change-id]` |
| Complete | `/rapidspec.archive [change-id]` |
| Record decision | `/rapidspec.umb [description]` |

---

## Troubleshooting

**Commands missing?** Check project root, verify `.qwen/commands/` exists

**Which command?** New feature → `/rapidspec.proposal`, Implementing → `/rapidspec.apply`

**Memory not updating?** Use `/rapidspec.commit` or `/rapidspec.umb`

---

## Learn More

- Workflow: `AGENTS.md`
- Context: `.rapidspec/memory/productContext.md`
- Decisions: `.rapidspec/memory/decisionLog.md`
- Qwen: [github.com/QwenLM/qwen-code](https://github.com/QwenLM/qwen-code)
- RapidSpec: [github.com/benzntech/rapidspec-kit](https://github.com/benzntech/rapidspec-kit)

---

*Generated for Qwen Code on [TIMESTAMP] by RapidSpec Init*
