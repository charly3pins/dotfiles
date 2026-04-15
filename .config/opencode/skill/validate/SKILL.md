---
name: validate
description: >
  Validate implementation against specs. Runs tests and compares against scenarios.
  Trigger: When user says "/validate {change-name}".
---

## Purpose

You are a sub-agent responsible for VERIFICATION. You prove that the implementation is complete and behaviorally compliant with the specs using real execution.

## What to Do

### Step 1: Read Project Config

**ALWAYS read `~/.config/opencode/project-{project-name}.yaml` first** to determine mode:
```yaml
use_openspec: true|false
project_type: solo|team
```

### Step 2: Read Context

**Based on `use_openspec`, read from correct location:**

**If `use_openspec: true`:**
1. `openspec/changes/{change-name}/proposal.md`
2. `openspec/changes/{change-name}/specs/` (if present, not skipped)
3. `openspec/changes/{change-name}/design.md` (if present, not skipped)
4. `openspec/changes/{change-name}/tasks.md`
5. `openspec/changes/{change-name}/state.yaml`
6. `openspec/config.yaml` or `(no config needed)`

**If `use_openspec: false`:**
1. `.openspec-changes/{change-name}/proposal.md`
2. `.openspec-changes/{change-name}/tasks.md`
3. `.openspec-changes/{change-name}/state.yaml`
4. `(no config needed)`

(Note: specs and design don't exist in simplified mode)

### Step 3: Check Completeness

Count completed vs total tasks in `tasks.md`.

### Step 3: Run Tests

Check `rules.verify.test_command` in `openspec/config.yaml`. Run the test command.

### Step 4: Build Check

Check `rules.verify.build_command` in `openspec/config.yaml`. Run the build command if available.

### Step 5: Spec Compliance Check

For EACH spec scenario, verify:
- Is the GIVEN precondition handled?
- Is the WHEN action implemented?
- Is the THEN outcome produced?

### Step 6: Write verify-report.md

```
openspec/changes/{change-name}/
├── ...
├── tasks.md
└── verify-report.md        ← You create this
```

```markdown
# Verification Report: {Change Title}

## Completeness

| Metric | Value |
|--------|-------|
| Tasks total | {N} |
| Tasks complete | {N} |
| Tasks incomplete | {N} |

---

## Build & Tests

**Build**: ✅ Passed / ❌ Failed
```
{build output or error}
```

**Tests**: ✅ {N} passed / ❌ {N} failed / ⚠️ {N} skipped
```
{failed test names and errors}
```

---

## Spec Compliance

| Requirement | Scenario | Status |
|-------------|----------|--------|
| {REQ-01} | {Scenario} | ✅ COMPLIANT / ❌ FAILING / ❌ UNTESTED |
| {REQ-02} | {Scenario} | ✅ COMPLIANT / ❌ FAILING / ❌ UNTESTED |

**Compliance summary**: {N}/{total} scenarios compliant

---

## Issues Found

**CRITICAL** (must fix before archive):
{List or "None"}

**WARNING** (should fix):
{List or "None"}

---

## Verdict
{PASS / PASS WITH WARNINGS / FAIL}
```

### Step 7: Update state.yaml

```yaml
artifacts:
  verify-report: present
```

## Return Summary

Return the same content as `verify-report.md`.

```
## Verification Complete

**Change**: {change-name}
**Verdict**: {PASS | PASS WITH WARNINGS | FAIL}

### Summary
- **Tasks**: {N}/{total} complete
- **Tests**: {N} passed / {N} failed
- **Compliance**: {N}/{total} scenarios compliant

### Next Step
Ready for `/code-review` → `/archive`.
```

## Rules

- ALWAYS run tests — static analysis alone is not verification
- A spec scenario is COMPLIANT only when a test passes proving it
- CRITICAL issues = must fix before archive
- WARNINGS = should fix but won't block
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
