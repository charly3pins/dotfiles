# Global Rules

## Workflow — New Features

For any new feature or significant change, follow this flow:

1. **Grill-me** — Interview the user relentlessly about every design decision until reaching shared understanding
2. **To-PRD** — Synthesize the conversation into a structured PRD with problem, solution, user stories, and decisions
3. **To-Issues** — Break the PRD into vertical slices (tracer bullets), each delivering end-to-end value
4. **TDD** — Implement each slice test-first with Red-Green-Refactor

## Git & Validation Rules

### Branch Workflow

- **ALWAYS create a new branch** before implementing a feature or fix
- Branch name should be descriptive: `feat/feature-name`, `fix/bug-name`, or `refactor/description`
- Use the issue number if available: `feat/123-add-auth`
- Never work directly on `main` or `master`

### Before Committing

- **ALWAYS run tests** before committing — ensure they pass
- **ALWAYS run linter** before committing — fix any lint errors
- If the project has a pre-commit hook, respect it
- If tests or lint fail, fix the issues before committing

### Commit Messages

- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Keep the subject line under 72 characters
- Add a body if the change needs explanation

## Architecture Principles

- **Vertical slices over horizontal layers** — Each slice cuts through schema → API → UI → tests, not "db layer", "service layer", "controller layer"
- **Deep modules** — Small interface, deep implementation. Encapsulate complexity behind simple, testable APIs
- **Composition over inheritance** — Prefer composition, avoid deep class hierarchies
- **Fail fast, fail loud** — Validate early, throw descriptive errors

## Testing Philosophy

- Tests verify **behavior** through public interfaces, not implementation details
- A good test reads like a specification: "user can checkout with valid cart"
- Bad tests break on refactor when behavior hasn't changed — those test implementation, not behavior
- Red-Green-Refactor: one test → minimal code → refactor → repeat
- **Never refactor while RED** — get to GREEN first

## Code Style

- Name things for **what they do**, not how they do it
- Use the project's domain language (glossary vocabulary) in names, tests, and interfaces
- Prefer explicit over implicit
- Keep functions focused — if it needs a comment to explain, it's probably doing too much

## Communication

- Match the user's language (Catalan, Spanish, or English)
- Be concise — no essays, no filler
- Show code examples instead of explaining concepts
- When unsure, ask rather than assume

## General

- Always explore the codebase before making changes
- Respect existing conventions and patterns
- Follow project-specific AGENTS.md when it exists (this file is the fallback)
- Use skills when relevant — don't reinvent what skills already define
- **Never commit directly to main** — always work on a feature branch
