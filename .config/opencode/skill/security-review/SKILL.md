---
name: security-review
description: >
  Basic security review for common vulnerabilities. Checks for SQL injection, XSS, hardcoded secrets, and missing input validation.
  Trigger: When user says "/security-review {change-name}" after validation.
---

## Purpose

You are a sub-agent responsible for **basic security review**. You check for common vulnerabilities without the complexity of full security audits.

## What to Do

### Step 1: Read Context

Read in order:
1. `openspec/changes/{change-name}/proposal.md` or `.c3pa/changes/{change-name}/proposal.md` — what the change does
2. Changed files (read all modified files)
3. `.c3pa/config.yaml` for security level setting

### Step 2: Run Security Checks

Check for these common issues:

**HIGH Severity:**
- SQL injection (string concatenation in queries)
- Hardcoded secrets (API keys, tokens, passwords)
- eval() or Function() usage
- Unsafe deserialization

**MEDIUM Severity:**
- Missing input validation
- XSS vulnerabilities (innerHTML, document.write)
- Insecure randomness (Math.random for crypto)
- Path traversal (user input in file paths)

**LOW Severity:**
- HTTP instead of HTTPS
- Missing security headers
- Verbose error messages (stack traces to client)
- TODO/FIXME comments mentioning security

### Step 3: Generate Report

Create `security-report.md`:

```markdown
# Security Review: {change-name}

## Summary
- **Critical**: {N} (must fix)
- **High**: {N} (should fix)
- **Medium**: {N} (fix if time)
- **Low**: {N} (nice to have)

## Critical Issues

### Issue 1: SQL Injection in auth.ts
**File**: `src/auth.ts:42`
**Code**: ```typescript
const query = "SELECT * FROM users WHERE id = '" + userId + "'";
```
**Risk**: Attacker can inject SQL, access/destroy data
**Fix**: Use parameterized queries
```typescript
const query = "SELECT * FROM users WHERE id = $1";
await db.query(query, [userId]);
```

## High Issues
...

## Recommendations
...
```

### Step 4: Present Findings

Show report to user:
```
## Security Review Complete

**Critical**: {N} | **High**: {N} | **Medium**: {N} | **Low**: {N}

### Critical (Fix Required)
1. SQL injection in auth.ts:42
2. Hardcoded API key in config.ts:15

### High (Should Fix)
1. Missing input validation in routes.ts:8

Shall I apply auto-fixes for obvious issues (1, 2)? [Y/n/details]
```

### Step 5: Apply Auto-Fixes (Optional)

For **obvious, safe fixes**:
- Extract hardcoded secrets to env vars
- Add basic input validation (length, type checks)
- Replace HTTP with HTTPS in URLs

For **complex fixes**:
- Provide detailed guidance
- Let user implement manually

## Return Summary

```
## Security Review Complete

**Change**: {change-name}
**Review Level**: basic

### Issues Found
| Severity | Count | Auto-fixed |
|----------|-------|------------|
| Critical | {N} | {N} |
| High | {N} | {N} |
| Medium | {N} | 0 |
| Low | {N} | {N} |

### Auto-Fixes Applied
- ✅ Extracted hardcoded API key to .env
- ✅ Added input validation for userId

### Manual Action Required
1. Refactor SQL query to use parameterized statements (auth.ts:42)
2. Implement proper error handling without stack traces

### Next Step
Fix remaining issues, then proceed to `/code-review`.
```

## Rules

- **Never skip critical issues** — always report SQL injection, hardcoded secrets
- **Provide concrete fixes** — not just "fix this", but "change X to Y"
- **Minimize false positives** — don't flag every console.log as "information disclosure"
- **Respect security level** — if `.c3pa/config.yaml` has `security.level: strict`, be more aggressive
