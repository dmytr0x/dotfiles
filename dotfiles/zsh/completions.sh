# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/completions/git.sh
fpath=($HOME/.config/zsh/completions $fpath)
autoload -Uz compinit && compinit
