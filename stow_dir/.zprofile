# --- local bin
export PATH="$HOME/.local/bin:$PATH"

# --- brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- pyenv
eval "$(pyenv init --path)"

# --- tmux
# where should I put you?
bindkey -s ^f "tmux-sessionizer\n"
