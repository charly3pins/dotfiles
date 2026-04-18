# typescript-reviewer Skill

**Trigger**: `.ts` files, "type", "interface", "generic", "typescript"

**Purpose**: TypeScript-specific code review for type safety and modern patterns.

## When to Use

Auto-invoked when Builder works on `.ts` or `.tsx` files.

## Checklist

### Type Safety
- [ ] No implicit `any` (strict mode)
- [ ] Proper use of `unknown` vs `any`
- [ ] Type guards used correctly

### Strict Null Checks
- [ ] Nullable values handled
- [ ] Non-null assertions (`!`) justified
- [ ] Optional chaining (`?.`) used appropriately

### Async/Await
- [ ] Promises properly awaited
- [ ] No floating promises
- [ ] try/catch around async operations

### Modern Patterns
- [ ] `const` assertions where appropriate
- [ ] `satisfies` operator for type validation
- [ ] Proper enum vs union types
- [ ] Interface vs type alias best practices

### DX & Maintainability
- [ ] Return types explicit on public functions
- [ ] Proper error types (never `any` in catch)
