# OpenCode Configuration

Agent-based setup for OpenCode with a full feature development workflow: grill → PRD → issues → TDD implementation.

## Philosophy

- **Lead** routes everything - never implements
- **5 specialist agents** for specific tasks
- **Skills as tools** - auto-invoked when keywords match, or invoked manually with `ctrl+k` or `/skill-name`
- **Full workflow**: grill-me → to-prd → to-issues → tdd
- **No commands** - just talk to Lead naturally

## Agents

| Agent | Purpose |
|-------|---------|
| **Lead** | Routes all requests, maintains context, runs PRD/issue skills directly |
| **Scout** | Fast codebase exploration |
| **Architect** | Design debates, asks questions, creates proposals |
| **Researcher** | Doc/API lookups |
| **Builder** | Implementation, fixes, validation (TDD-first) |
| **Code Reviewer** | Code reviews, quality checks |

**Models**: Use whatever you want. Copilot, Zen, Anthropic proxy - just set it with `/models` and the agents will use it.

## Full Feature Workflow

The recommended flow for building new features from scratch:

```
1. Grill-Me (Architect)
   "Grill me on adding auth to the API"
   → Relentless interview to resolve every design decision
   → Shared understanding of what to build

2. To-PRD (Lead)
   "Create a PRD from our discussion"
   → Synthesizes conversation into a structured PRD
   → Problem, solution, user stories, implementation decisions, testing decisions

3. To-Issues (Lead)
   "Break the PRD into issues"
   → Splits PRD into vertical slices (tracer bullets)
   → Each slice is end-to-end: schema → API → UI → tests
   → NOT horizontal layers (not "db layer", "service layer", "controller layer")
   → Each slice is independently demoable and deployable

4. TDD (Builder)
   "Implement issue #1"
   → Red-Green-Refactor loop
   → One test → minimal code → refactor → repeat
   → Tests verify behavior through public interfaces, not implementation details
```

```
User: "I want to add a payment system"
  ↓
Lead → Architect (grill-me): Interview on payment approach (Stripe vs Paddle, webhooks, etc.)
  ↓
Lead (to-prd): Synthesize into PRD with user stories and decisions
  ↓
Lead (to-issues): Break PRD into vertical slices:
  - #1: Basic checkout flow (schema → API → UI → tests)
  - #2: Webhook handling (schema → API → tests)
  - #3: Payment history page (schema → API → UI → tests)
  ↓
User: "Implement #1"
Lead → Builder (tdd): Test-first implementation
  ↓
Lead: "Done. Checkout flow implemented with full test coverage."
```

Lead automatically chains agents when needed. You never think about it.

## Skills

Skills are auto-invoked when keywords match, or invoked manually with `ctrl+k` or `/skill-name`.

### Lead Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| to-prd | "PRD", "product requirements", "spec" | Turn conversation into a PRD |
| to-issues | "break into issues", "create tickets" | Break plan into vertical-slice issues |

### Architect Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| grill-me | "grill me", "stress-test" | Relentless design interview |
| frontend-design | "component", "page", "UI" | UI/UX design guidance |

### Builder Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| tdd | "TDD", "red-green-refactor", "test-first" | Test-driven development (ALWAYS used) |
| database-reviewer | "SQL", "migration", "schema" | PostgreSQL validation |
| typescript-reviewer | `.ts` files | Type checking |
| security-review | "auth", "input", "sanitize" | Security scan |
| frontend-design | "component", "UI" | UI/UX guidance |

### Code Reviewer Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| database-reviewer | SQL, migration, schema | DB validation |
| typescript-reviewer | `.ts` files, type, interface | Type checking |
| security-review | auth, input, sanitize | Security scan |

## Usage

### Simple Requests (Lead handles directly)
```
"What's the weather?"
"Explain this error"
"How do I do X?"
```

### Codebase Questions (Scout)
```
"How is this project structured?"
"Find where auth is handled"
"What patterns does this codebase use?"
```

