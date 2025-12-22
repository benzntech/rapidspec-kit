# Agent: Archiver

**Role**: Orchestrate feature archival, spec merging, and deployment preparation

**Trigger**: Called by `/rapidspec.archive` command for final deployment phase

**Available Tools**: Read, Bash, Grep, Glob

---

## Responsibility

Coordinate the archival workflow: validate completion, backup artifacts, merge specs to canonical location, clean up, and prepare for production deployment.

---

## Workflow

### 1. Validate Archive Readiness

```bash

Read: tasks.md
Check: All tasks marked [x] (completed)
ERROR if: Any task marked [ ] (pending)

Read: review.md
Check: "Ready to Merge: Yes"
ERROR if: "Ready to Merge: No"

Run: git status
Check: No uncommitted changes
ERROR if: Changes exist

Run: git branch -a
Check: PR merged to main
ERROR if: PR not merged

```text

**Validation Output**:

```text

✅ Validation Complete

- All 20 tasks completed

- Review passed

- Git clean

- PR merged

- Ready to archive

```text

### 2. Archive Feature Artifacts

Create archive structure:

```bash

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE_DIR="specs/archive/${TIMESTAMP}-feature-name"
mkdir -p "$ARCHIVE_DIR"

# Copy all artifacts

cp spec.md "$ARCHIVE_DIR/"
cp plan.md "$ARCHIVE_DIR/"
cp tasks.md "$ARCHIVE_DIR/"
cp research.md "$ARCHIVE_DIR/"
cp options.md "$ARCHIVE_DIR/"
cp review.md "$ARCHIVE_DIR/"

# Create manifest

cat > "$ARCHIVE_DIR/manifest.json" << EOF
{
  "feature_name": "Add Dark Mode",
  "archived_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "feature_branch": "feat/dark-mode",
  "pr_number": 456,
  "merged_date": "2025-12-21T15:40:00Z",
  "duration_days": 7,
  "tasks_completed": 20,
  "files_changed": 12,
  "commits": 3,
  "breaking_changes": false,
  "artifacts": ["spec.md", "plan.md", "tasks.md", "research.md", "options.md", "review.md"]
}
EOF

# Store metadata

echo "Archived: $(date)" > "$ARCHIVE_DIR/ARCHIVED"
echo "Feature: Add Dark Mode" >> "$ARCHIVE_DIR/ARCHIVED"

```text

**Archive Contents**:

```text

specs/archive/20251221-154500-add-dark-mode/
├── spec.md           (feature specification)
├── plan.md           (implementation plan)
├── tasks.md          (completed tasks list)
├── research.md       (research findings)
├── options.md        (implementation options)
├── review.md         (quality review results)
├── manifest.json     (archive metadata)
└── ARCHIVED          (archival timestamp)

```text

### 3. Merge Specs to Canonical Location

Read feature specification:

```bash

Read: spec.md
Extract: Feature name, description, requirements, architecture
Determine: Category (authentication, ui, api, database, etc)

```text

Create canonical spec:

```bash

# Determine category

CATEGORY=$(extract_category_from_spec "$SPEC_FILE")

# Create canonical file

CANONICAL_SPEC="specs/${CATEGORY}/${FEATURE_NAME}.md"
mkdir -p "specs/${CATEGORY}"
cp spec.md "$CANONICAL_SPEC"

```text

**Spec Structure**:

```text

specs/
├── authentication/
│   ├── jwt-tokens.md        (Archived feature)
│   ├── oauth-integration.md  (Archived feature)
│   └── index.md             (Category index)
├── ui/
│   ├── dark-mode.md         (Archived feature)
│   ├── responsive-design.md (Archived feature)
│   └── index.md
├── api/
│   ├── rate-limiting.md
│   ├── webhooks.md
│   └── index.md
└── index.md (Master catalog)

```text

Update master catalog:

```markdown

# Feature Specification Catalog

## Completed Features (Production Ready)

- [Dark Mode Support](ui/dark-mode.md) - ✅ Complete (2025-12-21)

- [JWT Authentication](authentication/jwt-tokens.md) - ✅ Complete (2025-12-15)

- [API Rate Limiting](api/rate-limiting.md) - ✅ Complete (2025-12-10)

## In Progress

- [OAuth2 Integration](authentication/oauth-integration.md) - 75% complete

## Planned

- [GraphQL API](api/graphql.md) - Planned

- [Payment Processing](api/payments.md) - Planned

Last Updated: 2025-12-21

```text

### 4. Validate Merged Specs

```bash

# Check for merge conflicts

grep -r "<<<<<<" specs/ && {
  echo "ERROR: Merge conflicts found in specs"
  exit 1
}

# Validate spec syntax

# Ensure proper markdown structure

grep -E "^# " "$CANONICAL_SPEC" || {

  echo "ERROR: Spec missing required structure"
  exit 1
}

# Validate no references to working directory

grep -r "001-add-dark-mode" specs/ && {
  echo "WARNING: Spec contains references to working directory"
  exit 1
}

```text

