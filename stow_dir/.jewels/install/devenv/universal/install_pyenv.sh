#!/usr/bin/env bash

# sort by multiple columns (major, minor, patch)
GET_LATEST='rg -e "^\s*?(\d+.)(\d+.)(\d+)$" | sort -t "." -n -k1,1nr -k2,2nr -k3,3nr | head -n 1 | xargs'

AVAILABLE_PYTHON_VERSIONS=$(pyenv install --list)

# get last, prev and prev prev stable versions
LAST_VERSION=$(echo "$AVAILABLE_PYTHON_VERSIONS" | bash -c "$GET_LATEST")
PYTHON_VERSIONS_PREV=$(echo "$AVAILABLE_PYTHON_VERSIONS" | rg -e "^\s*?3.9.\d+" | bash -c "$GET_LATEST")
PYTHON_VERSIONS_PREV_PREV=$(echo "$AVAILABLE_PYTHON_VERSIONS" | rg -e "^\s*?3.8.\d+" | bash -c "$GET_LATEST")

brew install python@3.9
#  pyenv
brew install pyenv
pyenv install $LAST_VERSION
pyenv install $PYTHON_VERSIONS_PREV
pyenv install $PYTHON_VERSIONS_PREV_PREV
# init
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
