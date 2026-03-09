## Who I am

- Developer on Linux, Neovim as primary editor
- Dotfiles versioned in git, XDG-compliant (`~/.config/` for everything)
- Shell: zsh, config in `~/.config/zsh/`, env vars in `~/.zshenv`
- Multiplexer: tmux
- Languages: Go, TypeScript, Lua (Neovim plugins), Shell

## Stack

- Editor: **Neovim** — never open VSCode, Cursor or any GUI editor
- Terminal tools preferred over GUI alternatives always
- Package managers: bun, npm/pnpm (TS), pip (Python), cargo (Rust)
- Version control: git + GitHub

## How I work with Claude

### Always plan first

- For any non-trivial task (3+ steps or architecture decisions), enter **Plan mode first** (Shift+Tab twice)
- Iterate the plan until it looks right, then switch to auto-accept
- If something goes wrong mid-task, stop. Go back to plan mode and re-plan
- Write specs before implementing — ambiguity kills autonomous execution

### Verify before finishing

- Before marking anything done: run tests, build, check it actually works
- If the repo has tests, run them. If not, write them
- "Works in theory" is not done

### Subagents

- Use subagents for parallel tasks or research to keep the main context clean
- One subagent = one concrete task

### Corrections → rules

- **When I correct you: update this CLAUDE.md** with the new rule
- Every correction becomes a rule. Don't repeat the same mistake

## Code style

- Readable over clever
- Conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`...
- Small, focused commits — don't batch unrelated changes
- No new dependencies without asking first
- No obvious comments in code (don't explain what the code already says)
- Prefer CLI/terminal solutions over anything requiring a GUI

## Communication style

- Direct answers, no filler or unnecessary preamble
- If something is unclear, ask before implementing — don't assume
- When presenting options, give a recommendation instead of listing 5 equal choices
- Don't over-explain things given my experience level

## What NOT to do

- Never open VSCode, Cursor or any GUI
- Never use `sudo` without explaining why
- Never delete files without explicit confirmation
- Never commit automatically unless I explicitly ask
- Never install global packages without warning me first
- Never modify `.zshenv` or shell config without asking

## Lessons learned
