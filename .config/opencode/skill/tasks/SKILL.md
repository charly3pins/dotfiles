---
name: tasks
description: >
  Break down a change into an implementation task checklist. Merges your /plan logic.
  Trigger: When user says "/tasks {change-name}".
---

## Purpose

You are a sub-agent responsible for creating the TASK BREAKDOWN. You take the proposal, specs, and design, then produce a `tasks.md` with concrete, actionable implementation steps.

## What to Do

### Step 1: Read Project Config

**ALWAYS read `~/.config/opencode/project-{project-name}.yaml` first** to determine mode:
```yaml
use_openspec: true|false
```

### Step 2: Read Context

**Based on `use_openspec`, read from correct location:**

**If `use_openspec: true`:**
1. `openspec/changes/{change-name}/proposal.md`
2. `openspec/changes/{change-name}/state.yaml` — check `project_type` and artifact statuses
3. `openspec/changes/{change-name}/specs/` (if present, not skipped)
4. `openspec/changes/{change-name}/design.md` (if present, not skipped)

**If `use_openspec: false`:**
1. `.openspec-changes/{change-name}/proposal.md`
2. `.openspec-changes/{change-name}/state.yaml`
3. (No specs or design to read in simplified mode)

For **solo** projects with skipped specs/design, rely primarily on the proposal for scope and approach.

### Step 3: Write tasks.md

**Based on `use_openspec`:**

**If `use_openspec: true`:**
```
openspec/changes/{change-name}/
├── proposal.md
├── specs/ (if not skipped)
├── design.md (if not skipped)
└── tasks.md ← You create this
```

**If `use_openspec: false`:**
```
.openspec-changes/{change-name}/
├── proposal.md
└── tasks.md ← You create this
```

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
  └─ Unit tests (required for every new feature), integration/e2e tests (if applicable)

Phase 4: Cleanup
  └─ Documentation, remove dead code
```

### Testing Requirements

Every change that introduces new functionality MUST include at least unit tests in Phase 3. 100% coverage is not the goal, but every new feature needs tests covering its core behavior.

- **Unit tests**: required for every new feature — no exceptions
- **E2E / integration tests**: add when the feature crosses system boundaries or involves user-facing flows
- If a task genuinely has no testable behavior (e.g., config change, doc update), annotate it with `# no unit test needed` — make it a conscious decision, not an oversight

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
