---
description: Migrate a project from thoughts/ folder to openspec/ framework. Run once per project.
---

# /migrate

Migrate a project's `thoughts/` folder to the `openspec/` structure.

## What it does

1. Detect existing `thoughts/` folder in current project
2. Audit contents (tickets, plans, research, reviews)
3. Ask migration strategy (active only / everything / archive old)
4. Convert files to openspec structure
5. Archive original `thoughts/` folder

## Migration Map

```
thoughts/tickets/*.md  → openspec/changes/{name}/proposal.md
thoughts/plans/*.md    → openspec/changes/{name}/tasks.md
thoughts/research/*.md  → .sda/research/{name}/ (or absorbed into proposal)
thoughts/reviews/*.md  → openspec/changes/{name}/verify-report.md
```

## If no thoughts/ folder exists

Report: "No thoughts/ folder found. Nothing to migrate."
