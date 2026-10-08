---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save it inside the current repository, in `docs/handoff/` (create the directory if it does not exist), named `handoff-YYYY-MM-DD.md` with today's date (add a short suffix if one already exists for today). Never save it to `/tmp` or any temporary directory: the next session only sees the repository. At the end, tell the user the repo-relative path so they can point the next session at it.

Include a "suggested skills" section in the document, naming which skills the next agent should call the Skill tool for.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
