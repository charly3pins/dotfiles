# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Code/go
export GOBIN=$GOPATH/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#NVM Mac
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# LANG
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# FZF dracula theme
export FZF_DEFAULT_OPTS='
  --color fg:255,bg:236,hl:84,fg+:255,bg+:236,hl+:215
  --color info:141,prompt:84,spinner:212,pointer:212,marker:212
'

# JAVA
export PATH="/usr/local/opt/openjdk@8/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home)
#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# FABRIC
export PATH="$PATH:/Users/charly/.local/bin"
if [ -f "/Users/charly/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/charly/.config/fabric/fabric-bootstrap.inc"; fi

# PATH
export PATH=$PATH:$HOME/Code/flutter/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$GOBIN
