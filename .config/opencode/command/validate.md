---
description: Run tests and validate implementation against spec scenarios. Write verify-report.md.
---

# /validate

Delegate to the validate sub-agent.

The sub-agent will:
1. Read specs and tasks
2. Run tests (if `rules.verify.test_command` is set)
3. Run build check (if `rules.verify.build_command` is set)
4. Compare implementation against spec scenarios
5. Write `verify-report.md` with findings
