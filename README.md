# Dotfiles

## How to initialize new dotfiles repo
```sh
cd

git init --bare $HOME/.dotfiles

echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
source ~/.zshrc

dotfiles config --local status.showUntrackedFiles no

# check how it works
dotfiles status
```

## How to clone dotfiles to a new machine
```sh
cd

echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
source ~/.zshrc

git clone --bare https://github.com/dmytr0x/dotfiles.git $HOME/.dotfiles

dotfiles config --local status.showUntrackedFiles no

# Carefully, it'll rewrite some of the configuration files
dotfiles checkout --forced
```
