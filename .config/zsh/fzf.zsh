# Catppuccin Mocha
# Source: https://github.com/catppuccin/fzf
#
FZF_COLORS="\
bg+:#313244,\
bg+:#1e1e2e,\
preview-bg:-1,\
selected-bg:#45475a,\
border:#6b6b6b,\
spinner:#f5e0dc,\
hl:#f38ba8,\
fg:#cdd6f4,\
header:#f38ba8,\
info:#cba6f7,\
pointer:#f5e0dc,\
marker:#b4befe,\
fg+:#cdd6f4,\
prompt:#cba6f7,\
hl+:#f38ba8\
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

# Display shortcuts
fzf-show-shortcuts() {
  cat ~/.config/zsh/shortcuts | \
    fzf \
    --prompt "Phrase> " \
    --ansi \
    --no-preview \
    --layout=reverse \
    --info=inline \
    --border \
    --margin=1 \
    --padding=1 \
    --header="Shortcuts" \
    --header-lines=0 \
    --bind "enter:become()" \
    --bind "ctrl-e:become(nvim ~/.config/zsh/shortcuts)"
}

# Favourite commands {
fzf-favourites() {
  print -z $(
    cat ~/.config/zsh/favourites | fzf \
      --prompt "Command> " \
      --ansi \
      --no-preview \
      --layout=reverse \
      --info=inline \
      --border \
      --margin=1 \
      --padding=1 \
      --header="Favourites" \
      --header-lines=0
  )
}
bindkey -N fzf-favourites
bindkey -s "^[f" "fzf-favourites\n"
# }

# Edit popular file/directory {
fzf-edit-popular() {
  files=$(for p (
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.zprofile"
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"
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
bindkey -s "^[e" "fzf-edit-popular\n"
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
