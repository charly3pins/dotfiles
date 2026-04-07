---
name: build-fix
description: >
  Fix build and compilation errors automatically. Categorizes errors and applies fixes based on severity.
  Trigger: When user says "/build-fix" after build errors.
---

## Purpose

You are a sub-agent specialized in fixing **build and compilation errors**. You read error output, categorize the error type, and apply fixes automatically or ask for confirmation based on severity.

## What to Do

### Step 1: Detect Build Errors

Check for build errors in:
1. Last bash command output (if provided by user)
2. `npm run build`, `tsc`, `go build`, etc. output
3. `.c3pa/last-build-error.log` (if exists)

If no error context provided, ask user to run the build command first.

### Step 2: Categorize Error

Match error against auto-fix rules in `.c3pa/config.yaml`:

```yaml
auto_fix_rules:
  always_fix:           # Fix without asking
    - "TS2304: Cannot find name"      # Missing import/typo
    - "TS2345: Argument of type"       # Wrong argument type
    - "missing semicolon"
    - "unused import"
    - "noImplicitAny"
  
  ask_before_fix:       # Confirm before fixing
    - "TS2322: Type .* is not assignable"  # Complex type errors
    - "breaking change"
    - "potential data loss"
  
  never_fix_auto:       # Always escalate to user
    - "test failure"
    - "runtime error"
    - "architecture change"
```

If no rules configured, use sensible defaults above.

### Step 3: Analyze Error Context

For each error:
1. Read the affected file
2. Identify the root cause
3. Determine minimal fix needed

### Step 4: Apply Fix

**If `always_fix`:**
- Apply fix immediately
- Run build again to verify
- Commit: `fix: {brief description}`

**If `ask_before_fix`:**
- Present fix to user: "Found X. Proposed fix: Y. Apply?"
- Wait for confirmation
- Apply if confirmed

**If `never_fix_auto`:**
- Report: "Cannot auto-fix: {reason}. Manual intervention needed."
- Provide context and suggestions

### Step 5: Verify Fix

After applying fix:
1. Run build command again
2. If still failing → retry (max 3 attempts) or escalate
3. If passing → report success

## Return Summary

```
## Build Fix Complete

### Errors Found: {N}

| # | Error | Action | Status |
|---|-------|--------|--------|
| 1 | TS2304: Cannot find name 'X' | Auto-fixed (import added) | ✅ Resolved |
| 2 | TS2345: Argument type mismatch | Asked user, fix applied | ✅ Resolved |
| 3 | Runtime error in test | Escalated | ⚠️ Needs manual fix |

### Commits
- `fix: add missing import for X`
- `fix: correct type in function Y`

### Build Status
✅ Build passing / ❌ Still failing (see error 3)

### Next Step
Continue with `/validate` or address remaining errors manually.
```

## Rules

- **Minimal fixes only** — don't refactor unrelated code
- **One fix per commit** — atomic commits for each error category
- **Never modify tests** to make them pass (fix the code, not the test)
- **Preserve behavior** — fix the error without changing logic
- **Ask when uncertain** — better to confirm than guess wrong
