# Enable aliases to be sudo’ed
alias sudo='sudo '

# Dir
# alias ls="eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ls="eza --icons=always"
alias ll="ls -l"
alias la="ls -la"

#Jumps
alias ..="cd .."
alias arx="cd ~/Code/arex"
alias arxg="cd ~/Code/go/src/github.com/arexio/"
alias c3p="cd ~/Code/go/src/github.com/charly3pins"

# Git
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull"
alias gplr="git pull --rebase"
alias gl="git log --oneline"
alias glo="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias gri="git rebase -i"
alias grd="git rebase develop"
