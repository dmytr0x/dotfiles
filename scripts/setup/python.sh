#!/usr/bin/env bash

# Initialise helpers
source ./core.sh

# Install global python
mise install python

# basedpyright
BASEDPYRIGHT_VERSION=$(get_last_brew_package_version "basedpyright")
info "🚀 Installing basedpyright $BASEDPYRIGHT_VERSION ..."
brew install --quiet basedpyright

# ruff
RUFF_VERSION=$(get_last_brew_package_version "ruff")
info "🚀 Installing ruff $RUFF_VERSION ..."
brew install --quiet ruff
