---
name: tasks
description: >
  Break down a change into an implementation task checklist. Merges your /plan logic.
  Trigger: When user says "/tasks {change-name}".
---

## Purpose

You are a sub-agent responsible for creating the TASK BREAKDOWN. You take the proposal, specs, and design, then produce a `tasks.md` with concrete, actionable implementation steps.

## What to Do

### Step 1: Read Context

Read in order:
1. `openspec/changes/{change-name}/proposal.md`
2. `openspec/changes/{change-name}/state.yaml` — check `project_type` and artifact statuses
3. `openspec/changes/{change-name}/specs/` (if present)
4. `openspec/changes/{change-name}/design.md` (if present)

For **solo** projects with skipped specs/design, rely primarily on the proposal for scope and approach.

### Step 2: Analyze the Design

From the design document, identify:
- All files that need to be created/modified/deleted
- The dependency order (what must come first)
- Testing requirements per component

### Step 3: Write tasks.md

```
openspec/changes/{change-name}/
├── proposal.md
├── specs/
├── design.md
└── tasks.md               ← You create this
```

```markdown
# Tasks: {Change Title}

## Phase 1: {Phase Name} (e.g., Foundation / Infrastructure)

- [ ] 1.1 {Concrete action — what file, what change}
- [ ] 1.2 {Concrete action}
- [ ] 1.3 {Concrete action}

## Phase 2: {Phase Name} (e.g., Core Implementation)

- [ ] 2.1 {Concrete action}
- [ ] 2.2 {Concrete action}
- [ ] 2.3 {Concrete action}

## Phase 3: {Phase Name} (e.g., Testing)

- [ ] 3.1 {Write tests for ...}
- [ ] 3.2 {Write tests for ...}

## Phase 4: {Phase Name} (e.g., Cleanup)

- [ ] 4.1 {Update docs/comments}
- [ ] 4.2 {Remove temporary code}
```

### Task Writing Rules

Each task MUST be:

| Criteria | Example | Anti-example |
|----------|---------|--------------|
| **Specific** | "Create `internal/auth/middleware.go` with JWT validation" | "Add auth" |
| **Actionable** | "Add `ValidateToken()` method to `AuthService`" | "Handle tokens" |
| **Verifiable** | "Test: `POST /login` returns 401 without token" | "Make sure it works" |
| **Small** | One file or one logical unit of work | "Implement the feature" |

### Phase Organization

```
Phase 1: Foundation / Infrastructure
  └─ New types, interfaces, database changes, config

Phase 2: Core Implementation
  └─ Main logic, business rules, core behavior

Phase 3: Testing
  └─ Unit tests, integration tests

Phase 4: Cleanup
  └─ Documentation, remove dead code
```

### Step 4: Update state.yaml

```yaml
artifacts:
  tasks: present

status: planned
```

## Return Summary

```
## Tasks Created

**Change**: {change-name}
**Location**: `openspec/changes/{change-name}/tasks.md`

### Breakdown
| Phase | Tasks | Focus |
|-------|-------|-------|
| Phase 1 | {N} | {Name} |
| Phase 2 | {N} | {Name} |
| Phase 3 | {N} | {Name} |
| Total | {N} | |

### Implementation Order
{Brief description of the recommended order}

### Next Step
Ready for `/implement`.
```

## Rules

- ALWAYS reference concrete file paths in tasks
- Tasks MUST be ordered by dependency
- Testing tasks should reference specific scenarios from the specs
- Each task should be completable in ONE session
- Use hierarchical numbering: 1.1, 1.2, 2.1, 2.2
- NEVER include vague tasks like "implement feature"
- Keep tasks under 530 words total
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
