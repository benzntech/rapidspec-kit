---
name: RapidSpec Constitution
description: Initialize and update memory bank system with intelligent analysis
category: RapidSpec
tags: [rapidspec, memory, constitution, initialization]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: "[optional: initialization instructions or update directives]"
---

# RapidSpec Constitution Command

Initialize and manage the memory bank system for project governance and context tracking.

## Usage

```bash
/rapidspec.constitution
# Initialize new memory bank with intelligent population

/rapidspec.constitution Update scope to include new microservices architecture
# Update existing memory bank with directive
```

## What This Does

The constitution command manages a hybrid memory bank consisting of:
1. **constitution.md** - Project governance and principles (static reference)
2. **productContext.md** - Project scope, architecture, components
3. **activeContext.md** - Current work, objectives, blockers
4. **systemPatterns.md** - Coding and architectural patterns
5. **decisionLog.md** - Technical decisions and rationale
6. **progress.md** - Work tracking across all changes

## Command Flow

<!-- RAPIDSPEC:START -->

### 1. Status Check

First, determine the state of the memory bank:

```bash
# Check if memory bank directory exists
if [[ ! -d ".rapidspec/memory" ]]; then
  STATUS="UNINITIALIZED"
elif [[ $(ls -1 .rapidspec/memory/*.md 2>/dev/null | wc -l) -lt 6 ]]; then
  STATUS="PARTIAL"
elif [[ $(ls -1 .rapidspec/memory/*.md 2>/dev/null | wc -l) -eq 6 ]]; then
  if [[ -n "$ARGUMENTS" ]]; then
    STATUS="NEEDS_UPDATE"
  else
    STATUS="INITIALIZED"
  fi
else
  STATUS="INITIALIZED"
fi

echo "Memory Bank Status: $STATUS"
```

### 2. Initialize (if UNINITIALIZED)

If this is the first run:

```bash
# Create directory structure
mkdir -p ".rapidspec/memory"

# Copy constitution.md from templates
cp "[template-path]/constitution.md" ".rapidspec/memory/constitution.md"

# Create memory bank files from templates
for file in productContext.md activeContext.md systemPatterns.md decisionLog.md progress.md; do
  cp "[template-path]/$file" ".rapidspec/memory/$file"
done

echo "✓ Created .rapidspec/memory/ directory with 6 files"
```

### 3. Intelligent Population

Analyze the codebase and populate files with initial context:

#### 3a. productContext.md

Extract from:
- `package.json` (name, description, version, dependencies)
- `README.md` (purpose, goals, technology stack)
- Directory structure (components, organization)
- File extensions and imports (tech stack detection)

Population steps:
```bash
# Extract project info from package.json
PROJECT_NAME=$(jq -r '.name' package.json)
PROJECT_DESC=$(jq -r '.description' package.json)
PROJECT_VERSION=$(jq -r '.version' package.json)

# Detect main directories (src/, lib/, components/, etc.)
MAIN_DIRS=$(ls -d */ 2>/dev/null | head -10)

# Detect technologies from node_modules or imports
TECH_STACK=$(grep -h "^import\|^from\|require(" src/**/*.{js,ts} 2>/dev/null | grep -o "'[^']*'" | sort | uniq | head -20)
```

Update productContext.md:
- Replace `[Auto-populated from package.json description and README]` with extracted description
- Replace `[Auto-detected from directory structure]` with actual directory list
- Replace `[Auto-detected from package.json dependencies]` with tech stack

#### 3b. systemPatterns.md

Extract from:
- Codebase analysis (error handling patterns, async patterns)
- Import analysis (module organization)
- Test files (testing patterns)
- Code review standards (anti-patterns to avoid)

Population steps:
```bash
# Find error handling patterns
grep -r "try\|catch\|throw\|error\|Error" src/ --include="*.ts" --include="*.js" | head -5

# Detect async patterns
grep -r "async\|await\|Promise\|callback" src/ --include="*.ts" --include="*.js" | head -5

# Analyze module structure
find src/ -type f -name "*.ts" -o -name "*.js" | head -20
```

#### 3c. decisionLog.md

Extract from:
- Git log (commit messages, --grep architectural decisions)
- Existing proposal.md files in changes/
- README decisions or architectural notes
- Codebase comments indicating decisions

Population steps:
```bash
# Extract meaningful commits that indicate decisions
git log --oneline --grep="feat\|refactor\|arch" | head -10

# Check for existing proposal.md files
find . -path ./node_modules -prune -o -name "proposal.md" -type f -print
```

#### 3d. progress.md

Extract from:
- Git branches (active work)
- changes/ directory (completed and in-progress)
- GitHub issues (if available)
- Current tasks.md

Population steps:
```bash
# Check for changes/ directory
ls -la changes/ 2>/dev/null

# Find recently completed work
ls -la changes/archive/ 2>/dev/null

# Current branch and recent commits
git branch -v | head -5
git log --oneline -10
```

#### 3e. activeContext.md

Set initial state based on:
- Current branch
- Active proposals or open issues
- Recent changes

Population steps:
```bash
# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check for active changes
ACTIVE_CHANGES=$(ls -d changes/*/ 2>/dev/null | grep -v archive | head -3)
```

### 4. Add Timestamps

