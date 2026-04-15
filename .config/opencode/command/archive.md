---
description: Close a completed change. Sync specs (OpenSpec mode only) and archive the change.
---

# /archive

Delegate to the archive sub-agent.

The sub-agent will:
1. Verify PR is merged
2. Sync delta specs to `openspec/specs/` (OpenSpec mode only; skipped in Simplified mode)
3. Move the change folder to archive
4. Trigger learning (auto in OpenSpec mode, manual in Simplified mode)

**OpenSpec mode**: `openspec/changes/archive/{YYYY-MM-DD}-{change-name}/`
**Simplified mode**: `.openspec-changes/archive/{YYYY-MM-DD}-{change-name}/`
