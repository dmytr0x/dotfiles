#!/usr/bin/env bash

eval "$(pyenv init -)"

eval "$(uv generate-shell-completion zsh)"
