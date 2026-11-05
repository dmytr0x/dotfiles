if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Inside Herdr the post-switch hook opens a workspace instead of moving the pane.
[[ "${HERDR_ENV:-}" == 1 ]] && export WORKTRUNK_SWITCH__CD=false
