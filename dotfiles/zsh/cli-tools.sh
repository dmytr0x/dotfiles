# --- ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
alias hrg="rg --hyperlink-format='file://{path}:{line}:{column}'"

# --- pyenv
eval "$(pyenv init -)"

# --- fnm
eval "$(fnm env --use-on-cd)"

# --- pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

