---
name: archive
description: >
  Sync delta specs to main specs and archive a completed change.
  Trigger: When user says "/archive {change-name}".
---

## Purpose

You are a sub-agent responsible for ARCHIVING. You merge delta specs into the main specs, then move the change folder to archive.

## What to Do

### Step 0: Verify PR Merged

Before running archive, confirm:
- [ ] Manual acceptance passed
- [ ] PR is merged on GitHub

Archive is the **last step** — after merging. If the PR is not merged yet, do that first.

### Step 1: Read Context

**Based on `use_openspec`, read from correct location:**

**If `use_openspec: true`:**
1. `openspec/changes/{change-name}/verify-report.md` if it exists
2. `openspec/changes/{change-name}/state.yaml` — check `project_type`

**If `use_openspec: false`:**
1. `.openspec-changes/{change-name}/verify-report.md` if it exists (project root, gitignore this)
2. `.openspec-changes/{change-name}/state.yaml`

Check verdict — if FAIL (critical issues), warn and STOP.

### Step 2: Sync Delta Specs to Main Specs (OpenSpec mode only)

**If `use_openspec: false`:**
- Skip this step — no specs exist in simplified mode
- Go directly to Step 3

**If `use_openspec: true`:**

If `project_type: solo` and `artifacts.spec: skipped`:
- Skip this step — no specs were written to sync.

Otherwise, for each delta spec in `openspec/changes/{change-name}/specs/`:

- Skip this step — no specs were written to sync.

Otherwise, for each delta spec in `openspec/changes/{change-name}/specs/`:

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

**Based on `use_openspec`, move from correct location:**

**If `use_openspec: true`:**
```
openspec/changes/{change-name}/
  → openspec/changes/archive/{YYYY-MM-DD}-{change-name}/
```

**If `use_openspec: false`:**
```
.openspec-changes/{change-name}/      ← In project root (gitignore this)
  → ~/.config/opencode/archive/{YYYY-MM-DD}-{change-name}/  ← Global archive
```

Use today's date in ISO format.

### Step 4: Verify Archive

Confirm:
- [ ] Main specs updated correctly (OpenSpec mode only)
- [ ] Change folder moved to archive
- [ ] Archive contains all artifacts

### Step 5: Update .state.yaml

**Based on `use_openspec`:**

**If `use_openspec: true`:**
Update `openspec/changes/.state.yaml` to remove this change from active list.

**If `use_openspec: false`:**
No `.state.yaml` to update in simplified mode — just archive to global location.

### Step 6: Trigger Learning

After successful archive, suggest running `/learn` to extract patterns:

```
## Archive Complete
...

### Learning
📚 Analyzing change for patterns... 
Run `/instinct-status` to see learned patterns.
```

This extracts workflow patterns from the completed change for future personalization.

### Step 7: Remind About Commit/Push (CRITICAL)

**IMPORTANT**: After /archive and /learn complete, the orchestrator MUST commit and push the changes to main:

```bash
git add ~/.config/opencode/archive/ ~/.config/opencode/instincts/ SPEC.md
git commit -m "chore: archive {change-name} and learn patterns"
git push origin main
```

Without this step, the archive and learned instincts won't be persisted.

## Return Summary

```
## Change Archived

**Change**: {change-name}
**Archived to**: `openspec/changes/archive/{YYYY-MM-DD}-{change-name}/`
**PR Merged**: ✅

### Specs Synced
| Domain | Action | Details |
|--------|--------|---------|
| {domain} | Created/Updated | {N added, M modified, K removed requirements} |

### Archive Contents
- proposal.md ✅
- specs/ ✅ (or skipped for solo)
- design.md ✅ (or skipped for solo)
- tasks.md ✅
- verify-report.md ✅

### Learning
🔍 Patterns extracted automatically. Run `/instinct-status` to view.

### C3PA Cycle Complete
The change has been fully planned, implemented, verified, code-reviewed, manually accepted, and archived.
Ready for the next change.
```

## Rules

- NEVER archive a change that has CRITICAL issues
- NEVER archive before the PR is merged
- ALWAYS sync delta specs BEFORE moving to archive
- Use ISO date format (YYYY-MM-DD) for archive folder
- The archive is an AUDIT TRAIL — never delete or modify archived changes
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
