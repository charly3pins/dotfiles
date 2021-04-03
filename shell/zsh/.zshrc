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

# Enable terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
