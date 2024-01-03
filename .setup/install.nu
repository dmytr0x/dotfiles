#!/usr/bin/env nu

def install_fira_code [] {
    print "\n=== Installing FiraCode fonts ..."
    
    http get --raw https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip | save --raw --force ~/Library/Caches/FiraCode.zip

    cd ~/Library/Caches
    unzip -o FiraCode.zip -d FiraCode
    
    mkdir ~/Library/Fonts/
    cp --update FiraCode/ttf/FiraCode-* ~/Library/Fonts/
    
    rm -rf FiraCode/
    rm FiraCode.zip

    print "    Done. 🎉"
}


def install [name: string, cmd: string] {
    print $"\n=== Installing ($name) ..."
    print $"    ($cmd)"
    nu -c $cmd
    print "    Done. 🎉"
}


print "Updating brew"
nu -c "brew update"

#
# Install cli tools via brew
#
for package in [
    "curl",                 # Get a file from an HTTP, HTTPS or FTP server
    "deno",                 # Secure runtime for JavaScript and TypeScript
    "difftastic",           # Diff that understands syntax
    "fd",                   # Simple, fast and user-friendly alternative to find
    "fnm",                  # Fast and simple Node.js version manager
    "fzf",                  # Command-line fuzzy finder written in Go
    # "go",                 # Open source programming language to build simple/reliable/efficient software
    "gum",                  # Tool for glamorous shell scripts
    "helix",                # Post-modern modal text editor
    "hyperfine"             # Command-line benchmarking tool
    "jq"                    # Lightweight and flexible command-line JSON processor
    "just",                 # Handy way to save and run project-specific commands
    "midnight-commander",   # Terminal-based visual file manager
    "pipx",                 # Execute binaries from Python packages in isolated environments
    "pyenv",                # Python version management
    "pyright",              # Static type checker for Python
    "ripgrep",              # Search tool like grep and The Silver Searcher
    "ruff",                 # Extremely fast Python linter, written in Rust
    "ruff-lsp",             # Language Server Protocol implementation for Ruff
    # "rust-analyzer",      # Experimental Rust compiler front-end for IDEs
    "starship",             # Cross-shell prompt for astronauts
    "tree",                 # Display directories as trees (with optional color/HTML output)
    # "watch",              # Executes a program periodically, showing output fullscreen
    "zellij",               # Pluggable terminal workspace, with terminal multiplexer as the base feature
    "zoxide"                # Shell extension to navigate your filesystem faster
] {
    install $package $"brew install --quiet ($package)"
}

#
# Install cask tools via brew
#
for package in [
    "alacritty",                 # GPU-accelerated terminal emulator
    # "alfred",                  # Application launcher and productivity software
    # "alt-tab",                 # Enable Windows-like alt-tab
    # "anki",                    # Memory training application
    "appcleaner",                # Application uninstaller
    "brave-browser",             # Web browser focusing on privacy
    "coteditor",                 # Plain-text editor for web pages, program source codes and more
    "deepl",                     # Trains AIs to understand and translate texts
    "duckduckgo",                # Web browser focusing on privacy
    "firefox",                   # Web browser
    "fork",                      # GIT client
    # "gimp",                    # Free and open-source image editor
    "hiddenbar",                 # Utility to hide menu bar items
    "iina",                      # Free and open-source media player
    "imageoptim",                # Tool to optimize images to a smaller size
    "iterm2",                    # Terminal emulator as alternative to Apple's Terminal app
    "karabiner-elements",        # Keyboard customizer
    "maccy",                     # Clipboard manager
    "megasync",                  # Syncs files between computers and MEGA Cloud drives
    # "minecraft",               # Sandbox construction video game
    "obsidian",                  # Knowledge base that works on top of a local folder of plain text Markdown files
    "pgadmin4",                  # Administration and development platform for PostgreSQL
    # "retroarch",               # Emulator frontend (OpenGL graphics API version)
    "reverso",                   # Text translation application
    "shottr",                    # Screenshot measurement and annotation tool
    # "signal",                  # Instant messaging application focusing on security
    "sloth",                     # Displays all open files and sockets in use by all running processes
    "stats",                     # System monitor for the menu bar
    "visual-studio-code",        # Microsoft Visual Studio Code
    # "vlc",                     # VLC media player
] {
    install $package $"brew install --cask --quiet ($package)"
}

#
# Install fonts
#
install_fira_code
