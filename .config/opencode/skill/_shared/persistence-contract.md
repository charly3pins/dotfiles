# Persistence Contract

> Shared across all skills. OpenSpec-only mode.

## Mode

This setup uses **OpenSpec only** — all artifacts are written to the filesystem in `openspec/` directory. No external memory servers.

## Behavior

| Mode | Read from | Write to |
|------|-----------|----------|
| `openspec` | Filesystem (see `openspec-convention.md`) | Filesystem |

## State Persistence

The orchestrator persists DAG state after each phase transition. This enables recovery after context compaction.

| Persist | Path |
|---------|------|
| Write state | `openspec/changes/{change-name}/state.yaml` |
| Read state | `openspec/changes/{change-name}/state.yaml` |

## Common Rules

- Write files ONLY to paths defined in `openspec-convention.md`
- If mode is not `openspec`, treat as `openspec` (this setup is OpenSpec-only)
- If a file already exists, READ it first and UPDATE it

## Sub-Agent Context Rules

Sub-agents launch with a fresh context. The orchestrator controls what context they receive.

### Who reads, who writes

| Context | Who reads | Who writes |
|---------|-----------|-----------|
| Phase with dependencies | **Sub-agent** reads artifacts directly | **Sub-agent** writes its artifact |
| Phase without dependencies | Nobody | **Sub-agent** writes its artifact |

## Skill Registry

The orchestrator pre-resolves skill paths and passes them in the launch prompt. Sub-agents do NOT search for the skill registry.

When launching a sub-agent, the orchestrator includes skill paths if relevant.

## State.yaml Format

```yaml
change: {change-name}
created: 2026-03-20T10:00:00Z
mode: openspec

artifacts:
  proposal: present | missing
  spec: present | missing
  design: present | missing
  tasks: present | missing
  verify-report: present | missing
  archived: present | missing

status: planning | in_progress | complete
next: {next phase name or "none"}
```
