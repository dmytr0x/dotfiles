# --- brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- rust

# --- local bin (should be the last)
export PATH="$HOME/.local/bin:$PATH"

# --- pyenv
eval "$(pyenv init --path)"

# --- tmux
# where should I put you?
bindkey -s ^f "tmux-sessionizer\n"

# --- rg
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 50% --border'

#
