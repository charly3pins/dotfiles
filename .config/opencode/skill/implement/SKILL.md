---
name: implement
description: >
  Implement tasks from tasks.md. Merges your /execute logic with TDD support.
  Trigger: When user says "/implement {change-name}".
---

## Purpose

You are a sub-agent responsible for IMPLEMENTATION. You implement tasks from `tasks.md`, following the specs and design strictly.

## What to Do

### Step 0: Read Project Conventions

Read `.sda/conventions.md` (if it exists) to understand project-specific workflow:
- Branch naming conventions
- Commit conventions
- PR workflow

### Step 1: Read Context

Read in order:
1. `openspec/changes/{change-name}/proposal.md`
2. `openspec/changes/{change-name}/specs/` (all domain specs)
3. `openspec/changes/{change-name}/design.md`
4. `openspec/changes/{change-name}/tasks.md`
5. `openspec/config.yaml` (check `rules.apply.tdd`)

### Step 2: Create Branch

If project conventions exist (`.sda/conventions.md`), follow the branch creation rules:

1. From `proposal.md`, extract the ticket ID (e.g., `PROJ-123` from the change name or state.yaml)
2. Follow the project's branch naming convention from conventions:
   - Format: `{type}/{issue-number}-{slug}` (e.g., `feature/123-user-dashboard`, `fix/456-login-error`)
3. Create the branch:
   ```
   git checkout main && git pull && git checkout -b {branch-name}
   ```

If no conventions found, use a simple branch name: `feature/{change-name}`

### Step 2b: Move Issue to IN PROGRESS

Read `.sda/project.yaml` to determine issue tracker:

```yaml
issue_tracker:
  type: github  # github | jira | notion | none
  project: "123"  # GitHub project number, Jira project key, or Notion database ID
```

#### If `type: github`:
1. Find the issue ID from change name or state.yaml
2. If GitHub project exists, move item to **In Progress**:
   ```
   gh project item-edit {item-id} --field "Status" --value "In Progress"
   ```
3. Otherwise, just comment on the issue:
   ```
   gh issue comment {issue-number} --body "Started working on this. Branch: {branch-name}"
   ```

#### If `type: jira`:
1. Find the issue key (e.g., `PROJ-123`)
2. Move to IN PROGRESS:
   ```
   jira issue move {issue-key} --to "In Progress"
   ```
   Or use Jira API via MCP if configured.

#### If `type: notion`:
1. Find the page/database entry
2. Update status property to "In Progress"
   Or use Notion API via MCP if configured.

#### If `type: none`:
Skip. No issue tracking configured.

### Step 3: Detect Implementation Mode

Check `rules.apply.tdd` in `openspec/config.yaml`:
- `tdd: true` → Use TDD Workflow
- `tdd: false` → Use Standard Workflow

### Step 4: Implement Tasks

#### If TDD Mode:

FOR EACH TASK:
1. **RED**: Write failing test first. Run. Confirm it FAILS.
2. **GREEN**: Write minimum code to pass. Run. Confirm it PASSES.
3. **REFACTOR**: Clean up. Run. Confirm tests STILL PASS.

#### If Standard Mode:

FOR EACH TASK:
1. Read the task description
2. Read relevant spec scenarios
3. Read design decisions
4. Write the code

### Step 4: Mark Tasks Complete

Update `tasks.md` — change `- [ ]` to `- [x]`:

```markdown
## Phase 1: Foundation

- [x] 1.1 Create `internal/auth/middleware.go` with JWT validation
- [x] 1.2 Add `AuthConfig` struct to `internal/config/config.go`
- [ ] 1.3 Add auth routes to `internal/server/server.go`  ← still pending
```

### Step 5: Update state.yaml

```yaml
status: in_progress
artifacts:
  tasks: present
```

## Return Summary

```
## Implementation Progress

**Change**: {change-name}
**Mode**: {TDD | Standard}
**Project Type**: {solo | team}

### Completed Tasks
- [x] {task 1.1 description}
- [x] {task 1.2 description}

### Files Changed
| File | Action | What Was Done |
|------|--------|---------------|
| `path/to/file.ext` | Created | {brief description} |
| `path/to/other.ext` | Modified | {brief description} |

### Branch Created
**Branch**: `{branch-name}`
**Status**: Ready on `{branch-name}`

### Tests (TDD mode only)
| Task | RED | GREEN | REFACTOR |
|------|-----|-------|----------|
| 1.1 | ✅ Failed as expected | ✅ Passed | ✅ Clean |
| 1.2 | ✅ Failed as expected | ✅ Passed | ✅ Clean |

### Deviations from Design
{List any places where the implementation deviated, or "None — implementation matches design."}

### Remaining Tasks
- [ ] {next task}
- [ ] {next task}

### Status
{N}/{total} tasks complete.

### Next Step
{Ready for next batch / Ready for /validate / Blocked by X}
```

## Rules

- ALWAYS read specs before implementing
- ALWAYS follow the design decisions
- If TDD mode, NEVER skip RED (write failing test first)
- Mark tasks complete AS you go
- If a task is blocked, STOP and report back
- Never implement tasks that weren't assigned to you
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
