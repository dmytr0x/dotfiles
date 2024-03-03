#!/usr/bin/env nu

let CACHE_DIR = "~/Library/Caches"

def group_start [msg: string] {
    print $"\n=== Run 🚀 ($msg) ..."
}

def group_end [msg: string] {
    print $"    Done 🎉  ($msg)"
}

def execute [cmd: string] {
    group_start $cmd
    nu -c $cmd
    group_end $cmd
}

def brew_install [package: string] {
    execute $"brew install --quiet ($package)"
}

def brew_install_cask [package: string] {
    execute $"brew install --cask --quiet ($package)"
}

def install_python [] {
    let title = "installing python"
    group_start $title

    for package in [
        "pipx",        # Execute binaries from Python packages in isolated environments
        "pyenv",       # Python version management
        "pyright",     # Static type checker for Python
        "ruff",        # Extremely fast Python linter and formatter
        "ruff-lsp"     # Language Server Protocol implementation for Ruff
    ] {
        brew_install $package
    }

    execute "pyenv install --skip-existing 3.10"
    execute "pyenv install --skip-existing 3.11"
    execute "pyenv install --skip-existing 3.12"
    nu -c "pyenv global 3.12"

    pipx ensurepath
    pipx install ipython --python $"($env.HOME)/.pyenv/shims/python3"

    curl -sSL https://install.python-poetry.org | python3 -

    group_end $title
}

def install_rust [] {
    let title = "installing rust"
    group_start $title
    cd $CACHE_DIR
    http get --raw https://sh.rustup.rs | save --raw --force rustup.sh
    nu -c "sh rustup.sh -y --no-modify-path --profile default --component rust-analyzer"
    rm rustup.sh
    group_end $title
}

def install_go [] {
    let title = "installing go"
    group_start $title
    cd $CACHE_DIR
    let last_version = http get https://go.dev/dl/?mode=json | first | get version 
    let os_type = uname | str downcase
    let platform_type = uname -m | str downcase
    http get --raw $"https://go.dev/dl/($last_version).($os_type)-($platform_type).tar.gz" | save --raw --force golang.tar.gz
    tar -xzf golang.tar.gz
    mv ./go ~/.golang
    mkdir ~/.go
    go install golang.org/x/tools/gopls@latest
    rm golang.tar.gz
    group_end $title
}

def install_bun [] {
    let title = "installing bun"
    group_start $title
    nu -c "brew tap oven-sh/bun"
    brew_install "bun"
    group_end $title
}

def install_cli_packages [] {
    for package in [
        # === general tools
        "curl",                 # Get a file from an HTTP, HTTPS or FTP server
        "fzf",                  # Command-line fuzzy finder written in Go
        "broot"                 # New way to see and navigate directory trees
        "bat",                  # Clone of cat command with syntax highlighting and Git integration
        "fd",                   # Simple, fast and user-friendly alternative to find
        "jq"                    # Lightweight and flexible command-line JSON processor
        "tree",                 # Display directories as trees (with optional color/HTML output)
        "zoxide"                # Shell extension to navigate your filesystem faster
        "zellij",               # Pluggable terminal workspace, with terminal multiplexer as the base feature
        "ripgrep",              # Search tool like grep and The Silver Searcher
        "starship",             # Cross-shell prompt for astronauts
        "hyperfine"             # Command-line benchmarking tool
        "midnight-commander",   # Terminal-based visual file manager
        "ollama",               # Create, run, and share large language models (LLMs)
        #"watch",               # Executes a program periodically, showing output fullscreen
        # === programming tools
        "deno",                 # Secure runtime for JavaScript and TypeScript
        "helix",                # Post-modern modal text editor
        "fnm",                  # Fast and simple Node.js version manager
        #"gum",                 # Tool for glamorous shell scripts
        "just",                 # Handy way to save and run project-specific commands
        "difftastic",           # Diff that understands syntax
    ] {
        brew_install $package
    }
}

def install_cask_packages [] {
    for package in [
        # === general tools
        "alfred",                    # Application launcher and productivity software
        "alt-tab",                   # Enable Windows-like alt-tab
        # "anki",                    # Memory training application
        "appcleaner",                # Application uninstaller
        "firefox",                   # Web browser
        "duckduckgo",                # Web browser focusing on privacy
        "brave-browser",             # Web browser focusing on privacy
        "deepl",                     # Trains AIs to understand and translate texts
        "reverso",                   # Text translation application
        # "gimp",                    # Free and open-source image editor
        "hiddenbar",                 # Utility to hide menu bar items
        "imageoptim",                # Tool to optimize images to a smaller size
        "maccy",                     # Clipboard manager
        "shottr",                    # Screenshot measurement and annotation tool
        "megasync",                  # Syncs files between computers and MEGA Cloud drives
        "obsidian",                  # Knowledge base that works on top of a local folder of plain text Markdown files
        # "signal",                  # Instant messaging application focusing on security
        # "retroarch",               # Emulator frontend (OpenGL graphics API version)
        "stats",                     # System monitor for the menu bar
        #"iina",                     # Free and open-source media player
        "vlc",                       # VLC media player
        # === programming tools
        "amethyst"                   # Automatic tiling window manager similar to xmonad
        "fork",                      # GIT client
        "iterm2",                    # Terminal emulator as alternative to Apple's Terminal app
        "wezterm",                   # GPU-accelerated cross-platform terminal emulator and multiplexer
        "alacritty",                 # GPU-accelerated terminal emulator
        "coteditor",                 # Plain-text editor for web pages, program source codes and more
        "pgadmin4",                  # Administration and development platform for PostgreSQL
        "sloth",                     # Displays all open files and sockets in use by all running processes
        "visual-studio-code",        # Microsoft Visual Studio Code
        # "superkey",                # Simple and powerful keyboard enhancement on macOS
        # "rectangle-pro",           # Window snapping tool
    ] {
        brew_install_cask $package
    }
}

def install_fira_code [] {
    let title = "FiraCode fonts installation"

    group_start $title

    cd $CACHE_DIR

    http get --raw https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip | save --raw --force FiraCode.zip

    unzip -o FiraCode.zip -d FiraCode

    mkdir ~/Library/Fonts/
    cp --update FiraCode/ttf/FiraCode-* ~/Library/Fonts/

    rm -rf FiraCode/
    rm FiraCode.zip

    group_end $title
}

def setup_macos [] {
    for cmd in [
        # Increase keyboard key repeat rate
        "defaults write -g InitialKeyRepeat -int 10",  # normal minimum is 15 (225 ms)
        "defaults write -g KeyRepeat -int 1",          # normal minimum is 2 (30 ms) 
    ] {
        nu -c $cmd
    }
}

# TODO: run these commands before running this script
# nu -c "source ~/.zprofile"
# nu -c "source ~/.zshrc"

setup_macos

execute "brew update"

install_cli_packages
install_cask_packages
install_python
install_rust
install_go
install_bun
install_fira_code
