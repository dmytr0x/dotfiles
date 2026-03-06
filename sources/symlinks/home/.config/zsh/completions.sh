# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/completions/git.sh
fpath=($HOME/.config/zsh/completions $fpath)
autoload -Uz compinit
# If ~/.zcompdump is missing or older than 24 hours, rebuild completions.
# Otherwise, load completions from the existing dump without checking it
if [[ ! -f ~/.zcompdump || -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
