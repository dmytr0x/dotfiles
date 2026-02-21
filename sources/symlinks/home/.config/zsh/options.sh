# Organized to match the Z Shell Manual's "Options" chapter
# https://zsh.sourceforge.io/Doc/Release/Options.html
#
# TIPS:
#   1) You can list the existing shell options with the `setopt` command.
#   2) You can get a list of all default zsh options with the `emulate -lLR zsh` command.
#   3) You can revert the options for the current shell to the default settings with the `emulate -LR zsh` command.

# This only sets options that exist
# setopt_if_exists() {
#   if [[ "${options[$1]+1}" ]]; then
#     setopt "$1"
#   fi
# }

# Autocorrect commands with typos and ask to run the correct command instead
# setopt_if_exists correct # commands
# setopt_if_exists correct_all # all arguments

# unset setopt_if_exists
