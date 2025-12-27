# SHAI - RapidSpec Quick Start
**Note:** The `.rapidspec/` folder with memory bank and configuration files has been created in this directory.


This project was initialized with **SHAI** on [TIMESTAMP].

**Project Location:** `[PROJECT_PATH]`

## RapidSpec Commands (10 Total)

### Core Workflow
1. **`/rapidspec.constitution`** - Define project principles, architectural decisions, and development standards
2. **`/rapidspec.proposal`** - Plan a new feature with detailed specification and verification
3. **`/rapidspec.apply`** - Implement the approved specification
4. **`/rapidspec.review`** - Comprehensive code quality and security review
5. **`/rapidspec.commit`** - Create well-formatted commit with conventional format

### Advanced Commands
6. **`/rapidspec.archive`** - Archive deployed changes and update specifications
7. **`/rapidspec.triage`** - Review findings and add selected items to task list
8. **`/rapidspec.finalize`** - Complete workflow and archive the change
9. **`/rapidspec.resolve-parallel`** - Handle multiple tasks with dependency analysis
10. **`/rapidspec.umb`** - Update memory bank with session context

## Correct vs. Incorrect Workflow

✅ **Correct**:
```
rapidspec constitution → proposal → apply → review → commit
```

❌ **Incorrect**:
```
Start coding immediately without specification
Commit code before review
Skip memory bank updates
```

## Memory Bank System

RapidSpec uses a 6-file persistent context system (`.rapidspec/memory/`):

- **constitution.md** - Project principles and standards
- **productContext.md** - Feature scope and architecture
- **activeContext.md** - Current session state and decisions
- **systemPatterns.md** - Recurring patterns and conventions
- **decisionLog.md** - Technical decisions with rationale
- **progress.md** - Completed and current tasks

This enables AI to maintain context across sessions and coordinate with team members.

## Troubleshooting

**Q: Commands not recognized?**
A: Ensure you've run `rapidspec constitution` to initialize the memory bank first.

**Q: Memory bank not updating?**
A: Use `rapidspec umb` (Update Memory Bank) to sync session context.

**Q: How to review multiple PRs in parallel?**
A: Use `rapidspec resolve-parallel` to handle dependency analysis automatically.

## Learn More

- **RapidSpec GitHub**: https://github.com/rapidspec/rapidspec
- **SHAI Documentation**: https://github.com/ovh/shai
- **Specification Examples**: https://github.com/rapidspec/examples
