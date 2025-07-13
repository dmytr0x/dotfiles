#!/usr/bin/env bash

source ./core.sh

info "🚀 Installing rust ..."
mise install rust

# Experimental Rust compiler front-end for IDEs
info "🚀 Installing rust-analyzer ..."
cargo install rust-analyzer
