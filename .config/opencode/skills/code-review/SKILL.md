---
name: code-review
description: "Review someone else's PR (one or several, across repos) along two axes: Spec (does it match the originating ticket?) and Risk (bugs, security, regressions). Also reviews the user's own local work since a fixed point (commit, branch, tag). Runs the axes in parallel sub-agents and reports one compact table with a ready-to-post PR comment per finding. Use when the user wants to review a PR, a branch, or asks to \"review since X\"."
---

Two-axis review of a diff:

- **Spec**: does the code faithfully implement the originating ticket / spec?
- **Risk**: bugs, security issues, regressions, contract breaks.

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings into one table.

## Whose code this is

- **PR mode = someone else's PR.** Always. The user is the reviewer, not the author. Never treat it as self-review: don't check out, edit, fix, commit or push anything. Every finding needs a comment the user can post to the author.
- **Local mode = the user's own work**, only when they pass a local ref (`main`, `HEAD~5`, a branch) or say "since X". There the last column is a short fix instead of a PR comment.

## Process

### 1. Pin the targets

| Input | Mode | Diff | Commits |
|---|---|---|---|
| one or more PR numbers or URLs (`812`, `#812`, `github.com/org/repo/pull/812`) | **PR** | `gh pr diff <N> --repo <owner/repo>` | `gh pr view <N> --repo <owner/repo> --json commits` |
| commit, branch, tag, `main`, `HEAD~5` | **Local** | `git diff <point>...HEAD` (three-dot, against the merge-base) | `git log <point>..HEAD --oneline` |
| nothing | ask which one | | |

A bare number means the current repo; a URL carries its own `owner/repo`. Several PRs (e.g. a BE service and Android/iOS for one feature) are reviewed in the same run, one set of sub-agents per PR, all in parallel.

In PR mode also read each PR itself, without checking anything out:

```bash
gh pr view <N> --repo <owner/repo> --json number,title,url,author,baseRefName,headRefName,headRefOid,body,reviews,comments
```

Confirm every target resolves and its diff is non-empty before spawning anything. A bad ref or empty diff fails here.

### 2. Identify the spec source

Look for the originating spec, in this order:

1. A path or ticket the user passed as an argument.
2. A ticket key in the PR title, branch name or commit messages (`ABC-123`, `XY-42`, any case). Look it up with the MCP tools of whichever ticket tracker is connected (the ticket and its comments). If the lookup fails, say which key could not be resolved.
3. GitHub issue references in the commit messages (`#123`, `Closes #45`), via `gh issue view`.
4. PR mode: the PR's `## Summary`. Label it as the author's own description, not an independent spec.
5. A spec file under `docs/`, `specs/`, `thoughts/`, or `.scratch/` matching the branch name or feature.
6. If nothing is found, ask once. If there isn't one, skip the Spec sub-agent.

Several PRs for the same ticket share one spec lookup.

### 3. Existing review (PR mode only)

Some projects run a bug/risk review before merge that leaves a marker in the PR body, `<!-- <name> reviewed=<sha> -->` (for example `<!-- sh:open-pr reviewed=<sha> -->`). Compare its sha to `headRefOid`:

- **Same sha**: the risk review is current. Skip the Risk sub-agent and pass its `## Code review` table to the Spec sub-agent as already reported.
- **Different sha** or **no marker**: run the Risk sub-agent.

Pass the other reviewers' comments (`reviews`, `comments`) to the sub-agents so they don't repeat them.

### 4. Spawn the sub-agents in parallel

Every sub-agent returns **only rows**, no prose, one per finding:

```
<path> | <line in the new file> | <what the change does and why it's a problem, one or two sentences> | <comment>
```

`<comment>` is, in PR mode, written to the PR author as a reviewer: polite, direct, posts as is, a question when unsure ("Could this be null when…?"). In local mode it is a short fix. No findings means it returns `none`.

**Spec sub-agent** gets the diff command, commit list, the spec contents and their source, and any already-reported findings. Brief: "Find (a) requirements missing or partial; (b) behaviour not asked for (scope creep); (c) requirements implemented wrongly. Quote the spec line inside the finding. Skip anything already reported."

**Risk sub-agent** gets the diff command, commit list and other reviewers' comments. Brief: "Report only high-confidence bugs, security issues (above all authorization against a path or query id instead of the caller's authenticated identity, an IDOR), behavioural regressions, data-loss risks, concurrency problems, API-contract breaks, and missing tests for changed behaviour. Read the changed files, the surrounding code and the call sites before asserting a break; no style nits, no speculation. Put the evidence in the finding."

### 5. Report

The output is **the table and nothing else**: no intro, no per-axis sections, no methodology, no praise, no restating the PR.

| Repo | File | Line | Finding | PR comment |
|---|---|---|---|---|
| `org/api` | `src/orders/service.ts` | 42 | **Risk**: looks up the order by the path id without checking it belongs to the caller, so any user can read any order (IDOR). | Should this check `order.userId === req.user.id`? As it is, any authenticated user can fetch someone else's order by id. |
| `org/android` | `OrderScreen.kt` | 78 | **Spec**: ticket says "show the empty state when there are no orders" but the empty list renders a blank screen. | The ticket asks for an empty state when there are no orders. I think it's missing here? |

- **Repo** column only when the run covers more than one repo; otherwise drop it.
- Local mode: the last column is **Fix**.
- Prefix each finding with its axis in bold. Order rows by repo, then file.

Under the table, at most one line, only if something applies: a skipped axis and why ("Spec skipped: no ticket found"; "Risk skipped: `sh:open-pr` review current at `abc1234`"), or an unresolved ticket key. No findings at all: say "No findings." and stop.

### 6. Post the comments (PR mode only)

Offer once to post the PR comments as a draft review. On a yes, write `/tmp/code-review-<repo>-<N>.json` per PR (one comment per row on its `path` + `line`, `side: RIGHT`, `event: COMMENT`) for `gh api repos/<owner>/<repo>/pulls/<N>/reviews --input <file>`, print the exact commands, and **post only on a second yes**. Never approve or request changes.

## Why two axes

Code that does exactly what the ticket asked can still break things (**Spec pass, Risk fail**), and correct, safe code can implement the wrong thing (**Risk pass, Spec fail**). Separate sub-agents stop one axis from masking the other.
