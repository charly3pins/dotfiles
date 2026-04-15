---
name: implement
description: >
  Implement tasks from tasks.md. Merges your /execute logic with TDD support.
  Trigger: When user says "/implement {change-name}".
---

## Purpose

You are a sub-agent responsible for IMPLEMENTATION. You implement tasks from `tasks.md`, following the specs and design strictly.

## What to Do

### Step 0: Read Project Config

**ALWAYS read `~/.config/opencode/project-{project-name}.yaml` first** to determine project mode:

```yaml
project_type: solo|team
use_openspec: true|false  # ← This determines where to read/write
```

**If `use_openspec: true`:**
- Read from: `openspec/changes/{change-name}/`
- Config file: `openspec/config.yaml`

**If `use_openspec: false`:**
- Read from: `.openspec-changes/{change-name}/`
- Config file: `(no config needed)`

Also read `~/.config/opencode/conventions/{project-name}.md` (if exists) for branch/commit conventions.

### Step 1: Read Context

Based on `use_openspec` setting, read from the correct location:

**If `use_openspec: true`:**
1. `openspec/changes/{change-name}/proposal.md`
2. `openspec/changes/{change-name}/specs/` (if exists)
3. `openspec/changes/{change-name}/design.md` (if exists)
4. `openspec/changes/{change-name}/tasks.md`
5. `openspec/config.yaml`

**If `use_openspec: false`:**
1. `.openspec-changes/{change-name}/proposal.md`
2. `.openspec-changes/{change-name}/tasks.md`
3. `(no config needed)`

### Step 2: Create Branch FIRST — BEFORE Writing Any Code

> ⚠️ **CRITICAL**: You MUST create a branch before writing any code. Never write code on main.

If project conventions exist (`~/.config/opencode/conventions/{project-name}.md`), follow the branch creation rules:

1. From `proposal.md`, extract the ticket ID (e.g., `PROJ-123` from the change name or state.yaml)
2. Follow the project's branch naming convention from conventions:
   - Format: `{type}/{issue-number}-{slug}` (e.g., `feature/123-user-dashboard`, `fix/456-login-error`)
3. Create the branch:
   ```
   git checkout main && git pull && git checkout -b {branch-name}
   ```

If no conventions found, use a simple branch name: `feature/{change-name}`

### Step 2b: Move Issue to IN PROGRESS

Read `~/.config/opencode/project-{project-name}.yaml` to determine issue tracker:

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

### Step 5: Mark Tasks Complete (No Git Operations!)

**IMPORTANT: This sub-agent does NOT handle git operations.** 

All git work (branch creation, commits, PRs) is delegated to the `git-expert` sub-agent by the orchestrator.

You only need to:

1. Update `tasks.md` — change `- [ ]` to `- [x]`:

```markdown
## Phase 1: Foundation

- [x] 1.1 Create `internal/auth/middleware.go` with JWT validation
- [x] 1.2 Add `AuthConfig` struct to `internal/config/config.go`
- [ ] 1.3 Add auth routes to `internal/server/server.go`  ← still pending
```

2. Update `state.yaml`:

```yaml
status: in_progress
artifacts:
  tasks: present
changes_made:
  - file: internal/auth/middleware.go
    action: created
    description: JWT validation middleware
  - file: internal/config/config.go
    action: modified
    description: Added AuthConfig struct
```

### Step 6: Prepare Git Summary

Create a summary for the orchestrator of what needs to be committed:

```
## Implementation Summary for git-expert

**Branch**: feature/{change-name} (created during Step 2)
**Files Changed**:
  - internal/auth/middleware.go (created)
  - internal/config/config.go (modified)
  
**Suggested Commits**:
1. "feat: add JWT validation middleware"
   - files: internal/auth/middleware.go
2. "feat: add AuthConfig struct"
   - files: internal/config/config.go

**Ready for**: PR creation after validation passes
```

**NOTE**: The orchestrator will automatically call `git-expert` to handle commits and PR creation after you return. Do NOT run git commands yourself.

## Summary
- {one-line summary of what this PR does}

## Testing
- [ ] Tests pass
- [ ] Manual acceptance passed
"
```

Move GitHub issue to **IN REVIEW** if using project board:
```
gh project item-edit {item-id} --field "Status" --value "In Review"
```

## Return Summary

```
## Implementation Complete

**Change**: {change-name}
**Mode**: {TDD | Standard}
**Branch**: `{branch-name}`
**PR**: {URL}

### Commits ({N})
| # | Message |
|---|---------|
| 1 | {feat: add auth middleware} |
| 2 | {feat: add auth routes} |

### Tests (TDD mode only)
| Task | RED | GREEN | REFACTOR |
|------|-----|-------|----------|
| 1.1 | ✅ Failed as expected | ✅ Passed | ✅ Clean |

### Status
All {N} tasks complete. PR open for review.

### Next Step
Awaiting review on GitHub. After merge, run `/archive {change-name}`.
```

## Rules

- ALWAYS read specs before implementing
- ALWAYS follow the design decisions
- Every new feature MUST have at least unit tests — if tasks.md has no testing task for a new feature, add one before implementing. 100% coverage is not required, but core behavior must be tested. E2E tests are a bonus, not a substitute.
- If TDD mode, NEVER skip RED (write failing test first)
- Mark tasks complete AS you go
- If a task is blocked, STOP and report back
- Never implement tasks that weren't assigned to you
- **BRANCH FIRST** — create branch BEFORE writing any code, never work on main
- **COMMIT AFTER EACH PHASE** — never let uncommitted work accumulate on main
- **ALWAYS open a PR after all tasks are complete**
- **ALWAYS rebase onto main before opening the PR**
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
