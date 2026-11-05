#!/bin/sh
# Bridge from worktrunk user hooks to Herdr.
# Always exits 0: outside Herdr, or when Herdr is unreachable, it does nothing,
# so worktrunk behaves exactly as without the integration.
set -u

warn() { printf 'herdr-bridge: %s\n' "$*" >&2; }

in_herdr() {
  [ "${HERDR_ENV:-}" = 1 ] || [ -n "${HERDR_SOCKET_PATH:-}" ] || return 1
  # Inherited env can outlive the server (tmux/nohup started inside Herdr).
  [ -z "${HERDR_SOCKET_PATH:-}" ] || [ -S "$HERDR_SOCKET_PATH" ] || return 1
  command -v "${HERDR_BIN_PATH:-herdr}" >/dev/null 2>&1
}

in_herdr || exit 0
h=${HERDR_BIN_PATH:-herdr}

case "${1:-}" in
  open) # open <repo> <checkout>
    "$h" worktree open --cwd "$2" --path "$3" "--${WT_HERDR_FOCUS:-focus}" >/dev/null ||
      warn "open failed: $3"
    ;;
  close) # close <repo> <checkout> <focus-checkout|"">
    command -v jq >/dev/null 2>&1 || { warn 'jq not found'; exit 0; }
    ws=$("$h" workspace list 2>/dev/null | jq -r --arg p "$3" \
      'first(.result.workspaces[] | select(.worktree.checkout_path == $p) | .workspace_id) // empty') || ws=
    [ -n "$ws" ] || exit 0
    if [ -n "${4:-}" ]; then
      "$h" worktree open --cwd "$2" --path "$4" --focus >/dev/null || warn "focus failed: $4"
    fi
    "$h" workspace close "$ws" >/dev/null || warn "close failed: $ws"
    ;;
  merged) # merged <branch> <target>
    "$h" notification show "Merged $2 → $3" --sound done >/dev/null || warn 'notify failed'
    ;;
  agent) # agent <repo> <checkout> <name>; no-op unless WT_HERDR_AGENT is set
    [ -n "${WT_HERDR_AGENT:-}" ] || exit 0
    command -v jq >/dev/null 2>&1 || { warn 'jq not found'; exit 0; }
    pane=$("$h" worktree open --cwd "$2" --path "$3" --no-focus 2>/dev/null |
      jq -r '.result.root_pane.pane_id // empty') || pane=
    [ -n "$pane" ] || { warn "no root pane for $3"; exit 0; }
    "$h" agent start "$4" --kind "$WT_HERDR_AGENT" --pane "$pane" >/dev/null ||
      warn "agent start failed: $4"
    ;;
  *)
    warn "unknown command: ${1:-}"
    ;;
esac
exit 0
