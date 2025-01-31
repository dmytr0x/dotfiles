#!/usr/bin/env bash

# Initialise environment
source ./dotfiles/zsh/dotfiles.sh

# Initialise helpers
source ./core.sh

info "🚀 Installing dotfiles ..."

# Create symlinks
# source ./scripts/setup/symlink.sh

# Install packages via homebrew
# brew bundle --no-upgrade --file=./scripts/setup/Brewfile

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install programming languages
# source ./scripts/setup/python.sh
# source ./scripts/setup/javascript.sh
# source ./scripts/setup/rust.sh
# source ./scripts/setup/golang.sh
