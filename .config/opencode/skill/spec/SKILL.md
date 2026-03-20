---
name: spec
description: >
  Write detailed specifications with Given/When/Then scenarios (delta specs).
  Trigger: When user says "/spec {change-name}".
---

## Purpose

You are a sub-agent responsible for writing SPECIFICATIONS. You take the proposal and produce delta specs — structured requirements and scenarios that describe what's being ADDED, MODIFIED, or REMOVED.

## What to Do

### Step 1: Read Proposal

Read `openspec/changes/{change-name}/proposal.md` to understand the scope.

### Step 2: Identify Affected Domains

From the proposal's "Affected Areas", determine which spec domains are touched (e.g., `auth/`, `payments/`, `ui/`).

### Step 3: Read Existing Specs

If `openspec/specs/{domain}/spec.md` exists, read it to understand CURRENT behavior. Your delta specs describe CHANGES to this behavior.

### Step 4: Write Delta Specs

Create specs inside the change folder:

```
openspec/changes/{change-name}/
├── proposal.md
└── specs/
    └── {domain}/
        └── spec.md          ← Delta spec
```

#### Delta Spec Format

```markdown
# Delta for {Domain}

## ADDED Requirements

### Requirement: {Requirement Name}

{Description using RFC 2119 keywords: MUST, SHALL, SHOULD, MAY}

#### Scenario: {Happy path}

- GIVEN {precondition}
- WHEN {action}
- THEN {expected outcome}

#### Scenario: {Edge case}

- GIVEN {precondition}
- WHEN {action}
- THEN {expected outcome}

## MODIFIED Requirements

### Requirement: {Existing Requirement Name}

{New description — replaces the existing one}
(Previously: {what it was before})

## REMOVED Requirements

### Requirement: {Requirement Being Removed}

(Reason: {why this requirement is being deprecated/removed})
```

#### For NEW Specs (No Existing Spec)

If this is a completely new domain, create a FULL spec:

```markdown
# {Domain} Specification

## Purpose

{High-level description of this spec's domain.}

## Requirements

### Requirement: {Name}

The system {MUST/SHALL/SHOULD} {behavior}.

#### Scenario: {Name}

- GIVEN {precondition}
- WHEN {action}
- THEN {outcome}
```

### Step 5: Update state.yaml

```yaml
artifacts:
  spec: present
```

## Return Summary

```
## Specs Created

**Change**: {change-name}

### Specs Written
| Domain | Type | Requirements | Scenarios |
|--------|------|-------------|-----------|
| {domain} | Delta/New | {N added, M modified, K removed} | {total scenarios} |

### Next Step
Ready for `/design`.
```

## Rules

- ALWAYS use Given/When/Then format for scenarios
- ALWAYS use RFC 2119 keywords (MUST, SHALL, SHOULD, MAY)
- If existing specs exist, write DELTA specs (ADDED/MODIFIED/REMOVED)
- If NO existing specs for the domain, write a FULL spec
- Every requirement MUST have at least ONE scenario
- Keep spec under 650 words
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`

## RFC 2119 Keywords

| Keyword | Meaning |
|---------|---------|
| **MUST / SHALL** | Absolute requirement |
| **MUST NOT / SHALL NOT** | Absolute prohibition |
| **SHOULD** | Recommended, but exceptions may exist |
| **SHOULD NOT** | Not recommended |
| **MAY** | Optional |
