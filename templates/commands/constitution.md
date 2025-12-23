---
name: RapidSpec Constitution
description: Initialize and update memory bank system with intelligent analysis
category: RapidSpec
tags: [rapidspec, memory, constitution, initialization]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: "[optional: update directive]"
---

# RapidSpec Constitution Command

Initialize and manage the memory bank system for project governance and context tracking.

## Usage

```bash
/rapidspec.constitution
# Initialize new memory bank with intelligent population

/rapidspec.constitution Add new security requirement to constitution
# Update existing memory bank with directive
```

## What This Does

The constitution command manages a 6-file memory bank:
1. **constitution.md** - Project governance and principles
2. **productContext.md** - Project scope, architecture, components
3. **activeContext.md** - Current work, objectives, blockers
4. **systemPatterns.md** - Coding and architectural patterns
5. **decisionLog.md** - Technical decisions and rationale
6. **progress.md** - Work tracking across all changes

---

## Implementation

### Step 1: Check Memory Bank Status

First, determine if memory bank exists and its state:

```python
import os
import glob

memory_dir = ".rapidspec/memory"
md_files = glob.glob(f"{memory_dir}/*.md")

if not os.path.exists(memory_dir):
    status = "UNINITIALIZED"
elif len(md_files) < 6:
    status = "PARTIAL"
elif len(md_files) == 6:
    status = "INITIALIZED"
else:
    status = "INITIALIZED"

print(f"Memory Bank Status: {status}")
print(f"Found: {len(md_files)} files")
```

### Step 2: Initialize Memory Bank (if UNINITIALIZED)

If `.rapidspec/memory` doesn't exist, create it with template files.

**Action**:
1. Create `.rapidspec/memory/` directory
2. Copy template files from `templates/memory/` to `.rapidspec/memory/`
3. Populate with intelligent defaults from codebase

**File Creation Order**:
```
.rapidspec/memory/
├── constitution.md       # Project governance
├── productContext.md     # Architecture & scope
├── activeContext.md      # Current work
├── systemPatterns.md     # Code patterns
├── decisionLog.md        # Decisions made
└── progress.md           # Work tracking
```

### Step 3: Intelligent Population

Analyze codebase and populate memory bank files with real context:

#### 3a. Analyze Project Structure

**Read**:
- `package.json` - Project name, description, version, dependencies
- `README.md` - Goals, tech stack, architecture
- Directory structure - Components, organization
- Source code files - Language detection

**Populate `productContext.md`**:
- Project Name from package.json or directory
- Description from package.json or README.md
- Technology Stack from dependencies and imports
- Directory Structure from file system
- Key Components from source analysis

#### 3b. Analyze Development Patterns

**Search codebase for**:
- Error handling patterns (try/catch, error boundary, error middleware)
- Async patterns (async/await, promises, callbacks)
- Module organization (imports, exports, dependencies)
- Testing patterns (test files, test structure)

**Populate `systemPatterns.md`**:
- Common error handling approaches
- Async/concurrency patterns used
- Code organization conventions
- Testing methodology

#### 3c. Extract Architectural Decisions

**Search for**:
- Recent commits with "feat:", "refactor:", "arch:" keywords
- Existing proposal.md or spec files
- Architecture documentation in README
- Code comments indicating decisions

**Populate `decisionLog.md`**:
- List recent significant decisions
- Include rationale where evident in commits
- Add timestamp of analysis

#### 3d. Track Progress

**Check for**:
- Active git branches
- changes/ directory with in-progress work
- Completed work in changes/archive/
- Recent git commits

**Populate `progress.md`**:
- Recent completed work from git history
- Any active branches or changes
- Overall project status

#### 3e. Current Context

**Set in `activeContext.md`**:
- Current branch name
- Recent activity summary
- Initial objectives list (empty, ready for user input)

### Step 4: Add Timestamps

All template files contain `[TIMESTAMP]` placeholders. Replace with current date/time in format: `YYYY-MM-DD HH:MM:SS`

### Step 5: Update Mode (if INITIALIZED)

If memory bank already exists and user provided arguments, update the appropriate file.

**Logic**:
- Arguments mentioning "scope", "architecture", "component" → Update `productContext.md`
- Arguments mentioning "decision", "chosen", "approach" → Update `decisionLog.md`
- Arguments mentioning "progress", "completed", "work" → Update `progress.md`
- Arguments mentioning "pattern", "standard", "convention" → Update `systemPatterns.md`
- Default → Update `activeContext.md`

**Action**:
1. Determine target file from keywords in user input
2. Append new section with timestamp
3. Format: `## [YYYY-MM-DD HH:MM:SS] - [Summary]\n\n[Full content]`

### Step 6: Recovery (if PARTIAL)

If some files are missing, recreate them from templates.

**Action**:
1. Identify missing files
2. Copy missing files from `templates/memory/`
3. Update timestamps
4. Report which files were recovered

### Step 7: Validation & Report

Verify all 6 files exist and are valid markdown.

