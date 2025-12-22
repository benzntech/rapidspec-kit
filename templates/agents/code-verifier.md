# Agent: Code Verifier

**Role**: Verify actual code files exist, detect frameworks, analyze git history, and identify breaking changes

**Trigger**: Called by `/rapidspec.verify` command to perform code verification before planning

**Available Tools**: Read, Bash, Grep, Glob, WebSearch

---

## Responsibility

Verify that the code referenced in spec.md actually exists in the codebase. Perform impact analysis by detecting frameworks, analyzing git history, and identifying potential breaking changes. This prevents "imaginary code" hallucinations before implementation.

---

## Workflow

### 1. Read Feature Specification Context

```text

Read: $FEATURE_DIR/spec.md
Extract:

- Feature name and description

- Components or files mentioned

- Technology stack suggested

- Architecture described

- Dependencies noted

```text

### 2. Verify Actual Code Files Exist

For each file/component mentioned:

```bash

# Verify file path exists

if [ -f "$FILE_PATH" ]; then
  ✓ File verified
else
  ✗ File not found
  → Check for renamed/moved files with git log
fi

# Extract file metadata

- Full path from repo root

- File size (lines of code)

- Type (JavaScript/Python/SQL/etc)

- Last modified date (from git)

```text

**Key Steps**:

1. For each component mentioned in spec.md, find actual file

2. Use Glob and Read to verify paths exist

3. Extract code snippets (first 50 lines or relevant section)

4. Document exact file paths

5. Note if files are missing, renamed, or moved

### 3. Detect Framework & Tech Stack

```bash

# Detect by reading package.json/requirements.txt/go.mod/etc

detect_framework() {
  if [ -f "package.json" ]; then
    FRAMEWORK=$(grep -o '"name":\s*"[^"]*"' package.json | head -1)
    DEPENDENCIES=$(grep -o '"dependencies":\s*{[^}]*}' package.json)
    VERSION=$(grep -o '"version":\s*"[^"]*"' package.json | head -1)
  fi

  if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
    FRAMEWORK="Python"
    # Extract framework from imports

  fi

  if [ -f "go.mod" ]; then
    FRAMEWORK="Go"
  fi
}

```text

**What to Extract**:

- Primary framework (React, Vue, Next.js, Django, Flask, Express, etc)

- Framework version constraints

- Key dependencies and versions

- Database type (PostgreSQL, MongoDB, MySQL, etc)

- API framework (REST, GraphQL, gRPC)

- Authentication strategy (session, JWT, OAuth)

- Testing framework

- Build tool

**Output Example**:

```markdown

## Framework Detection

### Primary Technology Stack

- **Language**: JavaScript/TypeScript

- **Framework**: React 18.2.0

- **Backend**: Express 4.18.2

- **Database**: PostgreSQL 14

- **Authentication**: JWT with express-jwt

- **Testing**: Jest 29.0.0

- **Build**: Webpack 5.0.0

- **Package Manager**: npm 9.0.0

### Key Dependencies

- react: 18.2.0

- react-dom: 18.2.0

- express: 4.18.2

- pg: 8.10.0

- jsonwebtoken: 9.0.0

- jest: 29.0.0

```text

### 4. Analyze Git History

```bash

# Get commit history for affected files

git log --oneline -20 -- <file_path>

# Get detailed commit info

git log --format="%h - %an, %ar : %s" -10 -- <file_path>

# Get last modification date

git log -1 --format="%aI" -- <file_path>

# Get blame for recent changes

git blame <file_path> | head -20

```text

**What to Extract**:

- Last 5-10 commits for each file

- Last modification date and author

- Commit messages (to understand recent changes)

- Frequency of changes (active vs abandoned code)

- Any recent refactoring or major changes

**Output Example**:

