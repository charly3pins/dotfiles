---
name: fix
description: >
  Apply fixes for issues found during /validate or /code-review. No proposal or tasks needed.
  Trigger: When user says "/fix {change-name}" after validate or code-review findings.
---

## Purpose

You are a sub-agent responsible for FIXING issues. The source of issues can be anything: inline description from the user, a failed manual acceptance test, a warning from /validate, a finding from /code-review, or a bug the user spotted. No proposal, spec, or design required.

## What to Do

### Step 1: Gather Issues

Issues can come from multiple sources — use whatever is available:

1. **Inline** — issues described directly by the user in the message (highest priority, always use these)
2. **verify-report.md** — if it exists at `openspec/changes/{change-name}/verify-report.md`
3. **code-review.md** — if it exists at `openspec/changes/{change-name}/code-review.md`

None of these files are required. If the user described the issues inline, go straight to Step 2.

For additional context (optional, read only if helpful):
- `openspec/changes/{change-name}/proposal.md` — what the change does
- `.sda/conventions.md` — commit conventions

### Step 2: Apply Fixes

For each issue:
1. Read the affected file
2. Apply the minimal fix — do not refactor unrelated code
3. Verify the fix addresses the issue

### Step 3: Run Tests

If a test command is configured in `openspec/config.yaml`, run it after fixes:
```
{test_command}
```

Confirm tests pass before committing.

### Step 4: Commit Fixes

For each logical group of fixes, create an atomic commit:

```
git add {specific files}
git commit -S -m "fix: {brief description of what was fixed}"
```

Use `fix:` prefix for bug fixes, `refactor:` for code quality improvements.

### Step 5: Update verify-report.md (optional)

Only if `verify-report.md` exists, mark fixed issues as resolved:

```markdown
**Issue**: {description}
**Status**: ✅ Fixed in commit {hash}
```

Skip this step entirely if no `verify-report.md` exists.

## Return Summary

```
## Fixes Applied

**Change**: {change-name}

### Fixed
| # | Issue | Commit |
|---|-------|--------|
| 1 | {description} | {hash} |

### Skipped / Deferred
| # | Issue | Reason |
|---|-------|--------|
| 1 | {description} | {user decision} |

### Tests
{N} passed / {N} failed

### Next Step
{All issues resolved — ready for /archive / Remaining issues need attention}
```

## Rules

- Only fix what was identified — do not refactor or expand scope
- If the fix touches behavior that has no unit test, add one — fixing untested code is an opportunity to cover it
- ALWAYS run tests after fixing
- ALWAYS commit fixes atomically — one commit per logical fix group
- NEVER fix on main — fixes must be on the feature branch
- If an issue is ambiguous, ask before fixing
