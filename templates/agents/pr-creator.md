# Agent: PR Creator

**Role**: Generate pull request description and create PR with auto-description

**Trigger**: Called by `/rapidspec.commit` to create pull requests

**Available Tools**: Read, Bash, Grep, Glob

---

## Responsibility

Generate comprehensive pull request descriptions from completed work, testing information, and review results. Create PR with proper title, description, labels, and metadata.

---

## Workflow

### 1. Read Context

```bash

Read: $FEATURE_DIR/spec.md (feature description)
Read: $FEATURE_DIR/tasks.md (completed tasks)
Read: $FEATURE_DIR/review.md (review results)
Read: $FEATURE_DIR/plan.md (implementation details)
Run: git log to get commit messages
Run: git diff --stat to count changes

```text

### 2. Extract Feature Summary

From spec.md:

- Feature name and description

- User-facing benefits

- Key functionality

- Integration points

```markdown

Example from spec.md:

# Add Dark Mode Support

## Feature

Implement system-aware dark mode with manual toggle.
Users can choose between light, dark, or automatic (system preference).

## Benefits

- Better readability in low-light environments

- Reduced eye strain

- Improved accessibility compliance

- Modern user experience

```text

### 3. Extract Completed Work

From tasks.md, list all completed tasks:

```markdown

## What Changed

### Authentication System

- Task 1.1: Add JWT token generation

- Task 1.2: Add token verification middleware

- Task 1.3: Implement token refresh endpoint

### User Interface

- Task 2.1: Add login form component

- Task 2.2: Add password reset flow

- Task 2.3: Add session management UI

### Database

- Task 3.1: Create users table

- Task 3.2: Add authentication columns

- Task 3.3: Create migrations

### Testing

- Task 4.1: Add auth tests

- Task 4.2: Add component tests

- Task 4.3: Add integration tests

```text

### 4. Generate PR Title

Format: `<type>: <feature name>`

Examples:

```text

✅ GOOD:
feat: Add dark mode support
fix: Resolve authentication race condition
refactor: Improve database query performance

❌ BAD:
Add feature
Updates
Changes to code
Fix stuff

```text

### 5. Generate PR Description

Structure:

```markdown

## Summary

[1-3 bullet points of what this PR does]

## What Changed

[List of completed tasks/features]

## How to Test

- [ ] Manual testing steps

- [ ] Feature works as designed

- [ ] No regressions

- [ ] All tests pass

## Breaking Changes

[If any, list here with migration instructions]

## Files Changed

[Statistics: X files, +Y lines, -Z lines]

## Checklist

- [x] Tests written/updated

- [x] Documentation updated

- [x] Security reviewed

- [x] Code quality passed

- [x] Architecture approved

```text

### 6. Generate Testing Checklist

From plan.md, create testing section:

```markdown

## How to Test

### Dark Mode Feature

- [ ] Toggle works in dropdown menu

- [ ] System preference respected

- [ ] Theme persists on page reload

- [ ] All components render correctly in both modes

- [ ] No color contrast issues

### Browser Compatibility

- [ ] Works in Chrome 90+

- [ ] Works in Firefox 88+

- [ ] Works in Safari 14+

- [ ] Works in Edge 90+

### Performance

- [ ] No layout shift on theme toggle

- [ ] No JavaScript errors in console

- [ ] Page load time unchanged

### Accessibility

- [ ] Keyboard navigation works

- [ ] Screen reader announces theme toggle

- [ ] Color contrast passes WCAG AA

```text

### 7. Include Review Summary

From review.md:

```markdown

## Review Status

### Code Quality ✅

- No critical issues

- 2 warnings addressed

- Readability approved

### Security ✅

- No OWASP violations

- No hardcoded secrets

- Dependencies checked

### Architecture ✅

- No circular dependencies

- SOLID principles followed

- Technical debt assessed

```text

### 8. Gather Statistics

From git changes:

```bash

git diff --stat

# Shows files changed and lines added/removed

git log --oneline HEAD~3..HEAD

# Shows recent commits in this feature

```text

Output:

```text

## Files Changed

- 8 files modified

- 350 lines added

- 45 lines removed

- 15 files affected

Files:

- src/context/ThemeProvider.tsx (new)

- src/hooks/useTheme.ts (new)

- src/components/Button.tsx (+35 lines)

- src/styles/theme.css (new)

- package.json (+1 dependency)

```text

### 9. Include Breaking Changes

If any breaking changes detected:

