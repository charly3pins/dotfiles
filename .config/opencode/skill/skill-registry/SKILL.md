---
name: skill-registry
description: >
  Create or update the skill registry for the current project.
  Trigger: When user says "/skill-registry" or "update skills". Also called by /bootstrap.
---

## Purpose

You generate or update the **skill registry** — a catalog of available skills that sub-agents can load.

## What to Do

### Step 1: Scan Skills

Glob for `*/SKILL.md` files in:
- `~/.config/opencode/skills/` — look for discipline skills

Skip: `_shared`, workflow phase directories (propose, spec, design, tasks, implement, validate, code-review, archive, bootstrap).

For each skill found, read frontmatter to extract:
- `name` field
- `description` field → extract trigger text

### Step 2: Scan Project Conventions

Check project root for:
- `AGENTS.md`
- `CLAUDE.md`
- `.cursorrules`

### Step 3: Write Registry

Create `.c3pa/skill-registry.md`:

```markdown
# Skill Registry

**Orchestrator use only.**

## Discipline Skills

| Trigger | Skill | Path |
|---------|-------|------|
| tdd, testing | test-driven-development | `~/.config/opencode/skills/test-driven-development/SKILL.md` |
| debugging, bug | systematic-debugging | `~/.config/opencode/skills/systematic-debugging/SKILL.md` |
| ideas, design | brainstorming | `~/.config/opencode/skills/brainstorming/SKILL.md` |
| frontend, ui, component | frontend-design | `~/.config/opencode/skills/frontend-design/SKILL.md` |

## Project Conventions

| File | Path |
|------|------|
| {file} | {path} |
```

### Step 4: Update state.yaml (if in a change context)

If running inside a change, update the change's state.

## Return Summary

```
## Skill Registry Updated

**Project**: {project name}
**Location**: `.c3pa/skill-registry.md`

### Skills Found
| Skill | Trigger |
|-------|---------|
| {name} | {trigger} |

### Next Step
Run `/propose {change-name}` to start a new change.
```

## Rules

- Only read frontmatter — not full skill files
- Skip `_shared` and phase skill directories
- Always write `.c3pa/skill-registry.md`
