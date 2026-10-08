---
name: pr-review
description: "Review someone else's pull request(s) against a ticket and the repo's standards, and print ready-to-paste GitHub comments on screen (repo, file, line, comment). Read-only: never posts anything. Use when the user says 'review this PR', 'review this ticket', passes PR URLs / owner/repo#n refs with a ticket ID, or asks for review comments to paste into GitHub. For reviewing the user's own branch against a fixed point, use code-review instead."
---

Review one or more PRs written by someone else and print comments the user can copy-paste into GitHub by hand.

## Hard rules

- **Use `gh` only.** Never use webfetch or browse PR URLs: the repos are private and invisible to it. Use `gh pr view`, `gh pr diff`, `gh api`.
- **Read-only.** Never post comments or reviews, never check out branches, never run tests or the linter (CI does that), never touch the ticket tracker.
- **Fail loud.** If a PR can't be read, say so, show the real error, and skip it. Never review from the title or description alone.
- **English**, colleague tone: polite, direct, phrase uncertainty as a question.

## Input

- One or more PR refs: full URLs or `owner/repo#123`.
- A ticket ID and its description, pasted by the user. If the description is missing, ask for it. Do not try to fetch the ticket.
- The pasted description is the spec. All PRs are reviewed against that one spec.

## Process

### 1. Preflight, per PR

```
gh pr view <ref> --json number,title,baseRefName,headRefName,changedFiles
```

On failure stop for that PR and show the error. Hints:

- SAML / SSO error: token needs org authorization (`gh auth refresh`, or authorize the token for the org on GitHub).
- 404 / "could not resolve": wrong account, check `gh auth status` / `gh auth switch`.
- Fallback: ask the user to paste the output of `gh pr diff <ref>`.

### 2. Fetch, per PR

- `gh pr view <ref> --json title,body,files,commits`
- `gh pr diff <ref>`
- Where the diff lacks context, read the full file at the PR head: `gh api "repos/<owner>/<repo>/contents/<path>?ref=<headRefName>" --jq .content | base64 -d`

### 3. Standards sources

Read from the repo at the base branch via `gh api`, whichever exist: `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `CODING_STANDARDS.md`.

On top of those, apply the **smell baseline** defined in the `code-review` skill (step 3). Load that skill and reuse it; don't copy it here. Same rules: the repo's documented standards override the baseline, and smells are judgement calls, never hard violations. Skip anything tooling enforces.

### 4. Review on two axes

Run both axes (parallel sub-agents if the diff is large, as in `code-review`).

- **Spec**: against the ticket description plus the PR body. Report requirements missing or partial, behaviour not asked for (scope creep), and requirements that look implemented but wrong. If the PR body and the ticket description disagree, raise it as a `question`. With several PRs, also check that together they cover the ticket and don't overlap.
- **Standards**: documented repo standards plus the smell baseline.

### 5. Line numbers (must be right)

GitHub inline comments only work on lines inside the diff.

- Take line numbers only from `gh pr diff`, counting new-file lines from the `@@ -a,b +c,d @@` hunk headers. Added lines and context lines count; removed lines don't (for those, say "removed line, old file line N").
- Never report a line that is not in the diff. If the issue is about code outside the diff, anchor to the nearest changed line and say so in the comment.
- Always quote the code on that line, so the user can verify at a glance.
- If unsure of the exact line, write `hunk near line N` instead of guessing.

## Output

On screen only. No file. Issues only, no praise. One block per comment:

```
repo: owner/repo (PR #123)
file: path/to/file.ts
line: 42   code: `const x = ...`
type: blocking | suggestion | nit | question
comment: <ready to paste>
```

Group blocks by PR. After them: a count per type per PR, and the single most important item to look at first in each PR.

If a PR has no findings, say "no findings" for it.
