---
name: instinct-status
description: >
  View all learned instincts with confidence scores and evidence.
  Trigger: When user says "/instinct-status".
---

## Purpose

You are a sub-agent that displays all learned instincts, their confidence levels, and evidence counts. Helps user understand what patterns the system has learned.

## What to Do

### Step 1: Read Instincts

Glob for instinct files in:
- `~/.config/opencode/instincts/*.yaml` (all instincts, some tagged with project)

### Step 2: Generate Report

```
## Instinct Status

### Global Instincts ({N} total)

**High Confidence (≥80%)**
| Pattern | Confidence | Evidence | Context |
|---------|-----------|----------|---------|
| prioritize_tests | 95% | 15 | User always asks for tests first |
| interface_over_type | 92% | 18 | Prefers interfaces for object shapes |
| atomic_commits | 89% | 12 | Likes one commit per logical change |

**Medium Confidence (50-80%)**
| Pattern | Confidence | Evidence | Context |
|---------|-----------|----------|---------|
| skip_design_phase | 75% | 6 | Often skips formal design docs |

**Low Confidence (<50%)**
| Pattern | Confidence | Evidence | Context |
|---------|-----------|----------|---------|
| prefer_classes | 40% | 4 | Inconclusive preference |

### Project-Specific Instincts ({N} total)

**High Confidence (≥80%)**
| Pattern | Confidence | Evidence | Context |
|---------|-----------|----------|---------|
| repository_pattern | 88% | 8 | Uses Repository pattern for data access |
| nextjs_api_routes | 85% | 10 | Prefers API routes over server actions |

### Ready to Evolve

{M} instincts with ≥80% confidence and ≥10 evidence ready to become skills.

Run `/evolve` to convert these instincts into reusable skills.
```

### Step 3: Provide Actions

Offer user options:
1. **Prune low-confidence** — delete instincts <50% confidence
2. **Export instincts** — share patterns with team
3. **Import instincts** — load patterns from others
4. **Evolve to skills** — convert high-confidence instincts

## Return Summary

```
## Instinct Status Report

**Total Instincts**: {N} global, {M} project-specific
**High Confidence**: {H} (≥80%)
**Ready to Evolve**: {R} (≥80% + ≥10 evidence)

### Top Patterns
1. prioritize_tests (95%, 15 evidence)
2. interface_over_type (92%, 18 evidence)
3. repository_pattern (88%, 8 evidence) — project-specific

### Recommendations
- Run `/evolve` to convert top patterns into skills
- Consider pruning low-confidence instincts (<50%)
```
