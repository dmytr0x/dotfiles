# Start one background diffstat updater for all local Herdr sessions.
# The Python process uses a file lock, so sourcing this from multiple Herdr
# shells does not create duplicate updaters.

_herdr_diffstat_start() {
  [[ ${HERDR_ENV:-} == 1 ]] || return

  local python_bin script
  python_bin=$(command -v python3) || return
  script="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/hooks/herdr-diffstat.py"
  [[ -r "$script" ]] || return

  # Isolate the updater from the terminal so it cannot read input or overwrite the prompt:
  # stdin <- /dev/null; stdout/stderr -> /dev/null; &! backgrounds and disowns it.
  "$python_bin" "$script" </dev/null >/dev/null 2>&1 &!
}

_herdr_diffstat_start
unfunction _herdr_diffstat_start
