# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FCNTL_LOCK

# Start zim
source ${ZIM_HOME}/init.zsh

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_MAXLENGTH=300

# Init my shell configuration (alias, exports)
source "$DOTFILES_PATH/shell/init.sh"

# Load z module
source "$DOTFILES_PATH/modules/z/z.sh"

# Execute the history line, without verification
unsetopt HIST_VERIFY

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Completion for zsh in Mac
autoload -Uz compinit
compinit

# Enable terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
