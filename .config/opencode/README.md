# Spec-Driven Development Guide

A structured workflow for building features with less context bloat, powered by OpenSpec.

---

## How It Works

The orchestrator delegates heavy work (planning, implementation) to sub-agents with fresh context. The main thread stays clean.

**Ad-hoc questions**: answered directly  
**Structured work**: use commands below

---

## Commands

| Command                 | What it does                                           |
| ----------------------- | ------------------------------------------------------ |
| `/bootstrap`            | Init project — detect stack, create `openspec/`        |
| `/propose {ticket-id?}` | Read external ticket (optional) → create `proposal.md` |
| `/spec`                 | Write Given/When/Then specs                            |
| `/design`               | Write architecture decisions                           |
| `/tasks`                | Create implementation checklist                        |
| `/implement`            | Implement tasks (TDD if enabled)                       |
| `/validate`             | Run tests, validate against specs                      |
| `/code-review`          | Human code review                                      |
| `/fix`                  | Fix issues from validate or code-review (no proposal needed) |
| `/archive`              | Close change, merge specs to `openspec/specs/`         |
| `/skill-registry`       | Update skill registry                                  |

---

## Workflows

### Solo Dev (Simple Changes)

```
/propose → /tasks → /implement → /validate → /code-review → /archive
```

### Full Spec-Driven (Complex / Team)

```
/bootstrap → /propose → /spec → /design → /tasks → /implement → /validate → /code-review → /archive
```

> **Note**: `/spec` and `/design` are always available — use them when complexity warrants it, even in solo projects.

---

## Discipline Skills

Skills are loaded automatically when relevant:

| Trigger                 | Skill                     | Purpose                                  |
| ----------------------- | ------------------------- | ---------------------------------------- |
| testing, tdd            | `test-driven-development` | RED → GREEN → REFACTOR                   |
| debugging, bug          | `systematic-debugging`    | Root cause before fixes                  |
| ideas, design           | `brainstorming`           | Collaborative exploration                |
| frontend, ui, component | `frontend-design`         | Distinctive, production-grade interfaces |

---

## OpenSpec Structure

```
openspec/
├── config.yaml              ← project config
├── specs/                   ← living documentation
└── changes/                 ← active changes
    └── archive/             ← completed changes
```

Each change creates:

```
openspec/changes/{name}/
├── proposal.md
├── specs/{domain}/spec.md
├── design.md
├── tasks.md
└── verify-report.md
```

---

## Project Config

During `/bootstrap`, project config is saved to `.sda/project.yaml`:

```yaml
project_type: solo  # solo | team
issue_tracker:
  type: github  # github | jira | notion | none
  project: "123"  # GitHub project number, Jira project key, Notion database ID
```

- `project_type` tells skills whether to skip optional phases (solo skips `/spec`, `/design`, `/code-review`)
- `issue_tracker` tells `/implement` how to move issues through stages (GitHub → In Progress, Jira → IN PROGRESS, etc.)

---

## Project Conventions

During `/bootstrap`, project conventions are detected and saved to `.sda/conventions.md`:

- `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, etc.
- Branch creation, commit conventions, PR workflow

Sub-agents read these conventions before executing. Your existing project workflow is preserved.

---

## TDD Mode

Enable in `openspec/config.yaml`:

```yaml
rules:
  apply:
    tdd: true
    test_command: "npm test"
```
