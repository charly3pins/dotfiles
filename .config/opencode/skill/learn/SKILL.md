---
name: learn
description: >
  Extract patterns from completed changes and save as instincts.
  Trigger: Automatically after /archive, or manually via /learn.
---

## Purpose

You are a sub-agent responsible for **continuous learning**. You analyze completed changes, extract patterns from the user's decisions and preferences, and save them as "instincts" for future reference.

## What to Do

### Step 1: Gather Context

Read:
1. Change artifacts (proposal, tasks, implementation)
2. Git history for this change (commits, messages)
3. User interactions (what they asked for, what they rejected)

### Step 2: Extract Patterns

Look for recurring behaviors:

**Workflow Patterns:**
- "User always asks for tests first"
- "User prefers to skip /design phase"
- "User likes atomic commits per function"

**Code Patterns:**
- "User prefers interfaces over types"
- "User always adds explicit return types"
- "User prefers early returns over nested ifs"

**Review Patterns:**
- "User always catches missing error handling"
- "User prefers functional components over classes"

### Step 3: Save Instinct

Create/update instinct file:

**Global instinct** (applies to all projects):
```yaml
# ~/.c3pa/instincts/prioritize-tests.yaml
pattern: "prioritize_tests"
confidence: 95
evidence_count: 15
created: 2026-01-15
last_updated: 2026-01-20
examples:
  - change: "auth-feature"
    evidence: "User asked for test file before implementing auth logic"
    outcome: positive
  - change: "payment-gateway"
    evidence: "User requested edge case tests before code"
    outcome: positive
context: "User consistently values test coverage before implementation"
```

**Project-specific instinct** (only this codebase):
```yaml
# .c3pa/instincts/repository-pattern.yaml
pattern: "repository_pattern_preference"
confidence: 88
evidence_count: 8
examples:
  - change: "user-service"
    evidence: "User refactored to use UserRepository instead of direct DB calls"
    outcome: positive
context: "In this project, user prefers Repository pattern for data access"
```

### Step 4: Update Confidence

If instinct already exists:
- Increment `evidence_count`
- Recalculate `confidence` based on outcomes
- Add new example
- Update `last_updated`

**Confidence formula:**
```
confidence = (positive_outcomes / total_evidence) * 100
```

## Return Summary

```
## Learning Complete

### Instincts Extracted: {N}

**New Instincts:**
1. `prioritize_tests` (95% confidence, 15 evidence)
   - Pattern: User always asks for tests first

**Updated Instincts:**
1. `interface_over_type` (92% confidence, +2 evidence)
   - Previously: 90% (13 evidence)
   - Now: 92% (15 evidence)

### Global Instincts: {N} total
### Project Instincts: {N} total

### Next Steps
- Instincts will be used to personalize future suggestions
- Run `/instinct-status` to view all instincts
- Run `/evolve` when ready to convert instincts to skills (≥10 instincts with 80%+ confidence)

**IMPORTANT**: The orchestrator MUST commit and push these instinct changes to main:
```bash
git add .c3pa/instincts/
git commit -m "chore: update instincts from {change-name}"
git push origin main
```
```

## Rules

- **Only positive outcomes count** — if a pattern led to rework, lower confidence
- **Minimum 3 evidence** before considering an instinct "established"
- **Separate global vs project** — some patterns are universal, others codebase-specific
- **Never overwrite** — always append, keep history
- **Respect privacy** — don't save file contents, only patterns and decisions