```markdown

## Git History: src/server/auth.ts

**Last Modified**: 2025-12-15 14:23:00 UTC

**Recent Commits**:

- `a3f9e2d` - Fix JWT validation in login endpoint (2 days ago)

- `f2e1d9c` - Add rate limiting to auth routes (1 week ago)

- `8d7c5b3` - Refactor authentication middleware (3 weeks ago)

- `7c6b4a2` - Add OAuth2 support for Google login (1 month ago)

- `6b5a3f1` - Initial auth implementation (3 months ago)

**Activity Level**: Active (last change 2 days ago)

```text

### 5. Map Component Dependencies

```bash

# For each code file, extract imports

grep -E "^import|^from|^require" <file> | grep -v node_modules

# Build dependency graph

```text

**What to Extract**:

- Internal imports (components depending on other components)

- External imports (framework/library dependencies)

- Circular dependency warnings

- Deep nesting indicators

- Abstraction layer structure

**Output Example**:

```markdown

## Component Dependencies: src/components/LoginForm.tsx

**Internal Dependencies**:

- src/services/auth.ts (authenticate user)

- src/hooks/useForm.ts (form state management)

- src/types/User.ts (type definitions)

- src/utils/validation.ts (field validation)

**External Dependencies**:

- react

- react-hook-form

- axios

**Dependency Depth**: 3 levels

**Circular Dependencies**: None detected

```text

### 6. Identify Breaking Changes

Analyze for potential breaking changes:

```markdown

## Potential Breaking Changes

### Version Constraints

- If upgrading Framework from X to Y

- Check if API changed

- Check if dependencies need updates

- Note deprecations

### Database Changes

- Schema changes breaking queries

- New required columns

- Removed columns affecting code

### API Changes

- Changed route paths

- Modified response formats

- Changed authentication methods

- Removed endpoints

### Environment Variables

- New required vars

- Changed var names

- Changed formats

### Configuration

- Config file structure changes

- Feature flag changes

- Permission changes

```text

**Detection Steps**:

1. For each file, note current versions

2. Check if spec.md suggests version upgrades

3. Identify breaking API changes

4. Note database migration requirements

5. Check authentication/authorization impacts

6. Identify compatibility issues

**Output Example**:

```markdown

## Breaking Changes Analysis

### High Risk 🔴

- [ ] Database schema changes required

- [ ] API endpoint path changes

- [ ] Authentication method changes

- [ ] Required environment variables changed

### Medium Risk 🟡

- [ ] Dependency version upgrades

- [ ] Config file structure changes

- [ ] Deprecation warnings in dependencies

### Low Risk 🟢

- [ ] Styling updates

- [ ] UI component refactoring

- [ ] Non-critical dependency updates

```text

### 7. Generate Verification Report

Create comprehensive verification.md artifact:

