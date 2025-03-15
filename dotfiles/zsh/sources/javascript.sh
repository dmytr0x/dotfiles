#!/usr/bin/env bash

# --- fnm
eval "$(fnm env --use-on-cd)"

# --- pnpm
export PNPM_HOME="$HOME/Library/pnpm"
if ! echo "$PATH" | grep -q "$PNPM_HOME"; then
  export PATH="$PNPM_HOME:$PATH"
fi
