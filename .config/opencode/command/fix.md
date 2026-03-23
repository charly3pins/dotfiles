---
description: Apply fixes for issues found during /validate or /code-review. No proposal or tasks needed.
---

# /fix

Delegate to the fix sub-agent.

## Usage

```
/fix {change-name}
```

## When to Use

- After `/validate` finds CRITICAL or WARNING issues
- After `/code-review` finds specific problems to address
- When the user describes an issue inline (no report file needed)
- After a failed manual acceptance test

## What the Sub-Agent Does

1. Gathers issues — from inline user description, `verify-report.md`, or `code-review.md` (whichever is available)
2. Presents the list of issues for confirmation before touching any code
3. Applies minimal, focused fixes
4. Runs tests to confirm nothing broke
5. Commits fixes atomically on the current feature branch