**Report Format**:
```
✅ Memory Bank Status: [MEMORY BANK: ACTIVE]

Files:
  ✓ constitution.md (XX lines)
  ✓ productContext.md (XX lines)
  ✓ activeContext.md (XX lines)
  ✓ systemPatterns.md (XX lines)
  ✓ decisionLog.md (XX lines)
  ✓ progress.md (XX lines)

Total: 6 files, XXX lines of context

Next: Use '/rapidspec.umb' to update memory during sessions
```

---

## Detailed Workflow

### For Initialization (No Arguments)

1. ✅ Check if `.rapidspec/memory/` exists
2. If not: Create directory
3. Copy all template files from `spec-kit/templates/memory/`
4. Analyze codebase:
   - Read package.json for project info
   - Scan source files for tech stack and patterns
   - Check git log for recent decisions
   - Look for README and documentation
5. Populate each file with detected information
6. Replace [TIMESTAMP] with current time
7. Validate all 6 files exist
8. Report status as `[MEMORY BANK: ACTIVE]`

### For Update Mode (With Arguments)

1. ✅ Check if `.rapidspec/memory/` exists
2. If exists: Parse user arguments
3. Determine target file based on keywords
4. Append new timestamped section
5. Validate file is still valid markdown
6. Report which file was updated

### For Recovery Mode (Partial)

1. ✅ Check file count in `.rapidspec/memory/`
2. If < 6 files: Identify missing ones
3. Copy missing files from templates
4. Update timestamps in recovered files
5. Validate all 6 files now exist
6. Report recovery results

---

## Key Implementation Details

### Template Variables to Replace

All template files use these placeholders (auto-replaced during initialization):

- `[TIMESTAMP]` → Current date/time (YYYY-MM-DD HH:MM:SS)
- `[PROJECT_NAME]` → From package.json or directory name
- `[PROJECT_DESCRIPTION]` → From package.json or README
- `[TECH_STACK]` → Detected from dependencies and imports

### Timestamp Format

Always use: `YYYY-MM-DD HH:MM:SS`

Example: `2025-12-23 20:30:00`

### File Location

Memory bank always located at: `.rapidspec/memory/` (project root)

This is specified in `.rapidspec/` directory naming convention for RapidSpec projects.

### No Overwrites

When updating existing memory bank:
- Always append new content
- Never delete existing content
- Preserve entire revision history
- Timestamps enable session reconstruction

---

## Success Criteria

Command is successful when:

✅ All 6 files exist in `.rapidspec/memory/`
✅ All files are valid markdown
✅ All timestamps are in correct format
✅ projectContext.md has real data from project
✅ activeContext.md is ready for user input
✅ User receives `[MEMORY BANK: ACTIVE]` status message

---

## Error Handling

| Scenario | Action |
|----------|--------|
| No permission to create .rapidspec/ | Report error, suggest running in project root |
| Template files not found | Report error, check spec-kit installation |
| Invalid markdown in populated files | Fix syntax, report which file had issue |
| Missing git/package.json | Continue with defaults, report what couldn't be auto-detected |
| Memory bank already exists | Use update mode, don't overwrite |
| Partial memory bank exists | Use recovery mode, recreate missing files |

---

## Integration with Other Commands

This command creates the foundation that other commands use:

- `/rapidspec.proposal --update-memory` - Logs decisions to decisionLog.md
- `/rapidspec.apply --track-progress` - Updates progress.md checkpoints
- `/rapidspec.review --log-findings` - Records patterns in systemPatterns.md
- `/rapidspec.commit` - Auto-updates progress.md with completed work
- `/rapidspec.archive` - Auto-archives completed changes in progress.md
- `/rapidspec.umb` - Manual memory bank updates during sessions

---

## Example Output

```
RapidSpec Constitution Command
═════════════════════════════════════════════

Checking memory bank status...
Status: UNINITIALIZED

Creating .rapidspec/memory/ directory...
✓ Directory created

Analyzing project...
  ✓ Detected: Node.js / TypeScript / Express.js
  ✓ Found: 5 main source directories
  ✓ Reviewed: 15 recent commits
  ✓ Read: package.json, README.md

Populating memory bank files...
  ✓ constitution.md (52 lines)
  ✓ productContext.md (87 lines)
  ✓ activeContext.md (45 lines)
  ✓ systemPatterns.md (73 lines)
  ✓ decisionLog.md (28 lines)
  ✓ progress.md (62 lines)

Validating...
✓ All 6 files present
✓ All files are valid markdown
✓ Timestamps updated

═════════════════════════════════════════════
✅ Memory Bank Status: [MEMORY BANK: ACTIVE]

Files created: 6
Total lines: 347

Next step: Use '/rapidspec.umb' to update memory during sessions
```

---

## Notes

- Memory bank is completely optional - RapidSpec works without it
- Memory bank is per-project (one per `.rapidspec/` directory)
- Files can be manually edited between command runs
- Memory bank is independent of change tracking (changes/, specs/)
- Timestamps preserve audit trail of context updates
- Constitution can be customized per project while maintaining RapidSpec standards
