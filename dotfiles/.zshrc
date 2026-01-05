# --- Oh-my-zsh
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
unset ZSH_THEME

# How often to auto-update (in days).
zstyle ':omz:update' frequency 14
zstyle ':omz:update' mode reminder # just remind me to update when it's time

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Change the command execution time stamp shown in the history command output.
HIST_STAMPS="dd.mm.yyyy"

# Activate vim motions in the shell
# set -o vi

# --- Settings
# Must be first source
source $HOME/.config/zsh/dotfiles.sh

source ~/.config/zsh/options.sh
source ~/.config/zsh/key-bindings.sh
source ~/.config/zsh/env.sh
source ~/.config/zsh/aliases.sh
source ~/.config/zsh/overrides.sh
source ~/.config/zsh/completions.sh
source ~/.config/zsh/ssh.sh
source ~/.config/zsh/tools/starship.sh
source ~/.config/zsh/tools/ripgrep.sh
source ~/.config/zsh/tools/fzf.sh
source ~/.config/zsh/tools/atuin.sh
source ~/.config/zsh/tools/zoxide.sh
source ~/.config/zsh/tools/mise.sh

# Load external sources
SOURCES_DIR="$HOME/.zsources"
if [ -d "$SOURCES_DIR" ]; then
  for entry in "$SOURCES_DIR"/*; do
    if [ -f "$entry" ]; then
      source $entry
    fi
  done
fi
