# --- brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- local/bin
export PATH="$PATH:$HOME/.local/bin"

# --- rust
export PATH="$PATH:$HOME/.cargo/bin"

# --- go
export GOROOT=$HOME/.golang
export GOPATH=$HOME/.go
export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$GOPATH/bin"

# --- zoxide
eval "$(zoxide init zsh)"

# --- fzf
export FZF_COMPLETION_TRIGGER='~~'
export PATH="$PATH:/opt/homebrew/opt/fzf/bin"