### Design Decisions (Architect)
```
"Should I use JWT or sessions?"
"What's the best way to handle retries?"
"Help me design the payment flow"
```

### Stress-Test a Plan (Architect + grill-me)
```
"Grill me on this architecture"
"Stress-test my plan for X"
```

### Create a PRD (Lead + to-prd)
```
"Create a PRD from our discussion"
"Write up the requirements"
```

### Break into Issues (Lead + to-issues)
```
"Break the PRD into implementation issues"
"Create tickets for this plan"
```

### Research (Researcher)
```
"Look up the best practices for X"
"How does the Y API work?"
"Find examples of Z pattern"
```

### Implementation (Builder + tdd)
```
"Implement issue #1"
"Add user authentication"
"Fix the bug where..."
"Build a login page"
```

### Complex Flows (Auto-chained)
```
"I want to add auth to the API"
  → Grill-me → to-prd → to-issues → Builder (TDD)

"Fix this bug where users can't login"
  → Scout finds it → Builder fixes it (TDD)

"How should I structure the database?"
  → Architect debates → Researcher looks up patterns
```

## Instincts

Lead learns your patterns over time and stores them in:

```
~/.local/share/opencode/instincts/
```

These are **personal patterns** - "User always asks for tests first", "User prefers interfaces over types", etc.

- Auto-extracted silently (confidence > 85%)
- Used to personalize suggestions
- Sync via private dotfiles repo (separate from this public one)
- Can delete anytime to reset

## Configuration

### Model Tiers

Each agent uses a model tier based on its responsibility. The `model_tier` parameter is passed when Lead delegates via the Task tool.

| Agent | Tier | Purpose | Why This Tier |
|-------|------|---------|---------------|
| **Lead** | Main model | Routing, context management | Uses whatever you set with `/models` |
| **Scout** | `fast` | Quick exploration | Cheap for lots of file reading, no complex reasoning |
| **Architect** | `powerful` | Complex design | Best reasoning for trade-offs and architecture |
| **Researcher** | `balanced` | Doc synthesis | Good reasoning for API lookups and best practices |
| **Builder** | `balanced` | Implementation | Cost-effective for coding and skill coordination |

### How Tier Mapping Works

**OpenCode** handles the mapping automatically. You just set your main model with `/models`, and OpenCode knows which models to use for each tier based on your provider.

**The flow:**
1. You run `/models` and pick your main model (what Lead uses)
2. Lead spawns subagents via `task` tool with `model_tier: "fast"`, `"balanced"`, or `"powerful"`
3. OpenCode automatically maps those tiers to appropriate models for your provider

**Example with Copilot**:
```
/models
→ Select: github-copilot/claude-sonnet-4  (Lead uses this)
→ OpenCode automatically sets:
  - fast tier → github-copilot/gpt-5-mini      (Scout)
  - balanced tier → github-copilot/claude-sonnet-4  (Researcher/Builder)
  - powerful tier → github-copilot/claude-opus-4    (Architect)
```

**Example with Zen**:
```
/models
→ Select: anthropic/claude-sonnet-4
→ OpenCode automatically sets:
  - fast tier → openai/gpt-4.1-mini or anthropic/claude-3.5-haiku
  - balanced tier → anthropic/claude-sonnet-4
  - powerful tier → anthropic/claude-opus-4
```

**You don't configure the mapping** - OpenCode knows the right cheap/expensive models for each provider.

**Cost optimization**: Scout (`fast` tier) is ~10x cheaper than Architect (`powerful` tier). You only pay for expensive models when actually needed (complex design work).

### MCPs

Context7 is enabled by default for library docs. Add others as needed:

```json
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "enabled": true
    }
  }
}
```

## File Structure

```
.config/opencode/
├── opencode.json          # Agent definitions
├── tui.json               # Keybinds
├── README.md              # This file
└── skills/                # 8 skill definitions
    ├── database-reviewer/SKILL.md
    ├── frontend-design/SKILL.md
    ├── grill-me/SKILL.md
    ├── security-review/SKILL.md
    ├── tdd/SKILL.md
    ├── to-issues/SKILL.md
    ├── to-prd/SKILL.md
    └── typescript-reviewer/SKILL.md
```

