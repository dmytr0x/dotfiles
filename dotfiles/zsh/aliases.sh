# Easier navigation
alias ..='cd ..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'
alias -- -="cd -" # previous working directory

# Shell
alias reload="source ~/.zshrc && echo 'Shell config reloaded from ~/.zshrc'"

# Sane defaults for built-ins (verbose and interactive)
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias grep="grep -i --color=auto"
alias mkdir="mkdir -p"

# Editors
alias vim="nvim"
alias v="nvim"
alias codium="codium --new-window"

# VSCode
vscode_cmd() {
  local workspace_name=$1
  echo "code \
    --user-data-dir=$HOME/.config/vscode/workspaces/$workspace_name/user \
    --extensions-dir=$HOME/.config/vscode/workspaces/$workspace_name/extensions \
    --sync=off"
}
eval 'alias codepy="$(vscode_cmd py)"'
eval 'alias codejs="$(vscode_cmd js)"'
eval 'alias codego="$(vscode_cmd go)"'
eval 'alias coders="$(vscode_cmd rs)"'
eval 'alias codezig="$(vscode_cmd zig)"'
eval 'alias codedn="$(vscode_cmd dn)"'
eval 'alias codejava="$(vscode_cmd java)"'
unset -f vscode_cmd

# Setup partial parameters
alias lazygit="lazygit --use-config-dir=$HOME/.config/lazygit"
alias lg="lazygit"
alias pdf-slicer="uv run $HOME/.local/bin/_pdf_slicer.py"
alias dup-scout="uv run $HOME/.local/bin/_dup_scout.py"

# Shortcuts
alias tree="eza --tree"
alias ls="eza --all --width=1"
alias ll="ls --long --group --header --grid --git"
alias llt="ls --tree --level=2"
alias -- +x="chmod +x"

# Dev Tools
alias pn="pnpm"
alias pnd="pnpm dlx"

# Terminal
function get-term-colors() {
  reset="\033[39m\\033[49m"

  echo "$reset \nBackground colors:\n"
  for i in {0..255}; do
    printf '\e[48;5;%dm%3d ' $i $i
    (((i + 3) % 18)) || printf '\e[0m\n'
  done

  echo "$reset \n\nForeground colors:\n"
  for i in {0..255}; do
    printf '\e[38;5;%dm%3d ' $i $i
    (((i + 3) % 18)) || printf '\e[0m\n'
  done
}

# Yazi
alias yy="yazi"
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Download file and save it with the name of the remote file in the current working directory
# Usage: get <URL>
alias get="curl -O -L"

# Atuin Script Run
alias asr="atuin script run"
