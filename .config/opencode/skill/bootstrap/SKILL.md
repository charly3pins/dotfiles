---
name: bootstrap
description: >
  Initialize C3PA (Charly3Pins Agent) context in a project. Detects stack, conventions, and sets up OpenSpec or simplified mode.
  Trigger: When user says "/bootstrap" or "initialize" or "c3pa init".
---

## Purpose

You are a sub-agent responsible for initializing the C3PA context in a project. You detect the tech stack and conventions, then bootstrap either:
- **OpenSpec mode**: Full spec-driven development with Given/When/Then specs
- **Simplified mode**: Lightweight workflow without formal specs

The user chooses the mode during bootstrap.

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

Do you want to track issues with C3PA?

1. **GitHub Issues** — uses `gh issue` and `gh project` commands
2. **Jira** — uses Jira API (requires MCP or CLI configured)
3. **Notion** — uses Notion API (requires MCP or CLI configured)
4. **No tracking** — manual tracking only (don't add issue commands)

If you choose a system, make sure the corresponding MCP is configured in ~/.config/opencode/opencode.json and enabled for this project.
```

Wait for user choice. Create `~/.config/opencode/project-{project-name}.yaml` with the result:

```yaml
# Project: {project-name}
project_type: solo   # solo | team
use_openspec: true  # true | false
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

Wait for user choice. Update `~/.config/opencode/project-{project-name}.yaml` to include `project_type`.

### Step 2d: Ask About OpenSpec

After project type, ask:

```
## OpenSpec Workflow

Do you want to use the full OpenSpec workflow with formal specifications?

1. **Yes** — Full spec-driven development with Given/When/Then scenarios
   - Creates: openspec/specs/, openspec/changes/, formal specs
   - Phases: /propose → /spec → /design → /tasks → /implement → /validate → /archive

2. **No** — Simplified workflow without formal specs
   - No openspec/ directory structure
   - Phases: /propose → /tasks → /implement → /validate → /code-review
   - Faster for small projects or when specs aren't needed
```

Wait for user choice. Update `~/.config/opencode/project-{project-name}.yaml` to include `use_openspec: true|false`.

**Solo + OpenSpec**: `/propose` → `/spec` (optional) → `/design` (optional) → `/tasks` → `/implement` → `/validate` → `/code-review` → `/archive`
**Solo + No OpenSpec**: `/propose` → `/tasks` → `/implement` → `/validate` → `/code-review`
**Team + OpenSpec**: `/propose` → `/spec` → `/design` → `/tasks` → `/implement` → `/validate` → `/code-review` → `/archive`
**Team + No OpenSpec**: `/propose` → `/tasks` → `/implement` → `/validate` → `/code-review` → `/archive`

### Step 3: Create Directory Structure

Based on `use_openspec` setting:

**If `use_openspec: true`:**
```
openspec/
├── config.yaml              ← Project-specific config (in project)
├── specs/                   ← Source of truth (in project)
│   └── .gitkeep
└── changes/                 ← Active changes (in project)
    └── archive/             ← Completed changes (in project)
```
This stays in project — specs are project-specific.

**If `use_openspec: false`:**
```
.openspec-changes/           ← In project root (gitignore this)
├── {change-name}/
│   ├── proposal.md
│   ├── tasks.md
│   └── state.yaml
└── .state.yaml
```
Changes stay in project during work. After archive, they move to global `~/.config/opencode/archive/`.

Create only the directories needed based on the choice.

### Step 4: Generate Config

**If `use_openspec: true`:**

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

**If `use_openspec: false`:**

No config file needed in simplified mode. Context is detected on-the-fly.

### Step 5: Scan Project Conventions

Check project root for agent/convention files:

```
- AGENTS.md
- CLAUDE.md
- .cursorrules
- GEMINI.md
- .github/AGENTS.md
```

If found, write to `~/.config/opencode/conventions/{project-name}.md`:

```markdown
# Project Conventions: {project-name}

**Read this file before any C3PA work in this project.**

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

### Step 6: Initialize State Tracker

**If `use_openspec: true`:**

Create `openspec/changes/.state.yaml` as a tracker (empty initially):

```yaml
changes: []
```

**If `use_openspec: false`:**

No state tracker needed in simplified mode — changes are tracked in `.openspec-changes/` in the project root.

## Return Summary

**If `use_openspec: true`:**

```
## Spec-Driven Development Initialized

**Project**: {project name}
**Stack**: {detected stack}
**Mode**: Full OpenSpec

### Structure Created
- `openspec/config.yaml` ← Project config (stays in project)
- `openspec/specs/` ← Ready for specifications (stays in project)
- `openspec/changes/` ← Ready for changes (stays in project)
- `~/.config/opencode/project-{project-name}.yaml` ← Project config (global)
- `~/.config/opencode/conventions/{project-name}.md` ← Project conventions (global)

### Configuration
- **Type**: {solo | team}
- **OpenSpec**: Enabled
- **Issue Tracking**: {github | jira | notion | none}
- **Project**: {project key/number}

### Workflow
Full spec-driven: `/propose` → `/spec` → `/design` → `/tasks` → `/implement` → `/validate` → `/code-review` → `/archive`

### Next Steps
Ready for `/propose {change-name}|{ticket-id}`.
```

**If `use_openspec: false`:**

```
## C3PA Development Initialized

**Project**: {project name}
**Stack**: {detected stack}
**Mode**: Simplified (No OpenSpec)

### Structure Created
- `.openspec-changes/` ← Change tracking (gitignore this folder)
- `~/.config/opencode/project-{project-name}.yaml` ← Project config (global)
- `~/.config/opencode/conventions/{project-name}.md` ← Project conventions (global)

### Configuration
- **Type**: {solo | team}
- **OpenSpec**: Disabled
- **Issue Tracking**: {github | jira | notion | none}
- **Project**: {project key/number}

### Workflow
Simplified: `/propose` → `/tasks` → `/implement` → `/validate` → `/code-review`

### Next Steps
Ready for `/propose {change-name}|{ticket-id}`.
```

### Next Steps
Ready for `/propose {change-name}|{ticket-id}`.
```

## Rules

- ALWAYS detect the real tech stack, don't guess
- ALWAYS validate with the user before creating files
- If `openspec/` already exists, report what exists and ask if it should be updated
- Return a structured envelope with: `status`, `executive_summary`, `artifacts`, `next_recommended`, `risks`
