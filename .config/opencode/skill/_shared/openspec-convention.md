# OpenSpec File Convention

> Shared across all skills. OpenSpec-only mode.

## Directory Structure

```
openspec/
├── config.yaml              <- Project-specific config
├── specs/                   <- Source of truth (main specs)
│   └── {domain}/
│       └── spec.md
└── changes/                 <- Active changes
    ├── archive/             <- Completed changes (YYYY-MM-DD-{change-name}/)
    └── {change-name}/       <- Active change folder
        ├── state.yaml       <- DAG state (survives context compaction)
        ├── proposal.md      <- from /propose
        ├── specs/           <- from /spec
        │   └── {domain}/
        │       └── spec.md  <- Delta spec
        ├── design.md        <- from /design
        ├── tasks.md         <- from /tasks (updated by /implement)
        └── verify-report.md <- from /validate
```

## Artifact File Paths

| Skill | Creates / Reads | Path |
|-------|----------------|------|
| orchestrator | Creates/Updates | `openspec/changes/{change-name}/state.yaml` |
| /bootstrap | Creates | `openspec/config.yaml`, `openspec/specs/`, `openspec/changes/` |
| /propose | Creates | `openspec/changes/{change-name}/proposal.md` |
| /spec | Creates | `openspec/changes/{change-name}/specs/{domain}/spec.md` |
| /design | Creates | `openspec/changes/{change-name}/design.md` |
| /tasks | Creates | `openspec/changes/{change-name}/tasks.md` |
| /implement | Updates | `openspec/changes/{change-name}/tasks.md` (marks `[x]`) |
| /validate | Creates | `openspec/changes/{change-name}/verify-report.md` |
| /archive | Moves | `openspec/changes/{change-name}/` → `openspec/changes/archive/YYYY-MM-DD-{change-name}/` |
| /archive | Updates | `openspec/specs/{domain}/spec.md` (merges deltas) |

## Reading Artifacts

Each skill reads its dependencies from the filesystem:

```
Config:    openspec/config.yaml
Proposal:  openspec/changes/{change-name}/proposal.md
Specs:     openspec/changes/{change-name}/specs/  (all domain subdirectories)
Design:    openspec/changes/{change-name}/design.md
Tasks:     openspec/changes/{change-name}/tasks.md
Verify:    openspec/changes/{change-name}/verify-report.md
Main specs: openspec/specs/{domain}/spec.md
State:     openspec/changes/{change-name}/state.yaml
```

## Writing Rules

- ALWAYS create the change directory (`openspec/changes/{change-name}/`) before writing artifacts
- If a file already exists, READ it first and UPDATE it (don't overwrite blindly)
- If the change directory already exists with artifacts, the change is being CONTINUED
- Use `openspec/config.yaml` `rules` section to apply project-specific constraints per phase

## Config File Reference

```yaml
# openspec/config.yaml
schema: spec-driven

context: |
  Tech stack: {detected}
  Architecture: {detected}
  Testing: {detected}
  Style: {detected}

rules:
  proposal:
    - Include rollback plan for risky changes
  specs:
    - Use Given/When/Then for scenarios
    - Use RFC 2119 keywords (MUST, SHALL, SHOULD, MAY)
  design:
    - Document architecture decisions with rationale
  tasks:
    - Group by phase, use hierarchical numbering
    - Keep tasks completable in one session
  apply:
    - Follow existing code patterns
    tdd: false           # Set to true to enable RED-GREEN-REFACTOR
    test_command: ""     # e.g., "npm test", "pytest"
  verify:
    test_command: ""
    build_command: ""
    coverage_threshold: 0
  archive:
    - Warn before merging destructive deltas
```

## Archive Structure

When archiving, the change folder moves to:
```
openspec/changes/archive/YYYY-MM-DD-{change-name}/
```

Use today's date in ISO format. The archive is an AUDIT TRAIL — never delete or modify archived changes.
