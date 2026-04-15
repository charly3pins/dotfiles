---
name: evolve
description: >
  Convert high-confidence instincts into reusable skills.
  Trigger: When user says "/evolve" or when ≥10 instincts ready.
---

## Purpose

You are a sub-agent that converts **instincts** (learned patterns) into **skills** (reusable instructions). This is the "evolution" step in continuous learning.

## When to Evolve

Trigger evolve when:
- User runs `/evolve` manually
- ≥10 instincts with ≥80% confidence exist
- User confirms after `/instinct-status` suggestion

## What to Do

### Step 1: Select Instincts to Evolve

Filter instincts:
- Confidence ≥80%
- Evidence count ≥10
- Last updated within 90 days (active patterns only)

### Step 2: Cluster Related Instincts

Group instincts by theme:

**Example cluster:**
```
Theme: "Testing Preferences"
- prioritize_tests (95%, 15 evidence)
- tdd_workflow (85%, 12 evidence)
- test_coverage_high (82%, 11 evidence)
```

### Step 3: Generate Skill

Create new skill from cluster:

```markdown
---
name: user-testing-preference
description: >
  Auto-extracted: User consistently prioritizes test coverage.
  Confidence: 90% (38 total evidence)
  Source: /evolve on 2026-01-20
---

## Pattern

User prefers TDD approach:
1. Ask for tests before implementation
2. Request edge case coverage
3. Verify test coverage before marking complete

## Auto-Application

When `/implement` starts:
- Suggest: "Based on your patterns, shall I write tests first?"
- Generate test file structure before implementation

## Evidence

- 15x: User asked for tests first (auth-feature, payment-gateway, ...)
- 12x: User requested edge case tests
- 11x: User verified coverage metrics
```

### Step 4: Save Skill

Save to `~/.config/opencode/skills/generated/{skill-name}/SKILL.md`

### Step 5: Mark Instincts as Evolved

Update instinct files:
```yaml
evolved: true
evolved_to: user-testing-preference
evolved_date: 2026-01-20
```

## Return Summary

```
## Evolution Complete

### Skills Created: {N}

1. **user-testing-preference** (auto-extracted)
   - Confidence: 90% (38 evidence)
   - Triggers: Before /implement
   - Action: Suggests TDD approach

2. **user-interface-preference** (auto-extracted)
   - Confidence: 88% (24 evidence)
   - Triggers: During /code-review
   - Action: Prefers interfaces over types

### Instincts Evolved: {M}
- 15 instincts marked as evolved
- Will no longer appear in /instinct-status

### Next Steps

New skills are immediately available:
- Skills auto-trigger based on context
- Edit skills in `~/.config/opencode/skills/generated/`
```

## Rules

- **Only high-confidence instincts** — ≥80% confidence, ≥10 evidence
- **Cluster by theme** — combine related instincts into one skill
- **Preserve evidence** — include evidence summary in skill
- **Mark as auto-extracted** — distinguish from manual skills
- **Allow editing** — user can refine generated skills
