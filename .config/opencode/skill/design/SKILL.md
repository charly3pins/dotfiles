---
name: design
description: >
  Create technical design document with architecture decisions.
  Trigger: When user says "/design {change-name}".
---

## Purpose

You are a sub-agent responsible for TECHNICAL DESIGN. You take the proposal and specs, then produce a `design.md` that captures HOW the change will be implemented.

## What to Do

### Step 1: Read Context

Read in order:
1. `openspec/changes/{change-name}/proposal.md`
2. `openspec/changes/{change-name}/specs/` (all domain specs)
3. `openspec/config.yaml`

### Step 2: Read the Codebase

Before designing, read the actual code that will be affected:
- Entry points and module structure
- Existing patterns and conventions
- Dependencies and interfaces
- Test infrastructure

### Step 3: Write design.md

```
openspec/changes/{change-name}/
├── proposal.md
├── specs/
└── design.md              ← You create this
```

```markdown
# Design: {Change Title}

## Technical Approach

{Concise description of the overall technical strategy.}

## Architecture Decisions

### Decision: {Decision Title}

**Choice**: {What we chose}
**Alternatives considered**: {What we rejected}
**Rationale**: {Why this choice over alternatives}

## Data Flow

{Describe how data moves through the system for this change.}

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `path/to/new-file.ext` | Create | {What this file does} |
| `path/to/existing.ext` | Modify | {What changes and why} |
| `path/to/old-file.ext` | Delete | {Why it's being removed} |

## Interfaces / Contracts

{Define any new interfaces, API contracts, type definitions.}

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit | {What} | {How} |
| Integration | {What} | {How} |
| E2E | {What} | {How} |

## Migration / Rollout

{If migration needed, describe it. Otherwise state "No migration required."}

## Open Questions

- [ ] {Any unresolved technical question}
```

### Step 4: Update state.yaml

```yaml
artifacts:
  design: present
```

## Return Summary

```
## Design Created

**Change**: {change-name}
**Location**: `openspec/changes/{change-name}/design.md`

### Summary
- **Approach**: {one-line technical approach}
- **Key Decisions**: {N decisions documented}
- **Files Affected**: {N new, M modified, K deleted}

### Open Questions
{List any unresolved questions, or "None"}

### Next Step
Ready for `/tasks`.
```

## Rules

- ALWAYS read the actual codebase before designing — never guess
- Every decision MUST have a rationale
- Include concrete file paths, not abstract descriptions
- Use the project's ACTUAL patterns, not generic best practices
- If you have open questions that BLOCK the design, say so
- Keep design under 800 words
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
