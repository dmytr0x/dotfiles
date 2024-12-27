#!/usr/bin/env bash

info "🚀 Linking global configs ..."
symlink $(pwd)/dotfiles/.gitconfig $HOME/.gitconfig
symlink $(pwd)/dotfiles/.gitignore $HOME/.gitignore
symlink $(pwd)/dotfiles/.zprofile $HOME/.zprofile
symlink $(pwd)/dotfiles/.zshenv $HOME/.zshenv
symlink $(pwd)/dotfiles/.zshrc $HOME/.zshrc

info "🚀 Linking packages configs ..."
symlink $(pwd)/dotfiles/helix $HOME/.config/helix
symlink $(pwd)/dotfiles/amethyst $HOME/.config/amethyst
symlink $(pwd)/dotfiles/lazygit $HOME/.config/lazygit
symlink $(pwd)/dotfiles/nvim $HOME/.config/nvim
symlink $(pwd)/dotfiles/ripgrep $HOME/.config/ripgrep
symlink $(pwd)/dotfiles/starship $HOME/.config/starship
symlink $(pwd)/dotfiles/wezterm $HOME/.config/wezterm
symlink $(pwd)/dotfiles/yazi $HOME/.config/yazi
symlink $(pwd)/dotfiles/zsh $HOME/.config/zsh
symlink $(pwd)/dotfiles/vscode $HOME/.config/vscode

info "🚀 Linking local binaries ..."
symlink $(pwd)/dotfiles/bin/check-port $HOME/.local/bin/check-port
symlink $(pwd)/dotfiles/bin/clear-port $HOME/.local/bin/clear-port
symlink $(pwd)/dotfiles/bin/colors $HOME/.local/bin/colors
symlink $(pwd)/dotfiles/bin/ds-delete $HOME/.local/bin/ds-delete
symlink $(pwd)/dotfiles/bin/flush-dns $HOME/.local/bin/flush-dns
