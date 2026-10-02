# OpenCode Configuration

Single-agent setup with plan/build modes and skills for a full feature development workflow.

## Philosophy

- Single agent with **plan** and **build** modes
- **Skills as tools**: invoked manually with `ctrl+k` or `/skill-name`, or auto-loaded when the agent reads AGENTS.md
- **Full workflow**: grill-me -> to-prd -> to-issues -> tdd -> code-review

## Skills

| Skill | Purpose |
|-------|---------|
| `tdd` | Test-driven development with red-green loop, seams-first |
| `grill-me` | Relentless interview to stress-test a plan or design |
| `to-prd` | Synthesize conversation into a structured PRD |
| `to-issues` | Break PRD into vertical-slice tracer-bullet issues |
| `diagnosing-bugs` | Phased bug diagnosis: feedback loop first, then hypothesize |
| `code-review` | Two-axis review (Standards + Spec) with Fowler smell baseline |
| `retro` | Session retrospective to improve the agent environment |
| `handoff` | Compact context for the next session |
| `sh-open-pr` | Commit, review, push, open/update a PR (gitignored) |

## Workflows

### New Features

```
1. Grill-me      -> interview on design decisions
2. To-PRD        -> synthesize into PRD with user stories
3. To-Issues     -> break into vertical slices
4. TDD           -> implement each slice test-first
5. Code-review   -> review diff against standards and spec
```

### Bugs

```
1. Diagnosing-bugs -> build feedback loop, reproduce, hypothesize, fix
2. Code-review     -> review the fix
```

### Session End

```
- Retro   -> suggest improvements to agent environment
- Handoff -> compact context for next session
```

## Configuration

- `opencode.json`: model and MCP config
- `AGENTS.md`: global rules, skill table, workflows, conventions
- `skills/`: skill definitions (one directory per skill)

### MCPs

Context7 is enabled by default for library docs. Add others as needed in `opencode.json`.

## File Structure

```
.config/opencode/
├── opencode.json          # Model and MCP config
├── AGENTS.md              # Global rules and workflows
├── README.md              # This file
└── skills/
    ├── code-review/SKILL.md
    ├── diagnosing-bugs/SKILL.md
    ├── grill-me/SKILL.md
    ├── handoff/SKILL.md
    ├── retro/SKILL.md
    ├── sh-open-pr/SKILL.md
    ├── tdd/SKILL.md
    │   ├── tests.md
    │   └── mocking.md
    ├── to-issues/SKILL.md
    └── to-prd/SKILL.md
```
