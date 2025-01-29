#!/usr/bin/env bash

# Initialise helpers
source ./core.sh

# pyenv
PYENV_VERSION=$(get_last_brew_package_version "pyenv")
info "🚀 Installing pyenv $PYENV_VERSION ..."
brew install --quiet pyenv
eval "$(pyenv init -)"

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

# basedpyright
BASEDPYRIGHT_VERSION=$(get_last_brew_package_version "basedpyright")
info "🚀 Installing basedpyright $BASEDPYRIGHT_VERSION ..."
brew install --quiet basedpyright

# ruff
RUFF_VERSION=$(get_last_brew_package_version "ruff")
info "🚀 Installing ruff $RUFF_VERSION ..."
brew install --quiet ruff
