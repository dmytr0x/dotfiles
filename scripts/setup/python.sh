#!/usr/bin/env bash

# pyenv
PYENV_VERSION=$(get_last_brew_package_version "pyenv")
info "🚀 Installing pyenv $PYENV_VERSION ..."
brew install --quiet pyenv

source ./dotfiles/zsh/python.sh

info "🚀 Installing python 3.10 ..."
pyenv install --skip-existing 3.10

info "🚀 Installing python 3.11 ..."
pyenv install --skip-existing 3.11

info "🚀 Installing python 3.12 ..."
pyenv install --skip-existing 3.12

pyenv global 3.12

# pipx
PIPX_VERSION=$(get_last_brew_package_version "pipx")
info "🚀 Installing pipx $PIPX_VERSION ..."
brew install --quiet pipx
pipx ensurepath --quiet

pipx install ipython --python=$(pyenv which python3)

# poetry
info "🚀 Installing poetry ..."
./scripts/setup/sources/poetry.py

# pyright
PYRIGHT_VERSION=$(get_last_brew_package_version "pyright")
info "🚀 Installing pyright $PYRIGHT_VERSION ..."
brew install --quiet pyright

# ruff
RUFF_VERSION=$(get_last_brew_package_version "ruff")
info "🚀 Installing ruff $RUFF_VERSION ..."
brew install --quiet ruff

# ruff-lsp
RUFFLSP_VERSION=$(get_last_brew_package_version "ruff-lsp")
info "🚀 Installing ruff-lsp $RUFFLSP_VERSION ..."
brew install --quiet ruff-lsp
