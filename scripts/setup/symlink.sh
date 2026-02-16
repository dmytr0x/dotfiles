#!/usr/bin/env bash

# Initialise helpers
source ./core.sh

info "🚀 Linking global configs ..."
symlink $(pwd)/dotfiles/.gitconfig $HOME/.gitconfig
symlink $(pwd)/dotfiles/.gitignore_global $HOME/.gitignore_global
symlink $(pwd)/dotfiles/.zprofile $HOME/.zprofile
symlink $(pwd)/dotfiles/.zshenv $HOME/.zshenv
symlink $(pwd)/dotfiles/.zshrc $HOME/.zshrc

info "🚀 Linking packages configs ..."
symlink $(pwd)/dotfiles/helix $HOME/.config/helix
symlink $(pwd)/dotfiles/zed/settings.json $HOME/.config/zed/settings.json
symlink $(pwd)/dotfiles/zed/keymap.json $HOME/.config/zed/keymap.json
symlink $(pwd)/dotfiles/zed/tasks.json $HOME/.config/zed/tasks.json
symlink $(pwd)/dotfiles/zed/snippets $HOME/.config/zed/snippets
symlink $(pwd)/dotfiles/zed/debug.json $HOME/.config/zed/debug.json
symlink $(pwd)/dotfiles/amethyst $HOME/.config/amethyst
symlink $(pwd)/dotfiles/lazygit $HOME/.config/lazygit
symlink $(pwd)/dotfiles/ripgrep $HOME/.config/ripgrep
symlink $(pwd)/dotfiles/starship $HOME/.config/starship
symlink $(pwd)/dotfiles/wezterm $HOME/.config/wezterm
symlink $(pwd)/dotfiles/ghostty $HOME/.config/ghostty
symlink $(pwd)/dotfiles/yazi $HOME/.config/yazi
symlink $(pwd)/dotfiles/zsh $HOME/.config/zsh
symlink $(pwd)/dotfiles/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
symlink $(pwd)/dotfiles/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
symlink $(pwd)/dotfiles/leaderkey $HOME/.config/leaderkey
symlink $(pwd)/dotfiles/atuin $HOME/.config/atuin
symlink $(pwd)/dotfiles/mise $HOME/.config/mise
symlink $(pwd)/dotfiles/opencode/config.json $HOME/.config/opencode/config.json

info "🚀 Linking local binaries ..."
symlink $(pwd)/dotfiles/bin/check-port $HOME/.local/bin/check-port
symlink $(pwd)/dotfiles/bin/clear-port $HOME/.local/bin/clear-port
symlink $(pwd)/dotfiles/bin/colors $HOME/.local/bin/colors
symlink $(pwd)/dotfiles/bin/flush-dns $HOME/.local/bin/flush-dns
symlink $(pwd)/dotfiles/bin/_dup_scout.py $HOME/.local/bin/_dup_scout.py
symlink $(pwd)/dotfiles/bin/_pdf_slicer.py $HOME/.local/bin/_pdf_slicer.py
symlink $(pwd)/dotfiles/bin/remove-all $HOME/.local/bin/remove-all
symlink $(pwd)/dotfiles/bin/ask $HOME/.local/bin/ask
symlink $(pwd)/dotfiles/bin/git-worktree-add $HOME/.local/bin/git-worktree-add
symlink $(pwd)/dotfiles/bin/git-worktree-open $HOME/.local/bin/git-worktree-open
symlink $(pwd)/dotfiles/bin/git-worktree-remove $HOME/.local/bin/git-worktree-remove
