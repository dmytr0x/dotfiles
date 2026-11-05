# Dotfiles

Personal system dotfiles managed with GNU Stow.

## Requirements

- `git`
- `uv` (Python package runner — handles Python 3.13+ automatically)
- `stow`
- `pre-commit`
- `gitleaks`

## Install dependencies (macOS/Homebrew)

```sh
brew install git uv stow pre-commit gitleaks
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
uv run dotfiles.py install
```

## Install specific sources

```sh
cd ~/dotfiles

# Symlinks only
uv run dotfiles.py install symlinks

# Brewfiles only
uv run dotfiles.py install brewfiles

# Scripts only
uv run dotfiles.py install scripts
```

## Uninstall dotfiles

```sh
cd ~/dotfiles
uv run dotfiles.py uninstall
```

## Uninstall specific sources

```sh
cd ~/dotfiles

# Symlinks only
uv run dotfiles.py uninstall symlinks

# Brewfiles only
uv run dotfiles.py uninstall brewfiles
```

## Worktrunk profiles

Worktrunk has two complete, versioned configurations:

- `sources/symlinks/home/.config/worktrunk/config.work.toml`: work ticket subjects and the existing Claude command.
- `sources/symlinks/home/.config/worktrunk/config.personal.toml`: Conventional Commits and the same Claude command, editable independently.

Both profiles include the worktree layout and lifecycle hooks. Keep those settings in sync when changing shared behavior.

Zsh defaults to the personal profile through `WORKTRUNK_CONFIG_PATH`.

To select the work profile on a machine, create a local shell file outside this repository:

```sh
mkdir -p ~/.zsources
cat > ~/.zsources/worktrunk.sh <<'EOF'
export WORKTRUNK_CONFIG_PATH="$HOME/.config/worktrunk/config.work.toml"
EOF
source ~/.zshrc
```

On the personal machine, leave the default. Zsh loads `~/.zsources/**/*.sh` after the shared shell configuration, so each machine keeps its own selection across dotfiles updates.

The selector applies to Worktrunk processes launched from that shell, including `wt step commit`, `wt step squash`, and `wt merge`. Other launchers must set `WORKTRUNK_CONFIG_PATH` themselves or pass `--config` to select either profile.

After installing or updating the symlinks, inspect the selected configuration:

```sh
wt config show
```

To inspect either profile explicitly:

```sh
wt --config "$HOME/.config/worktrunk/config.work.toml" config show
wt --config "$HOME/.config/worktrunk/config.personal.toml" config show
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
- Symlink directory behavior is configured in `sources/symlinks.toml`.
- Install-time shell scripts are stored in `sources/scripts/**/*.sh`.
- `scripts` source supports `install` only.
- Existing targets that conflict with a source are renamed with a `.backup` suffix before linking. Existing backups are preserved by adding a numeric suffix.
