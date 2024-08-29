#!/usr/bin/env bash

export CARGO_HOME=$HOME/.cargo
export RUSTUP_HOME=$HOME/.rustup

export PATH=$PATH:$CARGO_HOME/bin

if [ -d $CARGO_HOME ]; then
  source "$CARGO_HOME/env"
fi
