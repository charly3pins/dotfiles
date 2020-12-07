# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FCNTL_LOCK

# Start zim
source ${ZIM_HOME}/init.zsh

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_MAXLENGTH=300

source "$DOTFILES_PATH/shell/init.sh"

source "$DOTFILES_PATH/shell/zsh/key-bindings.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "$DOTFILES_PATH/modules/z/z.sh"

