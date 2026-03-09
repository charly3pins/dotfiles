# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for an XDG-compliant Linux development environment. All configuration is stored under `.config/` and symlinked to `~/.config/` during installation.

### Key Technologies
- **OS**: Ubuntu 24.04 LTS
- **Shell**: zsh with Oh My Zsh (robbyrussell theme, zsh-autosuggestions plugin)
- **Editor**: Neovim with lazy.nvim plugin manager
- **Terminal**: Ghostty
- **Multiplexer**: tmux (prefix: Ctrl+a)
- **Window Manager**: i3 (mod key: Mod4/Super)
- **Version Control**: Git with GPG signing enabled
- **Languages**: Go, TypeScript, Lua, Shell

## Repository Structure

```
dotfiles/
├── .config/
│   ├── claude/          # Claude Code configuration
│   ├── git/             # Git config (user, gpg, includes)
│   ├── ghostty/         # Ghostty terminal config
│   ├── i3/              # i3 window manager config
│   ├── i3status/        # i3 status bar config
│   ├── nvim/            # Neovim config (init.lua, lua/plugins/)
│   ├── opencode/        # OpenCode custom agents, skills, commands
│   ├── polybar/         # Polybar config
│   ├── rofi/            # Rofi launcher config
│   ├── tmux/            # tmux config
│   ├── zsh/             # zsh config (.zshrc, aliases.sh)
│   └── .ripgreprc       # ripgrep config
├── .zshenv              # Shell environment setup (XDG paths, exports)
├── installs.txt         # Installation guide for all tools
└── .gitignore
```

## Installation Architecture

This dotfiles setup uses **symlinks** instead of copying files. The workflow is:

1. Clone this repo to `~/dotfiles`
2. For each tool, create a symlink: `ln -s ~/dotfiles/.config/<tool> ~/.config/<tool>`
3. Shell env vars are sourced from `.zshenv` which sets `ZDOTDIR`, `XDG_CONFIG_HOME`, etc.

**Important**: When modifying configs, you're editing the files in this repo directly (via symlinks), so changes are automatically tracked by git.

## Common Commands

### Environment Setup
```bash
# Source zsh config (after changes)
source ~/.config/zsh/.zshrc

# Reload tmux config
tmux source-file ~/.config/tmux/config
# Or use tmux keybind: Ctrl+a r

# Reload i3 config
# Use i3 keybind: Mod+Shift+r
```

### Neovim
```bash
# Launch Neovim
nvim

# Update plugins (lazy.nvim)
# In Neovim: :Lazy sync

# LSP, formatters, linters managed by Mason
# In Neovim: :Mason
```

### Git
- GPG signing is **enabled by default** in `.config/git/config`
- Default branch: `main`
- Pull strategy: `rebase = true`
- Push: `autoSetupRemote = true`
- Fetch: `prune = true`
- HTTPS URLs automatically use SSH: `insteadOf = https://github.com/`

### OpenCode
This repo contains custom OpenCode extensions:
- **Agents**: `codebase-analyzer`, `codebase-locator`, `codebase-pattern-finder`, `thoughts-analyzer`, `thoughts-locator`, `web-search-researcher`
- **Skills**: `brainstorming`, `defense-in-depth`, `dispatching-parallel-agents`, `executing-plans`, `finishing-a-development-branch`, `receiving-code-review`, `requesting-code-review`, `root-cause-tracing`, `subagent-driven-development`, `systematic-debugging`, `test-driven-development`, `testing-anti-patterns`, `testing-skills-with-subagents`, `using-git-worktrees`, `using-superpowers`, `verification-before-completion`, `writing-plans`, `writing-skills`
- **Commands**: `commit`, `context`, `execute`, `plan`, `research`, `review`, `ticket`

## Code Architecture

