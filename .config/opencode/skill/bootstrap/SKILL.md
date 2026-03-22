---
name: bootstrap
description: >
  Initialize Spec-Driven Development context in a project. Detects stack, conventions, and bootstraps OpenSpec.
  Trigger: When user says "/bootstrap" or "initialize" or "openspec init".
---

## Purpose

You are a sub-agent responsible for initializing the Spec-Driven Development context in a project. You detect the tech stack and conventions, then bootstrap the OpenSpec directory structure.

## What to Do

### Step 1: Detect Project Context

Read the project to understand:

- Tech stack (check `package.json`, `go.mod`, `pyproject.toml`, etc.)
- Existing conventions (linters, test frameworks, CI)
- Architecture patterns in use

### Step 2: Present Detection to User for Validation

Present what you found and ask for confirmation:

```
## Detected Stack

- **Tech Stack**: {e.g., React 19, TypeScript, Vite}
- **Testing**: {e.g., Vitest + React Testing Library}
- **Linting**: {e.g., ESLint + Prettier}
- **Architecture**: {e.g., Component-based, React Query}

### Questions
1. Is this correct?
2. Is there anything missing?
3. Any specific conventions to note?
```

Wait for user confirmation before proceeding.

### Step 2b: Ask About Issue Tracking

After stack validation, ask:

```
## Issue Tracking

Do you want to track issues with Spec-Driven Development?

1. **GitHub Issues** — uses `gh issue` and `gh project` commands
2. **Jira** — uses Jira API (requires MCP or CLI configured)
3. **Notion** — uses Notion API (requires MCP or CLI configured)
4. **No tracking** — manual tracking only (don't add issue commands)

If you choose a system, make sure the corresponding MCP is configured in ~/.config/opencode/opencode.json and enabled for this project.
```

Wait for user choice. Create `.sda/project.yaml` with the result:

```yaml
project_type: solo   # solo | team
issue_tracker:
  type: github   # github | jira | notion | none
  project: ""    # GitHub project number, Jira project key, or Notion database ID
```

This file is read by `/implement` to know how to move issues through stages.

### Step 2c: Ask About Project Type

After issue tracking, ask:

```
## Project Type

Is this a solo project or a team project?

1. **Solo** — Skip formal specs and design; move fast
2. **Team** — Full spec-driven workflow with code review
```

Wait for user choice. Update `.sda/project.yaml` to include `project_type`.

- **Solo**: Skips `/spec` and `/design`. Workflow: `/propose` → `/tasks` → `/implement` → `/validate` → `/code-review` → `/archive`
- **Team**: Full spec-driven flow with code review. Workflow: `/propose` → `/spec` → `/design` → `/tasks` → `/implement` → `/validate` → `/code-review` → `/archive`

### Step 3: Create OpenSpec Directory Structure

After validation, create:

```
openspec/
├── config.yaml              ← Project-specific config
├── specs/                   ← Source of truth (empty initially)
│   └── .gitkeep
└── changes/                 ← Active changes
    └── archive/             ← Completed changes
.sda/
├── project.yaml             ← Project type (solo | team) + issue tracker
├── skill-registry.md        ← Skill registry
└── conventions.md          ← Project conventions (AGENTS.md, etc.)
```

### Step 4: Generate Config

Create `openspec/config.yaml`:

```yaml
schema: spec-driven

context: |
  Tech stack: {detected stack}
  Architecture: {detected patterns}
  Testing: {detected test framework}
  Style: {detected linting/formatting}

mcp:
  # Uncomment to enable MCPs for this project.
  # MCPs are configured globally in ~/.config/opencode/opencode.json
  # Enable/disable per-project here.
  #
  # github:
  #   enabled: true
  #
  # jira:
  #   enabled: true
  #
  # confluence:
  #   enabled: true

rules:
  proposal:
    - Include rollback plan for risky changes
    - Identify affected modules/packages
    - Read external tickets if ticket ID provided (e.g., PROJ-123, #456)
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
  archive:
    - Warn before merging destructive deltas
```

### Step 5: Build Skill Registry

Scan skill directories for available discipline skills:

- `~/.config/opencode/skills/` — look for skills with frontmatter

For each skill found (skip `_shared`, `*-*` workflow skills), extract trigger from description.

Write `.sda/skill-registry.md`:

```markdown
# Skill Registry

**Orchestrator use only.**

## Discipline Skills

| Trigger                 | Skill                   | Path                                                         |
| ----------------------- | ----------------------- | ------------------------------------------------------------ |
| tdd, testing            | test-driven-development | `~/.config/opencode/skills/test-driven-development/SKILL.md` |
| debugging, bug          | systematic-debugging    | `~/.config/opencode/skills/systematic-debugging/SKILL.md`    |
| ideas, design           | brainstorming           | `~/.config/opencode/skills/brainstorming/SKILL.md`           |
| frontend, ui, component | frontend-design         | `~/.config/opencode/skills/frontend-design/SKILL.md`         |
```

### Step 6: Scan Project Conventions

Check project root for agent/convention files:

```
- AGENTS.md
- CLAUDE.md
- .cursorrules
- GEMINI.md
- .github/AGENTS.md
```

If found, write to `.sda/conventions.md`:

```markdown
# Project Conventions

**Read this file before any Spec-Driven work.**

## Files Found

| File | Path | Notes |
|------|------|-------|
| AGENTS.md | {path} | Main project conventions |
| ... | ... | ... |

## Key Conventions

{Pull out key rules from conventions files, especially:}

- Branch naming and creation rules
- Commit conventions
- PR workflow
- Naming conventions
- Cross-cutting rules (what to always do / never do)
```

### Step 7: Update state.yaml

Create `openspec/changes/.state.yaml` as a tracker (empty initially):

```yaml
changes: []
```

## Return Summary

```
## Spec-Driven Development Initialized

**Project**: {project name}
**Stack**: {detected stack}

### Structure Created
- `openspec/config.yaml` ← Project config
- `openspec/specs/` ← Ready for specifications
- `openspec/changes/` ← Ready for changes
- `.sda/project.yaml` ← Issue tracker ({type})
- `.sda/skill-registry.md` ← Skill registry
- `.sda/conventions.md` ← Project conventions (AGENTS.md, etc.)

### Issue Tracking
- **Type**: {github | jira | notion | none}
- **Project**: {project key/number}

### Project Type
- **{solo | team}**

### Next Steps
Ready for `/propose {change-name}|{ticket-id}`.
```

## Rules

- ALWAYS detect the real tech stack, don't guess
- ALWAYS validate with the user before creating files
- If `openspec/` already exists, report what exists and ask if it should be updated
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
