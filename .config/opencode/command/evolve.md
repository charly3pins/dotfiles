---
description: Convert high-confidence instincts into reusable skills.
---

# /evolve

Transform learned patterns (instincts) into automated skills.

## Usage

```
/evolve                    # Evolve all ready instincts
/evolve --dry-run          # Preview what would be created
```

## When to Use

- When `/instinct-status` shows "Ready to Evolve"
- When you have ≥10 high-confidence instincts
- Periodically to automate your common patterns

## What It Does

1. Selects instincts with ≥80% confidence and ≥10 evidence
2. Clusters related instincts by theme
3. Generates skills from clusters
4. Saves to `skills/generated/`
5. Updates skill registry
6. Marks instincts as "evolved"

## Example Evolution

**Before:**
- 15 instincts about preferring tests first
- Scattered across multiple files
- Confidence 85-95%

**After:**
- 1 skill: `user-tdd-preference`
- Auto-triggers before `/implement`
- Suggests: "Based on your patterns, write tests first?"

## Auto-Extraction

Evolved skills are marked as "auto-extracted" and:
- Can be edited like any skill
- Auto-trigger based on context
- Can be deleted if no longer relevant
- Show evidence summary for transparency
