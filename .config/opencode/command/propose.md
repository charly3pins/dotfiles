---
description: Create a change proposal. Optionally reads external tickets (GitHub Issues, Jira, Notion) if an ID is provided (e.g., /propose PROJECT-123).
---

# /propose [{ticket-id}]

Delegate to the propose sub-agent.

The sub-agent will:
1. If ticket ID provided, attempt to read from GitHub Issues, Jira, or Notion
2. Ask targeted questions to understand the change
3. Explore scope boundaries through iterative questioning
4. Create `openspec/changes/{change-name}/proposal.md`
5. Create `openspec/changes/{change-name}/state.yaml`

Examples:
- `/propose add-user-notifications` — start from scratch
- `/propose PROJ-123` — read from Jira
- `/propose #456` — read from GitHub Issues
