# Code Verification: [Feature Name]

**Status**: Generated on [Date/Time]

---

## Verification Summary

| Metric   | Value   |
| -------- | ------- |

| **Overall Status** | ✅ All files verified / ⚠️ Some files missing / ❌ Critical files not found |

| **Files Verified** | X of Y |

| **Framework Detected** | [Framework Name and Version] |

| **Git History Analyzed** | ✅ Last X commits analyzed |

| **Breaking Changes Identified** | X critical, Y warnings |

| **Verification Confidence** | XX% |

---

## Verified File Paths

### File 1: [Path]

- **Status**: ✅ Verified

- **Type**: [JavaScript/TypeScript/Python/SQL/etc]

- **Size**: [Number] lines

- **Last Modified**: [Date] by [Author]

- **Git URL**: [Link to file in repo]

**Code Context**:

```[language]

[First 30-50 lines of file]

```text

**Purpose in Feature**: [How this file relates to the feature]

---

### File 2: [Path]

[Same structure as above]

---

## Framework Detection

### Primary Technology Stack

| Component   | Technology  | Version   | Source   |
| ----------- | ----------- | --------- | -------- |

| **Language** | JavaScript  | 5.0.0     | package.json |

| **Framework** | React | 18.2.0 | package.json |

| **Backend** | Express.js | 4.18.2 | package.json |

| **Database** | PostgreSQL | 14 | docker-compose.yml |

| **Authentication** | JWT | N/A | package.json (jsonwebtoken 9.0.0) |

| **Testing** | Jest | 29.0.0 | package.json |

| **Build Tool** | Webpack | 5.0.0 | package.json |

### Key Dependencies

```json

{
  "react": "18.2.0",
  "react-dom": "18.2.0",
  "express": "4.18.2",
  "pg": "8.10.0",
  "jsonwebtoken": "9.0.0",
  "jest": "29.0.0"
}

```text

### Framework-Specific Patterns

- **React Version**: 18.x (Supports hooks, concurrent features)

- **Express Version**: 4.x (Middleware-based, standard patterns)

- **Database**: PostgreSQL 14 (Supports JSON, window functions)

- **TypeScript**: Yes, used throughout codebase

---

## Git History Timeline

### File 1: src/server/auth.ts

**Last Modified**: 2025-12-15 14:23:00 UTC by Sarah Chen

**Recent Commits**:

```text

a3f9e2d - Fix JWT validation in login endpoint (2 days ago)

f2e1d9c - Add rate limiting to auth routes (1 week ago)

8d7c5b3 - Refactor authentication middleware (3 weeks ago)

7c6b4a2 - Add OAuth2 support for Google login (1 month ago)

6b5a3f1 - Initial auth implementation (3 months ago)

```text

**Activity Level**: ✅ Active (last change 2 days ago)

---

### File 2: src/components/LoginForm.tsx

**Last Modified**: 2025-12-10 09:15:00 UTC by Alex Rodriguez

**Recent Commits**:

```text

9e8d7c6 - Improve form validation UX (5 days ago)

8d7c5b4 - Add password strength indicator (2 weeks ago)

7c6b4a3 - Refactor form state management (1 month ago)

6b5a3f2 - Add dark mode support (2 months ago)

5a4932e1 - Initial form implementation (3 months ago)

```text

**Activity Level**: ✅ Active (last change 5 days ago)

---

## Component Dependencies Map

### src/components/LoginForm.tsx

**Internal Dependencies** (files this component imports):

```text

├── src/services/auth.ts (authenticate users)
├── src/hooks/useForm.ts (manage form state)
├── src/types/User.ts (type definitions)
├── src/utils/validation.ts (field validation)
└── src/styles/LoginForm.css (styling)

```text

**External Dependencies** (libraries this component uses):

```text

├── react (JSX, hooks)
├── react-hook-form (form state management)
├── axios (HTTP requests)
└── classnames (CSS class management)

```text

**Dependency Depth**: 3 levels

**Circular Dependencies**: None detected ✅

---

### src/services/auth.ts

**Internal Dependencies**:

```text

├── src/api/client.ts (HTTP client)
├── src/types/User.ts (type definitions)
├── src/utils/storage.ts (localStorage management)
└── src/config/constants.ts (API constants)

```text

**External Dependencies**:

```text

├── axios (HTTP client)
├── jsonwebtoken (JWT handling)
└── lodash (utility functions)

```text

**Dependency Depth**: 2 levels

**Circular Dependencies**: None detected ✅

---

## Breaking Changes Assessment

### Version Upgrade Impacts

#### React 18.x → 19.x (if planned)

- ⚠️ Concurrent features may change behavior

- ⚠️ StrictMode behavior changes

- ⚠️ Some hooks signature changes

- Risk Level: **Medium**

#### Express 4.x → 5.x (if planned)

