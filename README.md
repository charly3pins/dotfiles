# Dotfiles

Personal dotfiles for Ubuntu 24.04, managed via symlinks from `~/.config/`.

## Structure

```
dotfiles/
├── .config/
│   ├── ghostty/       # Terminal emulator
│   ├── git/           # Git config and aliases
│   ├── i3/            # i3 window manager
│   ├── i3status/      # i3 status bar
│   ├── nvim/          # Neovim config
│   ├── opencode/      # AI coding agent (skills, AGENTS.md)
│   ├── pi/            # Pi AI agent
│   ├── polybar/       # Polybar status bar
│   ├── rofi/          # Application launcher
│   ├── tmux/          # Terminal multiplexer
│   └── zsh/           # Shell config
├── envrc/             # direnv environments
├── installs.txt       # Fresh machine setup steps
└── .gitignore
```

## Setup

Each config is symlinked into `~/.config/`:

```bash
ln -s ~/dotfiles/.config/ghostty ~/.config/ghostty
ln -s ~/dotfiles/.config/git ~/.config/git
ln -s ~/dotfiles/.config/i3 ~/.config/i3
ln -s ~/dotfiles/.config/i3status ~/.config/i3status
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.config/opencode ~/.config/opencode
ln -s ~/dotfiles/.config/pi ~/.config/pi
ln -s ~/dotfiles/.config/polybar ~/.config/polybar
ln -s ~/dotfiles/.config/rofi ~/.config/rofi
ln -s ~/dotfiles/.config/tmux ~/.config/tmux
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
```

See `installs.txt` for the full fresh-machine setup.

## AI Coding

The [opencode/](.config/opencode/) config holds the AI coding agent setup: global AGENTS.md, skills, and MCP integrations. See its [README](.config/opencode/README.md) for details.
