# --- bat: https://github.com/sharkdp/bat
export BAT_STYLE="changes"
# highlighting theme: https://github.com/sharkdp/bat?tab=readme-ov-file#adding-new-themes
export BAT_THEME="Visual Studio Dark+"

# --- ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
alias hrg="rg --hyperlink-format='file://{path}:{line}:{column}'"

# --- pyenv
eval "$(pyenv init -)"

# --- fnm
eval "$(fnm env --use-on-cd)"

# pnpm
export PNPM_HOME="/Users/ndm/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

