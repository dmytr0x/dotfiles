#!/usr/bin/env bash

# install "Oh My Zsh"
curl https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
bash install.sh --skip-chsh

# install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