- ⚠️ Middleware signature changes

- ⚠️ Response method changes

- ⚠️ Error handling changes

- Risk Level: **High**

#### PostgreSQL 14 → 15 (if planned)

- ✅ Mostly backward compatible

- ⚠️ Some function deprecations

- Risk Level: **Low**

### Database Schema Changes

- ❌ Would require: new columns for [feature]

- ⚠️ Impact: existing queries must be updated

- Time: [X hours] for migration

### API Endpoint Changes

- Current: `POST /api/auth/login`

- Proposed: `POST /api/v2/auth/login` (breaking!)

- Impact: All clients must update

### Environment Variables

**New Variables Needed**:

```bash

JWT_EXPIRATION=3600          # Token expiration in seconds

JWT_REFRESH_TOKEN_SECRET=... # Separate secret for refresh tokens

AUTH_RATE_LIMIT=5            # Max login attempts per minute

```text

**Changed Variables**:

- `DATABASE_URL` format changed (old → new format)

- `API_TIMEOUT` now in milliseconds (was seconds)

### Authentication/Authorization Changes

- ⚠️ Switching from session-based to JWT

- ❌ Breaking change: All existing sessions invalidated

- Impact: Users must re-login after deployment

---

## Impact Analysis

### Files That Will Be Modified

| File   | Type   | Lines Changed   | Reason   |
| ------ | ------ | --------------- | -------- |

| src/server/auth.ts           | TypeScript | ~50             | Update auth logic      |
| src/services/auth.ts         | TypeScript | ~30             | Add JWT handling       |
| src/components/LoginForm.tsx | TypeScript | ~20             | Update form submission |
| package.json                 | JSON       | ~5              | Add JWT library        |

**Total Lines**: ~105

### Files That May Be Affected

| File   | Type   | Reason   | Risk   |
| ------ | ------ | -------- | ------ |

| src/api/routes.ts      | TypeScript | Uses auth middleware  | Medium |
| src/middleware/auth.ts | TypeScript | Authentication logic  | High   |
| src/types/User.ts      | TypeScript | User type definitions | Low    |
| tests/auth.test.ts     | TypeScript | Auth tests            | Medium |

### Files Unlikely to Change

- src/components/LoginForm.css (styling only)

- src/utils/validation.ts (validation logic)

- src/config/constants.ts (constants)

---

## Risk Assessment

### Overall Risk: **Medium** 🟡

#### Critical Risks ❌

- [ ] Database schema migration required

- [ ] API endpoint breaking change

- [ ] Session invalidation (users must re-login)

#### Medium Risks 🟡

- [ ] Framework version upgrade conflicts

- [ ] Dependency version incompatibilities

- [ ] Performance impact from new auth method

- [ ] Testing coverage gaps

#### Low Risks 🟢

- [ ] Code styling inconsistencies

- [ ] Documentation updates

- [ ] Configuration adjustments

### Mitigation Strategies

| Risk   | Mitigation  |
| ------ | ----------- |

| Session invalidation | Provide migration guide, staggered rollout                |
| Database migration   | Use zero-downtime migration approach                      |
| API breaking change  | Maintain backward compatibility with deprecated endpoints |
| Testing gaps         | Add tests for new auth flow before deployment             |

---

## Dependency Tree

```text

LoginForm.tsx
├── auth.service.ts
│   ├── api.client.ts
│   │   └── axios
│   ├── storage.util.ts
│   └── User.types.ts
├── useForm.hook.ts
│   └── react
├── validation.util.ts
├── react-hook-form
└── classnames

auth.ts (server)
├── express
├── jsonwebtoken
└── User.types.ts

```text

---

## Verification Confidence

| Area   | Confidence  | Reasoning   |
| ------ | ----------- | ----------- |

| **File Path Verification** | ✅ 95%       | All referenced files found and verified |

| **Framework Detection** | ✅ 98% | Versions extracted from actual config files |

| **Git History** | ✅ 100% | From actual git log commands |

| **Breaking Changes** | ⚠️ 85% | Identified known breaking changes, may have missed some |

| **Dependency Analysis** | ✅ 90% | Analyzed import statements and package.json |

| **Overall Confidence** | ✅ 91% | Ready to proceed with option generation |

---

## Ready for Implementation

✅ **All critical files verified**
✅ **Framework versions detected**

✅ **Git history analyzed**

✅ **Breaking changes identified**


⚠️ **Some risks noted - review before proceeding**

**Next Step**: Proceed to `/rapidspec.options` to generate implementation approaches based on this verified code context.

**Files Safe to Modify**:

- src/server/auth.ts

- src/services/auth.ts

- src/components/LoginForm.tsx

**Critical Warnings**:

- [ ] Users will need to re-login after deployment

- [ ] Database migration required

- [ ] API endpoint changes are breaking

