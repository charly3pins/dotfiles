# OpenCode Configuration

Single-agent setup with plan/build modes and skills for a full feature development workflow.

## Philosophy

- Single agent with **plan** and **build** modes
- **Skills as tools**: invoked manually with `ctrl+k` or `/skill-name`, or auto-loaded when the agent reads AGENTS.md
- **Full workflow**: grill-me -> to-prd -> to-issues -> tdd -> code-review

## Skills

| Skill | Purpose |
|-------|---------|
| `tdd` | Test-driven development with red-green loop, seams-first |
| `grill-me` | Relentless interview to stress-test a plan or design |
| `to-prd` | Synthesize conversation into a structured PRD |
| `to-issues` | Break PRD into vertical-slice tracer-bullet issues |
| `diagnosing-bugs` | Phased bug diagnosis: feedback loop first, then hypothesize |
| `code-review` | Two-axis review (Standards + Spec) with Fowler smell baseline |
| `retro` | Session retrospective to improve the agent environment |
| `handoff` | Compact context for the next session |

## Workflows

### New Features

```
1. Grill-me      -> interview on design decisions
2. To-PRD        -> synthesize into PRD with user stories
3. To-Issues     -> break into vertical slices
4. TDD           -> implement each slice test-first
5. Code-review   -> review diff against standards and spec
```

### Bugs

```
1. Diagnosing-bugs -> build feedback loop, reproduce, hypothesize, fix
2. Code-review     -> review the fix
```

### Session End

```
- Retro   -> suggest improvements to agent environment
- Handoff -> compact context for next session
```

## Configuration

- `opencode.json`: model and MCP config
- `code.json` / `sword.json`: per-folder overrides, symlinked as `~/Code/opencode.json` and `~/Code/SWORD/opencode.json`. OpenCode merges every `opencode.json` from the session's folder up to `/`, so Sword projects get both and `sword.json` wins. `sword.json` also loads the work plugin, keeping its skills and MCP servers out of personal projects. If the plugin's installer links it into `plugins/` again, delete that link: everything there loads in every project.
- `cli.json`: terminal settings: theme, keybinds, session tabs, alerts
- `AGENTS.md`: global rules, skill table, workflows, conventions
- `skills/`: skill definitions (one directory per skill)
- `plugins/tab-status/`: titles each new session by what it does, the first match winning: ⬜ the workbench, 🟥 something broken, 🟨 a change waiting on a go/no-go, 🟩 writing a change, 🟦 reading or answering. Test: `node --test plugins/tab-status/index.test.ts`
- `plugins/mcp-footer/`: shows every MCP server in the prompt footer, as a dot coloured by its state like in the sidebar, so the sidebar can stay hidden. Test: `node --test plugins/mcp-footer/dots.test.ts`
- `plugins/skill-commands/`: adds a `/<name>` command for each skill in `skills/`, with the skill attached, like `/sh:<name>`. New or deleted skills need `opencode service restart`. Test: `node --test plugins/skill-commands/index.test.ts`
- `plugins/usage-footer/`: shows your Claude plan's usage in the prompt footer, `s 15% / w 16%` for the 5-hour session and the week, read from the Meridian proxy that `opencode-with-claude` runs. From 80% a limit turns yellow and says when it resets; at the limit it turns red. Test: `node --test plugins/usage-footer/usage.test.ts`
- `plugins/copilot-oauth-only/`: stops OpenCode treating `GITHUB_TOKEN` as a GitHub Copilot login, so the token you export for `gh` and npm doesn't fill `/models` with Copilot models. Signing in to Copilot with `/connect` still works. A new plugin folder needs `opencode service restart`. Test: `node --test plugins/copilot-oauth-only/index.test.ts`

### MCPs

Context7 is enabled by default for library docs. Add others as needed in `opencode.json`.

## File Structure

```
.config/opencode/
├── opencode.json          # Model and MCP config
├── cli.json               # Terminal settings
├── AGENTS.md              # Global rules and workflows
├── README.md              # This file
├── plugins/
│   ├── copilot-oauth-only/ # GITHUB_TOKEN isn't a Copilot login
│   ├── mcp-footer/        # MCP servers in the prompt footer
│   ├── skill-commands/    # A /<name> command per skill
│   ├── tab-status/        # Session titles by kind of work
│   └── usage-footer/      # Claude plan usage in the prompt footer
└── skills/
    ├── code-review/SKILL.md
    ├── diagnosing-bugs/SKILL.md
    ├── grill-me/SKILL.md
    ├── handoff/SKILL.md
    ├── retro/SKILL.md
    ├── tdd/SKILL.md
    │   ├── tests.md
    │   └── mocking.md
    ├── to-issues/SKILL.md
    └── to-prd/SKILL.md
```
