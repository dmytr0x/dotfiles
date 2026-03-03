# --- Settings
source ~/.config/zsh/options.sh
source ~/.config/zsh/key-bindings.sh
source ~/.config/zsh/env.sh
source ~/.config/zsh/aliases.sh
source ~/.config/zsh/completions.sh
source ~/.config/zsh/ssh.sh
source ~/.config/zsh/tools/starship.sh
source ~/.config/zsh/tools/ripgrep.sh
source ~/.config/zsh/tools/fzf.sh
source ~/.config/zsh/tools/atuin.sh
source ~/.config/zsh/tools/zoxide.sh
source ~/.config/zsh/tools/mise.sh
source ~/.config/zsh/tools/direnv.sh
source ~/.config/zsh/tools/worktrunk.sh

# Load external sources
SOURCES_DIR="$HOME/.zsources"
if [ -d "$SOURCES_DIR" ]; then
  for entry in "$SOURCES_DIR"/*; do
    if [ -f "$entry" ]; then
      source $entry
    fi
  done
fi