All generated files get timestamp of initialization:

```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
sed -i "s/\[TIMESTAMP\]/$TIMESTAMP/g" .rapidspec/memory/*.md
```

### 5. Update Mode (if NEEDS_UPDATE and arguments provided)

If memory bank exists and user provided update directives:

```bash
# Parse user input to target files
# Examples:
# "Update scope..." → productContext.md
# "Add decision..." → decisionLog.md
# "Update progress..." → progress.md
# "Add pattern..." → systemPatterns.md
# "Update objectives..." → activeContext.md

# Determine target file from user input
if [[ "$ARGUMENTS" =~ "scope|overview|architecture|component" ]]; then
  TARGET_FILE=".rapidspec/memory/productContext.md"
elif [[ "$ARGUMENTS" =~ "decision|decided|chosen|approach" ]]; then
  TARGET_FILE=".rapidspec/memory/decisionLog.md"
elif [[ "$ARGUMENTS" =~ "progress|completed|work|task" ]]; then
  TARGET_FILE=".rapidspec/memory/progress.md"
elif [[ "$ARGUMENTS" =~ "pattern|standard|convention|anti" ]]; then
  TARGET_FILE=".rapidspec/memory/systemPatterns.md"
else
  TARGET_FILE=".rapidspec/memory/activeContext.md"
fi

# Append to relevant section with timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "
## [$TIMESTAMP] - $(echo "$ARGUMENTS" | cut -d' ' -f1-3)

$ARGUMENTS
" >> "$TARGET_FILE"

echo "✓ Updated: $(basename $TARGET_FILE)"
```

### 6. Recovery (if PARTIAL)

If some files are missing:

```bash
# Detect missing files
MISSING=()
for file in constitution.md productContext.md activeContext.md systemPatterns.md decisionLog.md progress.md; do
  [[ ! -f ".rapidspec/memory/$file" ]] && MISSING+=("$file")
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Memory bank incomplete. Missing: ${MISSING[*]}"
  echo "Create missing files? (yes/no)"

  # If yes, create from templates
  for file in "${MISSING[@]}"; do
    cp "[template-path]/$file" ".rapidspec/memory/$file"
  done

  echo "✓ Created missing files"
fi
```

### 7. Validation

Verify the memory bank is properly initialized:

```bash
# Check all files exist
FILES_FOUND=0
for file in constitution.md productContext.md activeContext.md systemPatterns.md decisionLog.md progress.md; do
  if [[ -f ".rapidspec/memory/$file" ]]; then
    SIZE=$(wc -l < ".rapidspec/memory/$file")
    echo "✓ $file ($SIZE lines)"
    ((FILES_FOUND++))
  else
    echo "✗ $file (missing)"
  fi
done

if [[ $FILES_FOUND -eq 6 ]]; then
  echo ""
  echo "✅ Memory Bank Status: [MEMORY BANK: ACTIVE]"
  echo "   All 6 files present and ready for use"
  echo ""
  echo "Next: Use '/rapidspec.umb' to update memory during sessions"
else
  echo ""
  echo "⚠️  Memory Bank Status: [MEMORY BANK: PARTIAL]"
  echo "   $FILES_FOUND/6 files found"
fi
```

<!-- RAPIDSPEC:END -->

## Integration Points

### With Other Commands

- **After `/rapidspec.proposal`**: Consider auto-logging option analysis to decisionLog.md (optional with `--update-memory` flag)
- **During `/rapidspec.apply`**: Optional checkpoint updates to progress.md (with `--track-progress` flag)
- **After `/rapidspec.review`**: Option to log critical findings to decisionLog.md
- **After `/rapidspec.commit`**: Option to update progress.md completed items

### Manual Usage

Users can call this command directly to:
- Initialize memory bank on new projects
- Update memory bank with new project information
- Recover from partial installations
- Refresh memory bank with latest project state

## Key Features

✅ **Intelligent Population**: Auto-analyzes codebase on first run
✅ **Graceful Recovery**: Handles partial installations
✅ **Flexible Updates**: Supports incremental updates to existing memory
✅ **Timestamp Tracking**: All entries timestamped for audit trail
✅ **Status Tracking**: Clear indicators of memory bank state
✅ **Integration Ready**: Hooks compatible with existing RapidSpec workflow

## Output Example

```
Memory Bank Status: UNINITIALIZED
Creating .rapidspec/memory/...

Analyzing project structure...
✓ Detected tech stack: TypeScript, React, Node.js
✓ Found 12 core components
✓ Analyzed 45 recent commits

Populating files...
✓ productContext.md (82 lines)
✓ activeContext.md (45 lines)
✓ systemPatterns.md (78 lines)
✓ decisionLog.md (142 lines)
✓ progress.md (95 lines)
✓ constitution.md (52 lines)

✅ Memory Bank Status: [MEMORY BANK: ACTIVE]
   All 6 files present and ready for use

Next: Use '/rapidspec.umb' to update memory during sessions
```

## Notes

- Memory bank is stored in `.rapidspec/memory/` directory at project root
- Files use markdown format for easy viewing and editing
- Memory bank is independent of per-change state (changes/, specs/, tasks.md)
- Timestamps enable audit trail of when context was updated
- Updates preserve existing content - appends rather than overwrites
