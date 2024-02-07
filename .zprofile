# ===
source "$HOME/.setup/sources/zsh/helpers_set.zsh"

# --- brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- local/bin
add_path "$HOME/.local/bin"

# --- pyenv
eval "$(pyenv init --path)"

# --- rust
add_path "$HOME/.cargo/bin"

# --- go
export GOROOT=$HOME/.golang
export GOPATH=$HOME/.go
add_path "$GOROOT/bin"
add_path "$GOPATH/bin"

# --- zoxide
eval "$(zoxide init zsh)"

# --- fzf
export FZF_COMPLETION_TRIGGER='~~'
add_path "/opt/homebrew/opt/fzf/bin"


# ===
source "$HOME/.setup/sources/zsh/helpers_unset.zsh"
