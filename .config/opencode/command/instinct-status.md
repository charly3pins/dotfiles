---
description: View all learned instincts with confidence scores and evidence.
---

# /instinct-status

Display learned patterns and their confidence levels.

## Usage

```
/instinct-status              # Show all instincts
/instinct-status --global     # Show only global instincts
/instinct-status --project    # Show only project-specific instincts
```

## Output

Shows:
- Pattern name
- Confidence percentage
- Number of evidence
- Context (what the pattern means)

## Categories

**High Confidence (≥80%)** — Reliable patterns, used for auto-suggestions
**Medium Confidence (50-80%)** — Emerging patterns, shown as hints
**Low Confidence (<50%)** — Weak patterns, may be pruned

## Evolution

When ≥10 instincts reach 80%+ confidence, you'll see:
```
💡 Ready to Evolve: Run `/evolve` to convert these into skills!
```
