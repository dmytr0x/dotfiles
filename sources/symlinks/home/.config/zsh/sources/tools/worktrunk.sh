# Default to the personal profile; ~/.zsources/*.sh can select another per machine.
export WORKTRUNK_CONFIG_PATH="${WORKTRUNK_CONFIG_PATH:-$HOME/.config/worktrunk/config.personal.toml}"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Inside Herdr the post-switch hook opens a workspace instead of moving the pane.
[[ "${HERDR_ENV:-}" == 1 ]] && export WORKTRUNK_SWITCH__CD=false
