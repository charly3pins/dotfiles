---
name: code-review
description: >
  Human code review. Merges your /review logic.
  Trigger: When user says "/code-review {change-name}" or "/review {change-name}".
---

## Purpose

You are a sub-agent responsible for HUMAN CODE REVIEW. You facilitate the review checklist by reading the implementation and presenting findings.

## What to Do

### Step 1: Read Context

Read in order:
1. `openspec/changes/{change-name}/proposal.md`
2. `openspec/changes/{change-name}/tasks.md`
3. `openspec/changes/{change-name}/verify-report.md` (if exists)
4. `openspec/changes/{change-name}/design.md`

### Step 2: Read Changed Files

Read all files modified as part of this change.

### Step 4: Systematic Review

For each changed file, check for:
- **Logic errors**: Does the code do what the spec says?
- **Security issues**: Input validation, auth checks, data exposure
- **Performance concerns**: N+1 queries, missing indexes, large data handling
- **Code style**: Follows existing patterns
- **Edge cases**: Error handling, boundary conditions
- **Missing pieces**: Tests, docs, error messages

### Step 5: Present Review Findings

Present findings to the user for their review:

```
## Code Review: {change-name}

### Files Reviewed
| File | Changes | Key Findings |
|------|---------|-------------|
| `path/to/file.ts` | Modified | {brief} |

### Logic & Correctness
- [ ] Code matches spec scenarios ✅/⚠️
- [ ] Error handling is robust ✅/⚠️
- [ ] Edge cases are covered ✅/⚠️

### Security
- [ ] Input validation present ✅/⚠️
- [ ] Auth checks where needed ✅/⚠️
- [ ] No data exposure ✅/⚠️

### Performance
- [ ] No N+1 queries ✅/⚠️
- [ ] Proper indexing where needed ✅/⚠️

### Testing
- [ ] Unit tests exist ✅/⚠️
- [ ] Tests cover key scenarios ✅/⚠️

### Specific Findings

**Issue 1**: {description}
- File: `path/to/file:line`
- Severity: CRITICAL / WARNING / SUGGESTION
- {What to fix or improve}

**Issue 2**: ...

### Questions for Reviewer
1. {Any questions about the implementation}
```

### Step 6: Await User Feedback

The user reviews the findings and decides what to address.

### Step 7: Update state.yaml

```yaml
artifacts:
  code-review: complete
```

## Return Summary

```
## Code Review Complete

**Change**: {change-name}
**Branch**: `{branch-name}`

### Summary
- **Files reviewed**: {N}
- **Critical issues**: {N}
- **Warnings**: {N}
- **Suggestions**: {N}

### Manual Acceptance
See the Manual Acceptance section above — run it before archiving.

### Next Step
Manual acceptance → Merge PR → `/archive`.
```
{relevant start command, e.g., `npm run dev`, `go run cmd/server/main.go`, `docker compose up`, etc.}
```

**Test the change**:
1. {Specific step to trigger the feature}
2. {What to look for — expected behavior}
3. {Edge cases to try}

**Stop the app** when done testing.

#### PR Review

After manual acceptance:
1. Go to GitHub and open the PR for branch `{branch-name}`
2. Review the diff — check for unintended changes, test coverage, anything missed
3. If everything looks good: **merge the PR**
4. Then run `/archive {change-name}` to close the change

### Next Step
Run manual acceptance, merge PR on GitHub, then `/archive`.
```

## Rules

- Be thorough but practical — focus on what matters
- Document everything clearly for human review
- Present findings in a way that's actionable
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
