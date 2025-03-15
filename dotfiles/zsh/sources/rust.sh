#!/usr/bin/env bash

export RUSTUP_HOME=$HOME/.rustup
export CARGO_HOME=$HOME/.cargo

if ! echo "$PATH" | grep -q "$CARGO_HOME/bin"; then
  export PATH="$PATH:$CARGO_HOME/bin"
fi

if [ -d $CARGO_HOME ]; then
  source "$CARGO_HOME/env"
fi
