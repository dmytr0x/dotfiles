# theme colours
FZF_COLORS="\
bg+:-1,\
bg:-1,\
border:#6b6b6b,\
spinner:#98bc99,\
hl:#719872,\
fg:#d9d9d9,\
header:italic:#719872,\
info:#bdbb72,\
pointer:#e12672,\
marker:#e17899,\
fg+:#d9d9d9,\
preview-bg:-1,\
prompt:#98bede,\
hl+:#98bc99\
"

export FZF_SKIP=".git,.npm,node_modules"
export FZF_DEFAULT_OPTS="
  --height=90%
  --layout=reverse
  --info=inline
  --margin=0
  --padding=0
  --walker-skip=$FZF_SKIP
  --preview-window=down:50%
  --preview='$HOME/.setup/scripts/zsh/fzf-preview.zsh {}'
  --bind 'ctrl-/:change-preview-window(right:50%|hidden|down:50%)'
  --color='$FZF_COLORS'
"

# CTRL-T: Paste the selected files onto the command-line.
export FZF_CTRL_T_OPTS="
  $FZF_DEFAULT_OPTS
  --header 'Paste the selected files onto the command-line'
"

# ALT-C: cd into the selected directory.
export FZF_ALT_C_OPTS="
  $FZF_DEFAULT_OPTS
  --header 'cd into the selected directory'
"

# CTRL-R: Paste the selected command from history onto the command-line.
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'Press CTRL-Y to copy command into clipboard'"

# Auto suggest by trigger
export FZF_COMPLETION_TRIGGER="~~"
export FZF_COMPLETION_OPTS=$FZF_DEFAULT_OPTS

# List of processes with reloading key binding
# alias fps="ps -ef |
#   fzf --bind 'ctrl-r:reload(ps -ef)' \
#       --header 'Press CTRL-R to reload' \
#       --header-lines=1 \
#       --layout=reverse
# "

# Edit popular file/directory {
fzf-edit-popular() {
  files=$(for p (
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.zprofile"
  ); do echo $p; done)

  projects=$(fd \
    --base-directory "$HOME" \
    --search-path "$HOME/Work" \
    --type dir \
    --min-depth 2 \
    --max-depth 2 \
    --exclude .git \
    --exclude node_modules \
    --color always
  )

  configs=$(fd \
    --base-directory "$HOME" \
    --search-path "$HOME/.config" \
    --search-path "$HOME/.setup" \
    --type file \
    --type dir \
    --type symlink \
    --exclude .git \
    --exclude node_modules \
    --color always
  )

  echo "$files\n$configs\n$projects" | \
    fzf \
    --ansi \
    --bind="enter:become(nvim {1})" \
    --header="Edit popular file/directory"
}

bindkey -N fzf-edit-popular
bindkey -s '\ee' 'fzf-edit-popular\n'
# }

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200' "$@" ;;
    export|unset) fzf --preview-window="hidden" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview  '$HOME/.setup/scripts/zsh/fzf-preview.zsh {}' "$@" ;;
  esac
}

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
