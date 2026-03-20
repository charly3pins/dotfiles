---
description: Implement tasks from tasks.md. Supports TDD mode. Mark completed tasks [x].
---

# /implement

Delegate to the implement sub-agent.

The sub-agent will:
1. Read tasks, specs, and design
2. Implement tasks following TDD if enabled in `openspec/config.yaml`
3. Mark completed tasks [x] in `openspec/changes/{change-name}/tasks.md`
4. Report progress and any deviations
