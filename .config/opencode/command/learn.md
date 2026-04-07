---
description: Extract patterns from completed changes and save as instincts for continuous learning.
---

# /learn

Learn from completed changes to personalize future interactions.

## Usage

```
/learn                    # Learn from last archived change
/learn {change-name}      # Learn from specific change
```

## When to Use

- **Automatic**: Runs after `/archive` completes
- **Manual**: When you want to force learning from a specific change
- **Periodic**: Run occasionally to batch process insights

## What It Does

1. Analyzes the change (proposal → implementation)
2. Extracts patterns in your workflow
3. Saves as "instincts" (reusable patterns)
4. Builds confidence score over time

## Instincts

Instincts are saved in two places:
- **Global**: `~/.c3pa/instincts/` — patterns that apply to all your projects
- **Project**: `.c3pa/instincts/` — patterns specific to this codebase

## Examples of Patterns Learned

- "Always asks for tests first" → suggests TDD automatically
- "Prefers interfaces over types" → generates interfaces by default
- "Skips /design phase" → proposes going straight to tasks

## Evolution

When ≥10 instincts reach 80%+ confidence, run `/evolve` to convert them into reusable skills.
