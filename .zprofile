# --- brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- local/bin
export PATH="$HOME/.local/bin:$PATH"

# --- pyenv
eval "$(pyenv init --path)"

# --- rust
export PATH="$HOME/.cargo/env:$PATH"

# --- zoxide
eval "$(zoxide init zsh)"
