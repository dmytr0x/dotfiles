#!/usr/bin/env bash

DENO_VERSION=$(get_last_brew_package_version "deno")
info "🚀 Installing deno $DENO_VERSION ..."
brew install --quiet deno

BUN_VERSION=$(get_last_brew_package_version "bun")
info "🚀 Installing bun $BUN_VERSION ..."
brew tap "oven-sh/bun"
brew install --quiet bun