```markdown

# Code Verification: [Feature Name]

## Verification Summary

**Status**: ✅ All files verified / ⚠️ Some files missing / ❌ Critical files not found

**Timestamp**: [Current date/time]

**Verified Files**: [Count]

---

## Verified File Paths

### src/server/auth.ts

- **Status**: ✅ Verified

- **Type**: TypeScript

- **Size**: 245 lines

- **Last Modified**: 2025-12-15 14:23:00 UTC

- **Code Context**:
  ```typescript

  import express from 'express';
  import jwt from 'jsonwebtoken';

  export async function authenticate(username: string, password: string) {
    // Verify credentials against database
    const user = await verifyCredentials(username, password);

    if (!user) {
      throw new Error('Invalid credentials');
    }

    // Generate JWT token
    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET);
    return { token, user };
  }
  ```text

[Continue for each verified file...]

---

## Framework Detection

### Technology Stack

- Language: TypeScript 5.0.0

- Framework: Express.js 4.18.2

- Database: PostgreSQL 14

- Authentication: JWT with express-jwt 6.0.0

- Testing: Jest 29.0.0

[Continue for each framework/version...]

---

## Git History Timeline

### src/server/auth.ts

**Last Modified**: 2025-12-15 14:23:00 UTC by Sarah Chen

Recent Commits:

- `a3f9e2d` - Fix JWT validation in login endpoint (2 days ago)

- `f2e1d9c` - Add rate limiting to auth routes (1 week ago)

- `8d7c5b3` - Refactor authentication middleware (3 weeks ago)

[Continue for each file...]

---

## Component Dependencies Map

### src/components/LoginForm.tsx

**Internal Dependencies**:

- src/services/auth.ts

- src/hooks/useForm.ts

- src/types/User.ts

**External Dependencies**:

- react 18.2.0

- react-hook-form 7.45.0

- axios 1.5.0

**Depth**: 3 levels

**Circular Dependencies**: None

[Continue for each component...]

---

## Breaking Changes Assessment

### Version Upgrade Impacts

- Upgrading Express 4.x to 5.x: Check middleware compatibility

- Upgrading React 18 to 19: Check API changes

- PostgreSQL 14 to 15: Check deprecations

### Database Schema Changes

- New columns required: nullable until migration

- Removed columns: must update queries

- Data type changes: migration required

### API Changes

- Route paths: /api/auth → /api/v2/auth

- Response format: Check all clients

- Status codes: Verify error handling

### Environment Variables

- JWT_SECRET: Required (critical)

- DATABASE_URL: Format changed

- API_TIMEOUT: New variable

---

## Impact Analysis

### Files That Will Be Modified

- src/server/auth.ts (50 lines)

- src/services/auth.ts (80 lines)

- src/components/LoginForm.tsx (120 lines)

### Files That May Be Affected

- src/api/routes.ts (uses auth)

- src/middleware/auth.ts (middleware)

- src/types/User.ts (type definitions)

### Risk Assessment

**Overall Risk**: Medium 🟡

- No critical breaking changes

- 2 database migrations required

- 3 environment variables need updates

---

## Verification Confidence

**File Path Verification**: ✅ 95% (all referenced files found)

**Framework Detection**: ✅ 95% (versions extracted from package.json)

**Git History**: ✅ 100% (from git log)

**Breaking Changes**: ⚠️ 85% (identified known breaking changes)

---

## Ready for Options Generation

All code has been verified. The following files are safe to modify:

- src/server/auth.ts

- src/services/auth.ts

- src/components/LoginForm.tsx

Next step: Generate implementation options based on verified code context.

```text

---

## Critical Rules

### ✅ Verify, Don't Assume

```text

WRONG: Assume code follows common patterns
✓ CORRECT: Read actual code to verify

WRONG: Trust memory of code structure
✓ CORRECT: Use Read tool for actual files

WRONG: Invent file paths
✓ CORRECT: Use Glob/Bash to find real paths

```text

### ✅ Document Everything

- Every verified file path documented

- Every code snippet from actual source

- Every version extracted from actual config

- Every commit from actual git log

### ✅ Detect Breaking Changes

- Identify version constraints

- Check API changes

- Note database impacts

- Verify environment variables

- Check authentication impacts

---

## Output Format

Always create verification.md with these sections:

1. **Verification Summary** - Quick status overview

2. **Verified File Paths** - Every file with status and context

3. **Framework Detection** - Tech stack and versions

4. **Git History Timeline** - Recent commits for context

5. **Component Dependencies** - How components relate

6. **Breaking Changes Assessment** - Risks identified

7. **Impact Analysis** - What will change

8. **Verification Confidence** - How confident in analysis

---

## Examples of Good Verification

### ✅ Good: Evidence-Based

```text

## Verified File Paths

### src/auth/login.ts

- **Status**: ✅ Verified

- **Type**: TypeScript

- **Size**: 145 lines

- **Last Modified**: 2025-12-15 14:23:00 UTC

- **Code Snippet**:
  [First 30 lines of actual code]

```text

### ❌ Bad: Assumptions

```text

## Verified Files

### Probably auth.ts

- **Status**: Assumed to exist

- **Type**: Probably JavaScript

- **Size**: Maybe 200 lines

- **Code**: Probably something like this...

```text

---

## When to Stop

Stop verifying when you have:

- Verified all files referenced in spec.md

- Extracted framework versions

- Analyzed git history for context

- Identified breaking changes

- Created dependency map

- Generated comprehensive verification.md

Hand off to option-generator with confidence that code verification is complete and accurate.
