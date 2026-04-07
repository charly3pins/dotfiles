---
description: Initialize C3PA context in a project. Choose between OpenSpec (formal specs) or simplified mode.
---

# /bootstrap

Delegate to the bootstrap sub-agent.

The sub-agent will:
1. Detect the project tech stack automatically
2. Present findings to you for validation
3. Ask you to choose:
   - **OpenSpec mode**: Full spec-driven with Given/When/Then specs
   - **Simplified mode**: Lightweight workflow without formal specs
4. Create the appropriate directory structure
5. Build the skill registry
