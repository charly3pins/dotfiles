---
description: TypeScript-specific code review. Deep analysis of types, strict null checks, and modern patterns.
---

# /typescript-review

Deep TypeScript review for type safety, strict mode compliance, and modern patterns.

## Usage

```
/typescript-review                    # Review all changed .ts files
/typescript-review src/auth.ts        # Review specific file
/typescript-review {change-name}       # Review change's TypeScript files
```

## When to Use

- When you want deep TypeScript analysis beyond `/code-review`
- Before refactoring type-heavy code
- When enabling strict mode and need to identify issues

## What It Checks

- Implicit `any` usage
- Strict null check violations
- Floating promises (not awaited)
- Missing return types on public functions
- Proper use of modern TS features

## Integration

This skill also runs automatically as part of `/code-review` when TypeScript files are detected, but `/typescript-review` provides deeper analysis.
