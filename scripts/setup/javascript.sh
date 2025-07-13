#!/usr/bin/env bash

source ./core.sh

DENO_VERSION=$(get_last_brew_package_version "deno")
info "🚀 Installing deno $DENO_VERSION ..."
mise install deno

BUN_VERSION=$(get_last_brew_package_version "bun")
info "🚀 Installing bun $BUN_VERSION ..."
mise install bun
