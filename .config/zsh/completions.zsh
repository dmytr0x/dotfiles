# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/completions/git.bash
fpath=($HOME/.config/zsh/completions $fpath)
autoload -Uz compinit && compinit

