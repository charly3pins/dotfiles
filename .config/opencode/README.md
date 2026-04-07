# C3PA: Charly3Pins Agent

A structured, personalized workflow for building features with less context bloat. Supports both full Spec-Driven Development (OpenSpec) and simplified modes.

---

## How It Works

The orchestrator delegates heavy work (planning, implementation) to sub-agents with fresh context. The main thread stays clean.

**Ad-hoc questions**: answered directly  
**Structured work**: use commands below

---

## Commands

### Core Flow
| Command                 | What it does                                           |
| ----------------------- | ------------------------------------------------------ |
| `/bootstrap`            | Init project — detect stack, choose OpenSpec or not  |
| `/propose {ticket-id?}` | Read external ticket (optional) → create `proposal.md` |
| `/spec`                 | Write Given/When/Then specs (OpenSpec mode only)      |
| `/design`               | Write architecture decisions (optional)                |
| `/tasks`                | Create implementation checklist                        |
| `/implement`            | Implement tasks with iterative retrieval               |
| `/validate`             | Run tests, validate against specs                      |
| `/security-review`      | Check for vulnerabilities (SQL injection, XSS, etc.)   |
| `/code-review`          | Human code review + TypeScript checks                |
| `/build-fix`            | Fix build/compilation errors automatically           |
| `/fix`                  | Fix general issues from validate/code-review           |
| `/archive`              | Close change, merge specs, trigger learning            |

### Learning & Personalization
| Command                 | What it does                                           |
| ----------------------- | ------------------------------------------------------ |
| `/learn {change-name?}` | Extract patterns from completed changes                |
| `/instinct-status`      | View learned patterns with confidence scores           |
| `/evolve`               | Convert patterns (≥80% confidence) into skills         |
| `/skill-registry`       | Update skill registry                                  |
| `/typescript-review`    | Deep TypeScript type analysis                          |

---

## Workflows

### Mode 1: Full OpenSpec (Formal Specs)

For complex projects requiring formal specifications and audit trail.

```
/bootstrap → /propose → /spec → /design → /tasks → /implement → /validate → 
/security-review → /code-review → /fix or /build-fix → /archive → [/learn auto]
```

**Creates:**
- `openspec/` directory with specs, changes, archive
- `.c3pa/` with config, conventions, skill-registry
- Formal Given/When/Then specifications

### Mode 2: Simplified (No OpenSpec)

For smaller projects or when formal specs aren't needed.

```
/bootstrap → /propose → /tasks → /implement → /validate → 
/security-review → /code-review → /fix → [/learn manual]
```

**Creates:**
- `.c3pa/` only (no `openspec/`)
- Changes tracked in `.c3pa/changes/`
- No formal specs, but still structured

### Solo vs Team

Both modes support **Solo** and **Team** configurations:

**Solo:**
- Skips optional phases (`/spec`, `/design`)
- Faster iteration
- Manual code review (self-review)

**Team:**
- Full workflow with formal specs
- Required code review before merge
- PR-based workflow

> **Note**: During `/bootstrap`, you'll choose:
> 1. **Solo or Team?** → Workflow complexity
> 2. **OpenSpec or Simplified?** → Formal specs yes/no
> 3. **Issue tracker?** → GitHub/Jira/Notion/None

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

During `/bootstrap`, project config is saved to `.c3pa/project.yaml`:

```yaml
project_type: solo  # solo | team
use_openspec: true  # true | false
issue_tracker:
  type: github  # github | jira | notion | none
  project: "123"  # GitHub project number, Jira project key, Notion database ID
```

- `project_type` tells skills whether to skip optional phases (solo skips `/spec`, `/design`, `/code-review`)
- `use_openspec` enables/disables the formal OpenSpec workflow with Given/When/Then specs
- `issue_tracker` tells `/implement` how to move issues through stages (GitHub → In Progress, Jira → IN PROGRESS, etc.)

---

## Project Conventions

During `/bootstrap`, project conventions are detected and saved to `.c3pa/conventions.md`:

- `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, etc.
- Branch creation, commit conventions, PR workflow

Sub-agents read these conventions before executing. Your existing project workflow is preserved.

---

## Continuous Learning

C3PA learns from your patterns and evolves with you.

### How It Works

**1. Pattern Extraction (`/learn`)**
- After each archived change, the system analyzes your decisions
- Extracts patterns: "User always asks for tests first", "User prefers interfaces over types"
- Saves as "instincts" with confidence scores

**2. Instinct Accumulation**
- Global instincts (apply to all projects): `~/.c3pa/instincts/`
- Project instincts (specific to this codebase): `.c3pa/instincts/`
- View with `/instinct-status`

**3. Evolution (`/evolve`)**
When ≥10 instincts reach 80%+ confidence:
- Run `/evolve` to convert patterns into reusable skills
- Generated skills: `~/.config/opencode/skills/generated/`
- Auto-trigger based on context

### Example

After 15 changes where you consistently:
1. Asked for tests before implementation
2. Requested edge case coverage
3. Verified test metrics

**Evolution creates:**
```yaml
name: user-testing-preference
triggers: Before /implement
action: Suggest "Based on your patterns, write tests first?"
confidence: 95% (38 evidence)
```

### Commands

| Command | Purpose |
|---------|---------|
| `/instinct-status` | View all patterns with confidence scores |
| `/evolve` | Convert high-confidence patterns (≥80%) to skills |
| `/learn {change-name?}` | Manual pattern extraction |

---

## Configuration

### Project Config (`.c3pa/project.yaml`)

```yaml
project_type: solo  # solo | team
use_openspec: true  # true | false
issue_tracker:
  type: github  # github | jira | notion | none
  project: "123"  # GitHub project number, Jira project key, Notion database ID
```

### Learning Config (`~/.c3pa/config.yaml`)

```yaml
learn:
  auto_after_archive: true
  auto_suggest_evolve_threshold: 10
  require_manual_approval: true

evolve:
  min_confidence: 80
  min_evidence: 5

auto_fix:
  mode: "smart"  # always_fix simple, ask_before_fix complex, never_fix_auto breaking

security:
  level: "standard"  # basic | standard | strict

typescript:
  strict: true
  target: "ES2022"
```

---

## TDD Mode

Enable in `openspec/config.yaml` or `.c3pa/config.yaml`:

```yaml
rules:
  apply:
    tdd: true
    test_command: "npm test"
```

---

## Next Steps

1. **Bootstrap a project**: `/bootstrap` — choose your mode (OpenSpec or Simplified)
2. **Make a change**: `/propose → /tasks → /implement → /validate → /archive`
3. **Check what you learned**: `/instinct-status`
4. **Evolve when ready**: `/evolve` (when ≥10 high-confidence instincts)

**Happy coding! 🚀**
