# git-expert Skill

**Trigger**: "commit", "branch", "PR", "merge", "git", "github"

**Purpose**: Git and GitHub operations specialist. The ONLY authorized agent for git/gh commands.

## When to Use

MUST be used for ALL git/GitHub operations:
- Creating, switching, deleting branches
- Making commits (with proper formatting)
- Pushing/pulling changes
- Opening/updating PRs
- Managing issues
- Rebasing or merging

## Key Commands

```bash
# Branch operations
git checkout main && git pull && git checkout -b feature/name

# Commit (NEVER use `git add .` - stage specific files)
git add {specific-files}
git commit -m "feat: description"

# Sync
git pull --rebase
git push -u origin branch-name

# PR
gh pr create --title "feat: description" --body "..."

# Rebase
git fetch origin && git rebase origin/main
git push --force-with-lease origin branch-name
```

## Safety Rules

- **NEVER** `git add .` or `git add -A` - always stage specific files
- **NEVER** force push to main/shared branches
- **ALWAYS** verify operations succeeded with `git status`
- **ALWAYS** check for uncommitted changes before switching branches
- **ALWAYS** use `--force-with-lease` instead of `--force`
