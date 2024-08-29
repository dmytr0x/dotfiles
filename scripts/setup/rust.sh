#!/usr/bin/env bash

info "🚀 Installing rust ..."

source ./dotfiles/zsh/rust.sh

if [ ! -d "$CARGO_HOME" ]; then
  ./scripts/setup/sources/rustup.sh \
    -y \
    --no-modify-path \
    --profile=default \
    --component=rust-analyzer
fi
