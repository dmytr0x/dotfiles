#!/usr/bin/env bash

# Initialise environment
source ./dotfiles/zsh/dotfiles.sh

# Initialise helpers
source ./core.sh

info "🚀 Installing dotfiles ..."

answer=$(yes_no_question "Do you want to create symlinks?")
if [ "$answer" = "y" ]; then
  source ./scripts/setup/symlink.sh
fi

answer=$(yes_no_question "Do you want to install brew packages and casks?")
if [ "$answer" = "y" ]; then
  brew bundle --no-upgrade --file=./scripts/setup/Brewfile
fi

answer=$(yes_no_question "Do you want to install zsh & oh-my-zsh?")
if [ "$answer" = "y" ]; then
  source ./scripts/setup/zsh.sh
fi

# Install programming languages
mkdir -p $HOME/.zsources

answer=$(yes_no_question "Do you want to install Python?")
if [ "$answer" = "y" ]; then
  source ./scripts/setup/python.sh
  ln -s $DOTFILES/scripts/setup/sources/python.sh $HOME/.zsources/python.sh
fi

answer=$(yes_no_question "Do you want to install JavaScript?")
if [ "$answer" = "y" ]; then
  source ./scripts/setup/javascript.sh
  ln -s $DOTFILES/scripts/setup/sources/javascript.sh $HOME/.zsources/javascript.sh
fi

answer=$(yes_no_question "Do you want to install Rust?")
if [ "$answer" = "y" ]; then
  source ./scripts/setup/rust.sh
  ln -s $DOTFILES/scripts/setup/sources/rust.sh $HOME/.zsources/rust.sh
fi

answer=$(yes_no_question "Do you want to install Go?")
if [ "$answer" = "y" ]; then
  source ./scripts/setup/go.sh
  ln -s $DOTFILES/scripts/setup/sources/go.sh $HOME/.zsources/go.sh
fi
