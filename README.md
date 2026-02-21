# Dotfiles

Personal system dotfiles managed with GNU Stow.

## Requirements

- `git`
- `stow`
- `pre-commit`
- `gitleaks`

## Install dependencies (macOS/Homebrew)

```sh
brew install git stow pre-commit gitleaks
```

## Install dotfiles

Clone with SSH:
```sh
git clone git@github.com:dmytr0x/dotfiles ~/dotfiles
```

Or clone with HTTPS:
```sh
git clone https://github.com/dmytr0x/dotfiles ~/dotfiles
```

Then execute:
```sh
cd ~/dotfiles
./dotfiles install
```

## Install specific sources

```sh
cd ~/dotfiles

# Symlinks only
./dotfiles install symlink

# Brewfiles only
./dotfiles install brewfiles

# Scripts only
./dotfiles install scripts
```

## Uninstall dotfiles

```sh
cd ~/dotfiles
./dotfiles uninstall
```

## Uninstall specific sources

```sh
cd ~/dotfiles

# Symlinks only
./dotfiles uninstall symlink

# Brewfiles only
./dotfiles uninstall brewfiles
```

## Pre-commit hooks

This repo uses [pre-commit](https://pre-commit.com) to run checks before each commit, including file hygiene, shell linting, and secret detection via [gitleaks](https://github.com/gitleaks/gitleaks).

Install the tools:
```sh
brew install pre-commit gitleaks
```

Install the hooks:
```sh
cd ~/dotfiles
pre-commit install
```

To run all hooks manually against every file:
```sh
pre-commit run --all-files
```

To update hooks to their latest versions:
```sh
pre-commit autoupdate
```

To skip hooks for a single commit:
```sh
SKIP=gitleaks git commit -m "message"
```

## Notes

- Brew dependencies are defined in `sources/brewfiles/*.Brewfile`.
- Stow symlink sources are stored in `sources/symlinks/`.
- Install-time shell scripts are stored in `sources/scripts/**/*.sh`.
- `scripts` source supports `install` only.
- The install script backs up Atuin config from `~/.config/atuin/config.toml` to `~/.config/atuin/config.toml.back`.
- The install script ensures the VS Code user directory exists at `~/Library/Application Support/Code/User`.