### Neovim Configuration
- **Entry point**: `init.lua` — sets up lazy.nvim and loads modules
- **Core modules**: `lua/options.lua`, `lua/keymaps.lua`, `lua/filetypes.lua`, `lua/autocmds.lua`, `lua/terminal.lua`
- **Plugins**: Each plugin in `lua/plugins/*.lua` is auto-loaded by lazy.nvim
- **LSP stack**:
  - `lsp.lua` — Main LSP config (nvim-lspconfig, mason, mason-lspconfig, keymaps, server configs)
  - `mason-tool-installer.lua` — Formatters & linters installation
  - `nvim-cmp.lua` — Completion engine (with Copilot integration)
  - `conform.nvim` — Formatting runner (format on save, `<leader>gf`)
  - `nvim-lint.nvim` — Linting runner
- **Key plugins**: Telescope, Treesitter, oil.nvim, lazygit.nvim, copilot, lualine, tmux-navigator

### Shell Configuration
- **Environment**: `.zshenv` is loaded first (XDG paths, PATH setup, exports)
- **Runtime**: `.config/zsh/.zshrc` loads Oh My Zsh, history, completions, zoxide, fzf
- **Aliases**: Defined in `.config/zsh/aliases.sh` (mostly commented out)

### Git Configuration
- **Main config**: `.config/git/config`
- **Personal overrides**: `.config/git/personal` (included via `[include]`)
- **Global ignore**: `.config/git/ignore`

### tmux
- Prefix: `Ctrl+a` (not default Ctrl+b)
- Split vertical: `Ctrl+a v`
- Split horizontal: `Ctrl+a -`
- Reload config: `Ctrl+a r`

### i3 Window Manager
- Mod key: `Mod4` (Super/Windows key)
- Audio controls: F1 (mute), F2 (volume down), F3 (volume up)
- Status bar: polybar (launched via `polybar/launch.sh`)

## Development Workflow

### Making Changes
1. Edit config files in `~/dotfiles/.config/<tool>/` (changes are live via symlinks)
2. Test the changes
3. Commit with conventional commits: `feat:`, `fix:`, `chore:`, etc.
4. All commits are GPG-signed automatically

### Adding New Tools
1. Install the tool (see `installs.txt` for examples)
2. Add config to `.config/<tool>/`
3. Create symlink: `ln -s ~/dotfiles/.config/<tool> ~/.config/<tool>`
4. Update `installs.txt` with installation instructions
5. Document in this file if it's a significant addition

### Path Management
All custom binaries/tools should be added to PATH in `.zshenv`:
- Neovim: `~/.nvim/bin`
- Cargo: `~/.cargo/bin`
- Local binaries: `~/.local/bin`
- Go: `/usr/local/go/bin`, `~/go/bin`
- Bun: `~/.bun/bin`
- OpenCode: `~/.opencode/bin`

## Important Notes

### XDG Compliance
- **All** configs go in `~/.config/` (via `XDG_CONFIG_HOME`)
- Data: `~/.local/share` (via `XDG_DATA_HOME`)
- Cache: `~/.cache` (via `XDG_CACHE_HOME`)
- State: `~/.local/state` (via `XDG_STATE_HOME`)

### Git Behavior
- GPG signing is **mandatory** for commits
- HTTPS GitHub URLs are automatically converted to SSH
- Pull always rebases
- Push auto-sets upstream
- Merge conflicts use diff3 style

### Shell Behavior
- History is shared across sessions (`share_history`)
- Duplicates are removed (`hist_ignore_dups`)
- Arrow keys search history
- Zoxide provides smart `cd` with `z` command
- fzf is available for fuzzy finding

### Neovim Behavior
- Leader key: `Space`
- Uses Copilot LSP (auto-enabled on Neovim 0.11+)
- Man pages open in Neovim via `MANPAGER='nvim +Man!'`
- Default editor for git, system, etc.

### OpenCode/Claude Integration
- Claude config dir: `~/.config/claude` (set via `CLAUDE_CONFIG_DIR`)
- OpenCode model: `github-copilot/claude-sonnet-4.6`
- Small model: `github-copilot/gpt-5-mini`
- MCP servers configured: Atlassian, Context7, Serena, Excalidraw
