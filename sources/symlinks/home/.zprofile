# --- local/bin
export PATH="$PATH:$HOME/.local/bin"

# --- brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- zoxide
eval "$(zoxide init zsh)"

# --- fzf
export FZF_COMPLETION_TRIGGER='~~'
export PATH="$PATH:/opt/homebrew/opt/fzf/bin"