**No more:**
- `command/` folder (deleted)
- `instincts/` folder (moved to `~/.local/share/`)
- File generation (`openspec/`, `changes/`, etc.)
- Complex workflows (`/bootstrap`, `/archive`, `/learn`, etc.)

## Key Rules

### Lead NEVER:
- Writes code
- Edits files
- Runs git commands
- Makes decisions you should make

### Lead ALWAYS:
- Analyzes your intent
- Routes to right agent
- Passes context between agents
- Asks when unclear

## Examples

### Exploring a New Codebase
```
User: What is this project?
Lead: Let me explore for you.
  → Scout: Explore codebase structure
Lead: This is a Go API with PostgreSQL. It uses:
  - Chi router
  - SQLC for queries
  - Docker for dev
```

### Full Feature Flow (Grill → PRD → Issues → TDD)
```
User: I want to add a payment system
Lead: Let me grill you on the approach first.
  → Architect (grill-me): Interview on Stripe vs Paddle, webhooks, etc.

User: OK, now create a PRD
Lead: Synthesizing our discussion...
  → Lead (to-prd): PRD created with user stories and decisions

User: Break it into issues
Lead: Splitting into vertical slices...
  → Lead (to-issues): 3 issues created, each end-to-end

User: Implement #1
Lead: Building with TDD...
  → Builder (tdd): Red-Green-Refactor loop
     - Auto-calls typescript-reviewer (.ts files)
     - Auto-calls security-review (payment handling)
Lead: Done. Checkout flow implemented with full test coverage.
```

### Making a Change
```
User: Add rate limiting to the API
Lead: I'll explore the current setup first.
  → Scout: Find API structure
Lead: Now I'll design the approach.
  → Architect: Ask about strategy (token bucket vs fixed window)
User: Token bucket
Lead: Now implementing.
  → Builder: Add rate limiting middleware
     - Auto-calls typescript-reviewer (it's .ts)
Lead: Done. Rate limiting added to all endpoints.
```

### Getting Help
```
User: What's the best way to handle OAuth?
Lead: Let me research current best practices.
  → Researcher: Look up OAuth 2.1, PKCE
Lead: Here are the recommended patterns for 2024...
  → Architect: Discuss trade-offs for your use case
```

## Migration from Old C3PA

If you used the old C3PA setup:

1. **Instincts moved** from `.config/opencode/instincts/` to `~/.local/share/opencode/instincts/`
2. **No more commands** - just talk naturally
3. **No file generation** - no `openspec/`, no proposals
4. **Agents reduced** from 24+ to 5
5. **Workflow simplified** - no `/bootstrap`, `/archive`, `/learn`

Your instincts are preserved in the local share directory.

## Private Instincts Repo

To sync instincts across machines:

```bash
# Create private repo for instincts
cd ~/.local/share/opencode/instincts
git init
git remote add origin git@github.com:yourusername/opencode-instincts-private.git
git add .
git commit -m "Initial instincts"
git push -u origin main
```

Then on new machines:
```bash
git clone git@github.com:yourusername/opencode-instincts-private.git ~/.local/share/opencode/instincts
```

## Tips

1. **Be specific** - Lead routes better with clear intent
2. **Let it chain** - Don't micro-manage the agent flow
3. **Correct it** - If Lead routes wrong, just say "actually, just explore" or "skip to implementation"
4. **Trust Builder** - It auto-invokes skills when needed (ALWAYS uses TDD)
5. **Iterate** - "Almost, but fix X" works perfectly
6. **Use the full flow** - For new features: grill → PRD → issues → TDD
7. **Manual skills** - Press `ctrl+k` or type `/skill-name` to invoke any skill directly

---

**Simple. Delegated. Effective.**