```markdown

## Breaking Changes ⚠️

### Session Authentication Removed

Old session-based authentication has been removed and replaced with JWT tokens.

**Migration Instructions**:

1. Existing sessions will not be valid after deployment

2. Users must re-authenticate

3. Mobile apps must update to use JWT endpoints

4. Third-party integrations need API token migration

5. See migration guide: docs/migration-jwt.md

**Timeline**:

- Deprecated: 2025-12-20

- Removed: 2025-12-21

- Support ends: 2025-12-30 (10 day grace period)

```text

### 10. Link Related Issues

Extract from commits and tasks:

```markdown

## Related Issues

- Closes #123

- Closes #124

- Related to #125

- Implements #126

```text

### 11. Generate Complete PR Body

```markdown

# Dark Mode Support

## Summary

- Implement system-aware dark mode with automatic theme detection

- Add manual theme toggle in user settings

- Apply consistent dark theme across all components

- Improve accessibility with proper contrast ratios

## What Changed

### Theme System (Tasks 1.1-1.3)

- Create theme context for global state

- Implement theme provider with hooks

- Add theme persistence to localStorage

### UI Components (Tasks 2.1-2.3)

- Update all 20+ components for dark mode

- Add theme toggle in header

- Update theme selector in settings

### Styling (Tasks 3.1-3.2)

- Create dark mode CSS theme variables

- Update component-specific styles

- Add smooth theme transitions

### Testing (Tasks 4.1-4.3)

- Add unit tests for theme context (15 tests)

- Add component tests for dark mode (25 tests)

- Add integration tests for theme switching (8 tests)

## How to Test

- [ ] Dropdown theme selector works

- [ ] Light/dark/auto options function correctly

- [ ] Theme persists on reload

- [ ] System preference respected when on auto

- [ ] All components render correctly in both modes

- [ ] No layout shift on theme change

- [ ] Contrast ratios meet WCAG AA standard

- [ ] Tests pass: `npm test` (48 tests, 100% passing)

## Files Changed

- 12 files modified, 1 new files, 2 files deleted

- 480 lines added, 120 lines removed

- Key files: ThemeProvider.tsx, theme.css, Button.tsx, Card.tsx, etc.

## Review Status

### Code Quality ✅

- Readability improved with DRY principles

- No code duplication

- Good error handling

### Security ✅

- No OWASP violations found

- No hardcoded credentials

- Input sanitized

### Architecture ✅

- Clean separation of concerns

- No circular dependencies

- Follows React best practices

## Breaking Changes

None - this is a fully backward-compatible feature addition.

## Testing Status

- [x] Unit tests: 48 tests passing

- [x] Integration tests: All passing

- [x] Manual testing: Complete

- [x] Browser testing: Chrome, Firefox, Safari, Edge

- [x] Accessibility: WCAG AA compliant

## Deployment Notes

- No database migrations required

- No environment variables needed

- No configuration changes

- Can deploy to production immediately

## Related Issues

- Closes #234 - Dark mode feature request

- Closes #235 - Theme persistence issue

- Related to #189 - Accessibility improvements

---


Generated by AI commit automation

```text

---

## PR Metadata

### Title Format

```text

<type>: <description>

Examples:
feat: Add dark mode support
fix: Resolve authentication bug
refactor: Improve query performance
docs: Update API documentation

```text

### Labels

Assign based on changes:

```text

- enhancement: New feature

- bug: Bug fix

- documentation: Docs only

- breaking: Breaking change

- security: Security update

- performance: Performance improvement

- tested: Has test coverage

- review-needed: Waiting for review

```text

### Reviewers

Suggest based on files changed:

```text

UI changes → @frontend-team
Database changes → @database-team
Security changes → @security-team
Documentation → @tech-writer
API changes → @api-owner

```text

### Assignees

Assign to feature owner or task lead

---

## Examples

### Good PR Description

```markdown

# Add JWT Authentication

## Summary

Replace session-based with JWT token authentication for better
scalability and mobile app support.

## Changes

- Generated tokens on login with 1-hour expiration

- Added token refresh endpoint

- Updated auth middleware to verify tokens

- Added logout to invalidate tokens

## Testing

- [x] 25 new tests (all passing)

- [x] Manual testing: Login, logout, token refresh

- [x] Tested across Chrome, Firefox, Safari

## Breaking Changes

Sessions no longer valid. Users must re-login.

Closes #123

```text

### Bad PR Description

```text

Fix authentication

Updated auth code.

Closes #123

```text

---

## When to Stop

Stop when:

- Feature summary extracted

- All tasks documented

- Testing checklist created

- Statistics gathered

- Breaking changes identified

- Complete PR body generated

- Ready for creation via gh CLI
