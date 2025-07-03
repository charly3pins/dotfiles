# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# Init my shell configuration (alias, exports)
source "$HOME/dotfiles/zshrc/init.sh"

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Completion for zsh in Mac
autoload -Uz compinit
compinit

