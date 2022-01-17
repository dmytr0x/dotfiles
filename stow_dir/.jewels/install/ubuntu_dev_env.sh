#!/usr/bin/env bash

LAST_PYTHON=3.10
LAST_NODE_LTS=16

# update system packages
sudo apt update && sudo apt upgrade -y


# install base packages
sudo apt install -y \
net-tools \
jq \
rsync \
wget \
curl \
git \
build-essential \
gcc


# install homebrew {
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# preferences are going with dotfiles
# }


# install devtools via homebrew
brew install \
tmux \
neovim \
fzf \
ripgrep \
midnight-commander \
htop \
stow \
bat \
dust \
exa


# install fonts {
sudo apt install fonts-firacode
fc-cache -f
# }


# directories layout #
mkdir -p ~/code/personal
# }


# install python {
brew install python@3.9 pyenv pipx
pyenv install $LAST_PYTHON
eval "$(pyenv init -)"
# }


# install js runtime {
brew install node@$LAST_NODE_LTS deno
# add links for files from /bin
brew link node@16
# }


# install zsh {
sudo apt install -y zsh
# install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# change default shell to zsh
chsh -s `which zsh`
# install "Oh My Zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# preferences are going with dotfiles
# }


# dotfiles preferences {
# for successfully applying stow - cleanup fs
mv ~/.config/mc/ini ~/.config/mc/ini.origin
mv ~/.zshrc ~/.zshrc.origin

# stow directory
cd ../../..
stow stow_dir
# }


# prepare vim {
# install `Plug`
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# install plugins from config (supress errors) & exit
nvim --headless +PlugInstall +qall 2>/dev/null
# init treeseeter & exit (not working)
nvim --headless +TSInstallSync\ all +qall
# init coc & exit
nvim --headless +'CocInstall -sync coc-pyright coc-tsserver coc-json' +qall
# }


# install postgresql tools {
# install tools & save tools version
brew install libpq
# link all libpq binaries to the PATH
brew link --force libpq
# }
