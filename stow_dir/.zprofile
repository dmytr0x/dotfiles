# --- local bin
export PATH="$HOME/.local/bin:$PATH"

# --- brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- pyenv
eval "$(pyenv init --path)"

# --- tmux
# where should I put you?
bindkey -s ^f "tmux-sessionizer\n"

# --- neovim
alias vim="nvim"
alias vi="nvim"
# neovim as default editor
export VISUAL="nvim"

# --- rg
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 50% --border'

#
