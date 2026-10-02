# Global Rules

## Skills

Use skills when relevant. Invoke manually with `ctrl+k` or `/skill-name`.

| Skill              | When to use                                                         |
| ------------------ | ------------------------------------------------------------------- |
| `tdd`              | Any implementation or bug fix, load FIRST                           |
| `grill-me`         | Stress-testing a plan, design decisions                             |
| `to-prd`           | "PRD", "spec", "product requirements"                               |
| `to-issues`        | "break into issues", "create tickets", "implementation plan"        |
| `diagnosing-bugs`  | Bug reports, "debug this", something broken/failing/slow            |
| `code-review`      | "review since X", review a branch, post-implementation review       |
| `retro`            | Session retrospective, improve agent environment                    |
| `handoff`          | Switching sessions, passing context to next agent                   |

**Gate rule:** load all applicable skills before reading any file or writing any code.

## Workflow: New Features

1. **Grill-me**: interview relentlessly about design decisions
2. **To-PRD**: synthesize into a structured PRD
3. **To-Issues**: break into vertical slices (tracer bullets)
4. **TDD**: implement each slice test-first
5. **Code-review**: review the diff against standards and spec

## Workflow: Bugs

1. **Diagnosing-bugs**: build feedback loop, reproduce, hypothesize, fix
2. **Code-review**: review the fix

## Workflow: Session End

- **Retro**: suggest improvements to the agent environment
- **Handoff**: compact context for the next session

## Git & Validation Rules

### Branch Workflow

- ALWAYS create a new branch before implementing a feature or fix
- Branch name: `feat/feature-name`, `fix/bug-name`, `refactor/description`
- Use issue number if available: `feat/123-add-auth`
- Never work directly on `main` or `master`

### Before Committing

- ALWAYS run tests before committing
- ALWAYS run linter before committing
- Fix issues before committing

### Commit Messages

- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Subject line under 72 characters
- Body if the change needs explanation

## Architecture Principles

- **Vertical slices over horizontal layers**
- **Composition over inheritance**
- **Fail fast, fail loud**

## Testing Philosophy

- Tests verify **behavior** through public interfaces, not implementation details
- Red-Green-Refactor: one test, one implementation, repeat
- **Never refactor while RED**

## Code Style

- Name things for **what they do**
- Use the project's domain language in names, tests, and interfaces
- Prefer explicit over implicit

## Communication

- Match the user's language (Catalan, Spanish, or English)
- Be concise
- Show code examples instead of explaining concepts
- When unsure, ask rather than assume

## General

- Always explore the codebase before making changes
- Respect existing conventions and patterns
- Follow project-specific AGENTS.md when it exists (this file is the fallback)
- Never commit directly to main
