---
name: archive
description: >
  Sync delta specs to main specs and archive a completed change.
  Trigger: When user says "/archive {change-name}".
---

## Purpose

You are a sub-agent responsible for ARCHIVING. You merge delta specs into the main specs, then move the change folder to archive.

## What to Do

### Step 1: Read Context

Read `openspec/changes/{change-name}/verify-report.md` if it exists.
Check verdict — if FAIL (critical issues), warn and STOP.

### Step 2: Sync Delta Specs to Main Specs

For each delta spec in `openspec/changes/{change-name}/specs/`:

#### If Main Spec Exists (`openspec/specs/{domain}/spec.md`)

Read existing spec, apply delta:
- ADDED Requirements → Append to main spec
- MODIFIED Requirements → Replace matching requirement
- REMOVED Requirements → Delete from main spec

#### If Main Spec Does NOT Exist

Copy delta spec directly:
```
openspec/changes/{change-name}/specs/{domain}/spec.md
  → openspec/specs/{domain}/spec.md
```

### Step 3: Move to Archive

Move the entire change folder with date prefix:

```
openspec/changes/{change-name}/
  → openspec/changes/archive/{YYYY-MM-DD}-{change-name}/
```

Use today's date in ISO format.

### Step 4: Verify Archive

Confirm:
- [ ] Main specs updated correctly
- [ ] Change folder moved to archive
- [ ] Archive contains all artifacts

### Step 5: Update .state.yaml

Update `openspec/changes/.state.yaml` to remove this change from active list.

## Return Summary

```
## Change Archived

**Change**: {change-name}
**Archived to**: `openspec/changes/archive/{YYYY-MM-DD}-{change-name}/`

### Specs Synced
| Domain | Action | Details |
|--------|--------|---------|
| {domain} | Created/Updated | {N added, M modified, K removed requirements} |

### Archive Contents
- proposal.md ✅
- specs/ ✅
- design.md ✅
- tasks.md ✅
- verify-report.md ✅

### Spec-Driven Cycle Complete
The change has been fully planned, implemented, verified, and archived.
Ready for the next change.
```

## Rules

- NEVER archive a change that has CRITICAL issues
- ALWAYS sync delta specs BEFORE moving to archive
- Use ISO date format (YYYY-MM-DD) for archive folder
- The archive is an AUDIT TRAIL — never delete or modify archived changes
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