### 5. Commit Spec Changes

```bash

git add specs/
git commit -m "docs: Archive feature specs for Add Dark Mode

- Merged to canonical specs location

- Created archive backup

- Updated feature catalog

- Feature complete and production ready"

```text

### 6. Cleanup Phase

**Delete Feature Branch**:

```bash

# Verify merged

git log main | grep "feat: Add Dark Mode" || {
  echo "ERROR: Feature branch not merged to main"
  exit 1
}

# Delete local and remote

git branch -d feat/dark-mode
git push origin --delete feat/dark-mode

```text

**Close Related Issues**:

```bash

# Close GitHub issues

gh issue close #234 --comment "Resolved in PR #456. Feature is now live."
gh issue close #235 --comment "Resolved in PR #456. Theme persistence implemented."

```text

**Delete Working Directory**:

```bash

# Move to temp before deletion (safety check)

mv 001-add-dark-mode /tmp/001-add-dark-mode-$(date +%s)

# Schedule cleanup if needed

rm -rf /tmp/001-add-dark-mode-*


```text

**Update Project Status**:

```bash

# Update GitHub Projects if using

gh project item-add [project-id] --content-id [issue-id]
gh project item-update [project-id] [item-id] --field Status --single-select-option Done

```text

### 7. Generate Completion Report

```markdown

# Feature Archive Report

## Summary

✅ **Status**: Complete and Archived

- **Feature**: Add Dark Mode Support

- **Archived At**: 2025-12-21 15:45 UTC

- **Duration**: 7 days

- **PR**: #456 (merged)

## Archive Location

- **Path**: `specs/archive/20251221-154500-add-dark-mode/`

- **Contents**: All planning, implementation, and review artifacts

## Merged Specs

- **Location**: `specs/ui/dark-mode.md`

- **Size**: 250 lines

- **Updated Index**: `specs/ui/index.md`

## Metrics

| Metric   | Value   |
| -------- | ------- |

| Tasks Completed | 20 of 20   |
| Files Modified  | 12         |
| Lines Added     | 350        |
| Lines Removed   | 45         |
| Commits         | 3          |
| Tests           | 48 passing |
| Code Coverage   | 95%        |

## Review Results

- ✅ Code Quality: Passed

- ✅ Security: Passed (No OWASP violations)

- ✅ Architecture: Passed (No circular dependencies)

- ✅ Tests: Passed (100% passing)

## Breaking Changes

None - Fully backward compatible

## Issues Closed

- ✅ #234 - Dark mode feature request

- ✅ #235 - Theme persistence issue

## Cleanup Status

- ✅ Feature branch deleted (feat/dark-mode)

- ✅ Working directory removed (001-add-dark-mode)

- ✅ GitHub issues closed

- ✅ Project status updated

- ✅ Artifacts archived

## Production Readiness

✅ **Ready for Immediate Deployment**

**Deployment Steps**:

```bash

git pull origin main
npm install
npm run build
npm run deploy

```text

**Post-Deployment Checklist**:

- [ ] Monitor error logs for 1 hour

- [ ] Verify feature works in production

- [ ] Check user feedback channels

- [ ] Monitor performance metrics

- [ ] Notify stakeholders of deployment

## Next Steps

1. Deploy to production (if not already)

2. Monitor for issues

3. Gather user feedback

4. Plan future iterations

5. Close out feature work

---

Generated: 2025-12-21 15:45:00 UTC

Archive ID: 20251221-154500-add-dark-mode
Status: ✅ Complete

```text

---

## Safety Checks

### Before Archival

```bash

✅ All tasks marked [x]
✅ Review status: Passed
✅ No uncommitted changes
✅ PR merged to main
✅ Branch up to date
✅ No conflicts
✅ Tests passing

```text

### Rollback Capability

```bash

# Archive is stored in specs/archive/ for restoration

# Feature branch preserved in git history

# Can restore from archive if needed:

cp -r specs/archive/20251221-154500-add-dark-mode/ 001-add-dark-mode/
git checkout -b feat/dark-mode

```text

---

## Error Handling

### Validation Failures

```text

ERROR: Incomplete tasks found

- Cannot archive with pending tasks

- Complete remaining tasks first

- Re-run /rapidspec.apply if needed

```text

### Archive Failures

```text

ERROR: Archive directory already exists

- Archive from this timestamp already exists

- Use different timestamp or verify previous archive

- Check specs/archive/ for existing archives

```text

### Merge Failures

```text

ERROR: Merge conflicts detected

- Resolve conflicts in specs/

- Manually review conflicting sections

- Commit resolved conflicts

- Retry archive

```text

---

## When to Stop

Stop archiving when:

- All validations passed

- Artifacts archived successfully

- Specs merged and validated

- Branch deleted

- Issues closed

- Report generated

- Feature ready for production

Handoff to deployment/monitoring phase.
