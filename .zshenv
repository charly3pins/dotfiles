# XDG base directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Make sure this stuff is in the path.
export PATH="$HOME/.nvim/bin:$PATH" # neovim
export PATH="$HOME/.cargo/bin:$PATH" # cargo
export PATH="$HOME/.local/bin:$PATH" # zoxide
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin" # go
export BUN_INSTALL="$HOME/.bun" # bun 
export PATH="$BUN_INSTALL/bin:$PATH" # bun

# Set up git configuration.
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# zsh configuration.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export SHELL_SESSIONS_DISABLE=1

# Man pages
export MANPAGER='nvim +Man!'

# Set up neovim as the default editor.
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"

# Don't let Ghostty mess up with the cursor.
export GHOSTTY_SHELL_FEATURES="title,sudo"

# Ripgrep.
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/.ripgreprc"

# fzf setup.
export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,bg:#0e1419,hl:#e11299,fg+:#f8f8f2,bg+:#44475a,hl+:#e11299,info:#f1fa8c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#a4ffff,header:#6272a4 \
--cycle --pointer=▎ --marker=▎"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# TERM
export TERM=xterm-256color

# Cargo (Rust)
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# ALIAS
alias tunnel-staging-mysql='gcloud compute start-iap-tunnel iap-staging-mysql-users 3306 --local-host-port=localhost:3307 --zone=europe-west1-b --project "swordhealth-staging"'
alias tunnel-staging-postgres='gcloud compute start-iap-tunnel iap-staging-mysql-users 5435 --local-host-port=0.0.0.0:5435 --zone=europe-west1-b --project "swordhealth-staging"'
alias android_emulator='./bin/studio -avd Pixel_8 & adb -d wait-for-device & adb logcat'

# opencode
export PATH=$HOME/.opencode/bin:$PATH
