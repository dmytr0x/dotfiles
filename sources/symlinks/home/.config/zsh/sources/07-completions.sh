# Initialize completion before fzf installs its Tab handler.
autoload -Uz compinit
compinit

if command -v carapace >/dev/null 2>&1; then
  source <(carapace _carapace zsh)
fi
