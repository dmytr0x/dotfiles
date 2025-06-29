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

FZF_PREVIEW_SCRIPT="$DOTFILES/dotfiles/bin/fzf-preview"

export FZF_SKIP=".git,.npm,node_modules"
export FZF_DEFAULT_OPTS="
 --height=90%
 --layout=reverse
 --info=inline
 --margin=0
 --padding=0
 --walker-skip=$FZF_SKIP
 --preview-window=down:50%
 --preview='$FZF_PREVIEW_SCRIPT {}'
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
# export FZF_CTRL_R_OPTS="
#   --preview 'echo {}' --preview-window down:3:wrap
#   --bind 'ctrl-/:toggle-preview'
#   --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
#   --header 'Press CTRL-Y to copy command into clipboard'"

# Auto suggest by trigger
export FZF_COMPLETION_TRIGGER="~~"
export FZF_COMPLETION_OPTS=$FZF_DEFAULT_OPTS

# Display shortcuts
fzf-show-shortcuts() {
    fzf \
    --header="Shortcuts" \
    --header-lines=0 \
    --prompt "Phrase> " \
    --ansi \
    --no-preview \
    --layout=reverse \
    --info=inline \
    --bind "enter:become()" \
    --bind "ctrl-e:execute(\$EDITOR ~/.config/zsh/data/shortcuts)+reload(cat ~/.config/zsh/data/shortcuts)" \
    < ~/.config/zsh/data/shortcuts
}

# Favourite commands {
fzf-favourites() {
  selected=$(
    rg --no-line-number '^\s*[^#]' < ~/.config/zsh/data/favourites | fzf \
      --header="Favourites" \
      --prompt "Command> " \
      --ansi \
      --preview-window=down:1:wrap \
      --preview "rg --no-config --color=always --fixed-strings --stop-on-nonmatch --case-sensitive --before-context=1 --after-context=0 "{}" < ~/.config/zsh/data/favourites" \
      --bind "ctrl-e:execute(\$EDITOR ~/.config/zsh/data/favourites)+reload(rg --no-line-number '^\s*[^#]' < ~/.config/zsh/data/favourites)"
  )
  if [ -n "$selected" ]; then
    print -z "$selected"
  fi
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
    --search-path "$DOTFILES" \
    --type file \
    --type dir \
    --type symlink \
    --exclude .git \
    --exclude node_modules \
    --color always
  )

  echo "$files\n$configs\n$projects" | \
    fzf \
    --header="Edit popular file/directory" \
    --ansi \
    --bind="enter:become(\$EDITOR {1})"
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
    *)            fzf --preview '$FZF_PREVIEW_SCRIPT {}' "$@" ;;
  esac
}

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
