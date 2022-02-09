#!/usr/bin/env bash

brew install neovim

# install `Plug`
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install plugins from config
nvim --headless +PlugInstall +qall 2>/dev/null

# init treeseeter
nvim --headless +TSInstallSync\ all +qall

# init coc
nvim --headless +'CocInstall -sync coc-pyright coc-tsserver coc-json' +qall
