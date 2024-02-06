# ===
source "$HOME/.setup/sources/zsh/helpers_set.sh"

# --- brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- local/bin
add_path "$HOME/.local/bin"

# --- pyenv
eval "$(pyenv init --path)"

# --- rust
add_path "$HOME/.cargo/bin"

# --- zoxide
eval "$(zoxide init zsh)"

# --- fzf
export FZF_COMPLETION_TRIGGER='~~'
add_path "/opt/homebrew/opt/fzf/bin"


# ===
source "$HOME/.setup/sources/zsh/helpers_unset.sh"
