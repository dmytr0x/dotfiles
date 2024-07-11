# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
#
# TIPS:
#   1) Use `read -k` to get a key sequence.
#   2) Use `bindkey` to output all the key bindings for the global keymap.

typeset -gA keys=(
  Up              '^[[A'
  Down            '^[[B'
  Home            '^[[H'
  End             '^[[F'
  Delete          '^[[3~'
  Escape          '^['

  Ctrl+Delete     '^[[3;5~'
  Ctrl+K          '^K'
)

# Erase whole line
bindkey "${keys[Ctrl+K]}" kill-whole-line

