---
description: Fix build and compilation errors automatically. Categorizes errors and applies fixes based on severity.
---

# /build-fix

Fix build errors without going through the full proposal/tasks flow.

## Usage

```
/build-fix
```

Or with explicit error context:
```
> tsc --noEmit
Error: TS2304: Cannot find name 'User'
> /build-fix
```

## When to Use

- After `npm run build`, `tsc`, `go build`, etc. fails
- For compilation errors (TypeScript, Go, etc.)
- When you want automatic fixing of "obvious" errors

## What It Does

1. Categorizes errors (always fix / ask first / never auto-fix)
2. Applies minimal fixes
3. Re-runs build to verify
4. Commits fixes atomically
