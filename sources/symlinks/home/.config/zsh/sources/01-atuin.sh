# Performace: Keep Atuin near the top: its PTY proxy can restart shell initialization,
#             causing configuration loaded before it to run twice.

export PATH="$PATH:$HOME/.atuin/bin"

eval "$(atuin init zsh)"
