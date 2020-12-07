export DOTFILES_PATH=$HOME/.dotfiles

# bash_history config
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Load my aliases
source $DOTFILES_PATH/shell/aliases.sh

# Tab completion
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# git bash prompt
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_THEME=Default_Ubuntu
source ~/.bash-git-prompt/gitprompt.sh

source "$DOTFILES_PATH/shell/init.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source "$DOTFILES_PATH/shell/bash/themes/charly.sh"

