---
name: code-review
description: "Review a diff along two axes: Standards (does the code follow this repo's documented coding standards?) and Spec (does it match the originating ticket/spec?). Works on your own work since a fixed point (commit, branch, tag) or on someone else's PR by number or URL. Runs the axes in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to \"review since X\"."
---

Two-axis review of a diff:

- **Standards**: does the code conform to this repo's documented coding standards?
- **Spec**: does the code faithfully implement the originating ticket / spec?

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings. On someone else's PR a third axis, **Risk**, joins them when no current bug review exists (step 4).

## Process

### 1. Pin the target

What the user passed decides the mode:

| Input | Mode | Diff | Commits |
|---|---|---|---|
| PR number or URL (`812`, `#812`, `github.com/…/pull/812`) | **PR** | `gh pr diff <N>` | `gh pr view <N> --json commits` |
| commit, branch, tag, `main`, `HEAD~5` | **Local** | `git diff <point>...HEAD` (three-dot, against the merge-base) | `git log <point>..HEAD --oneline` |
| nothing | ask which one | | |

In PR mode also read the PR itself, without checking anything out:

```bash
gh pr view <N> --json number,title,url,author,baseRefName,headRefName,headRefOid,body,reviews,comments
```

Before going further, confirm the target resolves (`git rev-parse <point>`, or `gh pr view` succeeding) and the diff is non-empty. A bad ref or empty diff should fail here, not inside parallel sub-agents.

### 2. Identify the spec source

Look for the originating spec, in this order:

1. A path or ticket the user passed as an argument.
2. A ticket key in the PR title, branch name or commit messages (`ABC-123`, `XY-42`, any case). Look it up in your ticket tracker first, with its MCP tools (the request and its comments); not found → Jira. If the lookup fails, say which key could not be resolved.
3. GitHub issue references in the commit messages (`#123`, `Closes #45`). Fetch the issue body and comments via `gh issue view`.
4. PR mode: the PR's `## Summary`. Label it as the author's own description, not an independent spec.
5. A spec file under `docs/`, `specs/`, `thoughts/`, or `.scratch/` matching the branch name or feature.
6. If nothing is found, ask the user where the spec is. If they say there isn't one, the **Spec** sub-agent will skip and report "no spec available".

### 3. Identify the standards sources

Anything in the repo that documents how code should be written, such as `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `AGENTS.md`, or `CLAUDE.md`.

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** below: a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Like any standard here, skip anything tooling already enforces.

Each smell reads *what it is* then *how to fix*; match it against the diff:

- **Mysterious Name**: a function, variable, or type whose name doesn't reveal what it does or holds. Fix: rename it; if no honest name comes, the design's murky.
- **Duplicated Code**: the same logic shape appears in more than one hunk or file in the change. Fix: extract the shared shape, call it from both.
- **Feature Envy**: a method that reaches into another object's data more than its own. Fix: move the method onto the data it envies.
- **Data Clumps**: the same few fields or params keep travelling together (a type wanting to be born). Fix: bundle them into one type, pass that.
- **Primitive Obsession**: a primitive or string standing in for a domain concept that deserves its own type. Fix: give the concept its own small type.
- **Repeated Switches**: the same `switch`/`if`-cascade on the same type recurs across the change. Fix: replace with polymorphism, or one map both sites share.
- **Shotgun Surgery**: one logical change forces scattered edits across many files in the diff. Fix: gather what changes together into one module.
- **Divergent Change**: one file or module is edited for several unrelated reasons. Fix: split so each module changes for one reason.
- **Speculative Generality**: abstraction, parameters, or hooks added for needs the spec doesn't have. Fix: delete it; inline back until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation the caller shouldn't depend on. Fix: hide the walk behind one method on the first object.
- **Middle Man**: a class or function that mostly just delegates onward. Fix: cut it, call the real target direct.
- **Refused Bequest**: a subclass or implementer that ignores or overrides most of what it inherits. Fix: drop the inheritance, use composition.

### 3b. Existing review (PR mode only)

Look for `/sh:review-pr`'s marker in the PR body, `<!-- sh:open-pr reviewed=<sha> -->`, and compare its sha to `headRefOid`:

- **Same sha**: the bug/risk review is current. Pass its `## Code review` table to every sub-agent as already reported, so they don't repeat it.
- **Different sha**: the review is stale. Note it, and run the Risk sub-agent.
- **No marker**: `/sh:review-pr` never ran. Note it, and run the Risk sub-agent.

Pass the other reviewers' comments (`reviews`, `comments`) to the sub-agents too, for the same reason: no repeats.

### 4. Spawn the sub-agents in parallel

**Standards sub-agent prompt** should include:

- The full diff command and commit list.
- The list of standards-source files you found in step 3, **plus the smell baseline from step 3** pasted in full (the sub-agent has no other access to it).
- PR mode: the findings already reported (step 3b).
- The brief: "Report, per file/hunk where relevant, (a) every place the diff violates a documented standard: cite the standard (file + the rule); and (b) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls: documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces or already reported. Under 400 words."

**Spec sub-agent prompt** should include:

- The diff command and commit list.
- The path or fetched contents of the spec, and which source it came from.
- PR mode: the findings already reported (step 3b).
- The brief: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Skip anything already reported. Under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

**Risk sub-agent prompt**, PR mode and only when step 3b calls for it, should include:

- The diff command and commit list.
- The other reviewers' comments.
- The brief: "Report only high-confidence bugs, security issues (above all authorization against a path or query id instead of the caller's authenticated identity, an IDOR), behavioural regressions, data-loss risks, concurrency problems, API-contract breaks, and missing tests for changed behaviour. Read the changed files, the surrounding code and the call sites before asserting a break; no style nits, no speculation. Give the evidence for each finding. Under 400 words."

### 5. Aggregate

Present findings in this table format. Only issues; skip praise and "looks good" notes:

| File | Line | Finding | Axis |
|---|---|---|---|
| `path/to/file.ts` | 42 | Description of the issue | Standards |
| `path/to/file.ts` | 78 | Description of the issue | Spec |
| `path/to/file.ts` | 91 | Description of the issue | Risk |

Below the table, a one-line summary: total findings per axis, and the worst issue within each axis (if any). Don't pick a single winner across axes: that's the reranking the separation exists to prevent.

PR mode adds one line on the existing review: "`/sh:review-pr` current at `abc1234`, its 3 findings not repeated", "stale: reviewed `abc1234`, head is `def5678`", or "never run".

### 6. Draft review comments (PR mode only)

Offer once to turn the findings into a draft review: one comment per finding on its `path:line`, worded to post as is, Spec findings quoting the ticket line. On a yes, write `/tmp/code-review-<N>.json` for `gh api repos/{owner}/{repo}/pulls/<N>/reviews --input /tmp/code-review-<N>.json` with `event: COMMENT`, print the exact command, and **post only on a second yes**. Never approve or request changes.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing: **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions: **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other. Risk is a third, separate axis, and it runs only when `/sh:review-pr` has not already covered the PR's head.
