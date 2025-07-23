# Configura Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Zoxide (better cd)
eval "$(zoxide init zsh)"

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Completion for zsh
autoload -Uz compinit
compinit

# TMUX
alias tmux='tmux -f ~/.config/tmux/config'
