# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Code/go
export GOBIN=$GOPATH/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh    "  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_D    IR/bash_completion"  # This loads nvm bash_comp    letion

# LANG
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# SPICETIFY
export SPICETIFY="/usr/local/spicetify-cli/spicetify"
export PATH="$SPICETIFY:$PATH"

# FZF by https://github.com/ianchesal/nord-fzf
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

export PATH=$PATH:$HOME/bin
export PATH=$PATH:$GOBIN
