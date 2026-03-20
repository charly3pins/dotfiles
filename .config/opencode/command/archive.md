---
description: Close a completed change. Sync delta specs to openspec/specs/ and move the change folder to archive.
---

# /archive

Delegate to the archive sub-agent.

The sub-agent will:
1. Sync delta specs into `openspec/specs/`
2. Move the change folder to `openspec/changes/archive/{YYYY-MM-DD}-{change-name}/`
3. Complete the Spec-Driven cycle
