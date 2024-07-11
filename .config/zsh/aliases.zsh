# dotfiles: https://sarab.dev/posts/dotfiles-bare-git-repo/
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Easier navigation
alias .='pwd'
alias ..='cd ..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'
alias -- -="cd -" # previous working directory

# Shell
alias reload="source ~/.zshrc && echo 'Shell config reloaded from ~/.zshrc'"

# Sane defaults for built-ins (verbose and interactive)
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias grep="grep -i --color=auto"
alias mkdir="mkdir -p"

# Editors
alias v="nvim"
alias vim="nvim"
alias vscode="code --new-window --profile=Empty"

# Shortcuts
alias tree="eza --tree"
alias ls="eza"
alias ll="ls --long --no-user --header --grid --git"
alias llt="ls --tree --git-ignore"
alias yy="yazi"
alias -- +x="chmod +x"

# Download file and save it with the name of the remote file in the current working directory
# Usage: get <URL>
alias get="curl -O -L"

# System
alias shutdownmac="sudo shutdown -h now"
alias restartmac="sudo shutdown -r now"

