#!/usr/bin/env bash

# Initialise environment
source ./dotfiles/zsh/dotfiles.sh

# Initialise helpers
source ./core.sh

info "🚀 Installing dotfiles ..."

source ./scripts/setup/symlink.sh
brew bundle --file=scripts/setup/Brewfile
source ./scripts/setup/python.sh
source ./scripts/setup/javascript.sh
source ./scripts/setup/rust.sh
source ./scripts/setup/golang.sh
