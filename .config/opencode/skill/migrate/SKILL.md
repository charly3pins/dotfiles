---
name: migrate
description: >
  One-time migration from thoughts/ folder to openspec/ framework.
  Trigger: When user says "/migrate" in a project with existing thoughts/ folder.
---

## Purpose

Migrate an old project from `thoughts/` to `openspec/` in one shot.

## What to Do

### Step 1: Detect thoughts/ Folder

Check if `thoughts/` exists in current project:
```
ls thoughts/
├── tickets/
├── plans/
├── research/
└── reviews/
```

If not found → report "No thoughts/ folder found. Nothing to migrate."

### Step 2: Audit Contents

List all files:
```
thoughts/
├── tickets/
│   ├── feature_user_dashboard.md
│   └── bug_login_validation.md
├── plans/
│   └── feature_user_dashboard.md
├── research/
│   └── feature_user_dashboard.md
└── reviews/
    └── feature_user_dashboard.md
```

### Step 3: Ask Migration Strategy

Present options:
```
## Found: {N} tickets, {N} plans, {N} research, {N} reviews

### Migration Options:
1. Active only — Migrate tickets with status 'open' or 'planned'. Archive rest.
2. Everything — Migrate all historical docs. Full audit trail.
3. Archive old — Move thoughts/ to thoughts.archive/ and start fresh with openspec/.

Which do you prefer?
```

Wait for user choice.

### Step 4: Execute Migration

#### For each ticket:

1. Read `thoughts/tickets/{name}.md`
2. Extract: type, description, requirements, scope
3. Create `openspec/changes/{name}/proposal.md`
4. Create `openspec/changes/{name}/state.yaml`:
   ```yaml
   change: {name}
   created: {from ticket}
   migrated_from: thoughts/
   status: planning
   ```

#### For each plan:

1. Read `thoughts/plans/{name}.md`
2. Extract: phases, tasks, success criteria
3. Create `openspec/changes/{name}/tasks.md`
4. If exists proposal, link them

#### For research (absorbed or .sda/):

1. Read `thoughts/research/{name}/*.md`
2. Either:
   - Absorb key findings into `proposal.md` → "Research Context" section
   - Create `.sda/research/{name}/` for reference material

#### For reviews:

1. Read `thoughts/reviews/{name}*.md`
2. Create `openspec/changes/{name}/verify-report.md` if meaningful

### Step 5: Archive Original

After migration:
```
mv thoughts/ thoughts.archive/
```

### Step 6: Report

```
## Migration Complete

**Project**: {name}
**Migrated**: {N} proposals, {N} tasks
**Archived**: thoughts/ → thoughts.archive/

### Files Created
- openspec/changes/{name1}/proposal.md
- openspec/changes/{name1}/tasks.md
- ...

### Next Step
Run `/propose` to start new changes with the new framework.
```

## Rules

- Always ask user which strategy before migrating
- Preserve original content — don't discard
- Mark migrated entries in `state.yaml` with `migrated_from: thoughts/`
- If ticket has linked plan/research, link them in openspec structure
