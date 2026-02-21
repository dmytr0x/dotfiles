# --- environment

# Prefer UK English and use UTF-8
export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"
export LANGUAGE="en_GB.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export TERM="xterm-256color"

# Use helix if no other editor is configured
export EDITOR="${EDITOR:-hx}"
export VISUAL="${VISUAL:-hx}"
export PAGER="bat"

# Start with a clean slate, removing any inherited LS_COLORS.
EZA_COLORS="reset"

# --- File Kinds (without bold) ---
EZA_COLORS+=":di=34" # Directories: Blue
EZA_COLORS+=":ln=35" # Symlinks: Mauve
EZA_COLORS+=":pi=33" # Pipes: Peach
EZA_COLORS+=":so=35" # Sockets: Mauve
EZA_COLORS+=":bd=33" # Block devices: Peach
EZA_COLORS+=":cd=33" # Char devices: Peach
EZA_COLORS+=":ex=32" # Executables: Green

# --- Metadata ---
EZA_COLORS+=":uu=38;5;222" # User: Yellow
EZA_COLORS+=":gu=38;5;222" # Group: Yellow
EZA_COLORS+=":da=38;5;248" # Timestamps: Subdued Grey
EZA_COLORS+=":in=36"       # Inode number: Cyan
EZA_COLORS+=":bl=36"       # Number of blocks: Cyan

# --- Permissions ---
# Use a subtle grey for all permission bits to reduce noise.
EZA_COLORS+=":ur=38;5;244" # User read
EZA_COLORS+=":uw=38;5;244" # User write
EZA_COLORS+=":ux=38;5;244" # User execute
EZA_COLORS+=":gr=38;5;244" # Group read
EZA_COLORS+=":gw=38;5;244" # Group write
EZA_COLORS+=":gx=38;5;244" # Group execute
EZA_COLORS+=":tr=38;5;244" # Other read
EZA_COLORS+=":tw=38;5;244" # Other write
EZA_COLORS+=":tx=38;5;244" # Other execute
EZA_COLORS+=":su=31"       # Files with setuid bit: Red
EZA_COLORS+=":sg=31"       # Files with setgid bit: Red
EZA_COLORS+=":tw=32"       # Sticky directory: Green

# --- Punctuation and Indicators ---
EZA_COLORS+=":xx=38;5;240" # Punctuation (- .): Dim Grey
EZA_COLORS+=":xa=31"       # Extended attribute marker (@): Red

# --- File Sizes ---
# A subtle gradient from grey to white as files get larger.
EZA_COLORS+=":nb=38;5;240" # Files under 1 KB
EZA_COLORS+=":nk=38;5;244" # Files under 1 MB
EZA_COLORS+=":nm=37"       # Files under 1 GB
EZA_COLORS+=":ng=37"       # Files over 1 GB (no longer bold)

# --- Git Status ---
# Uses short, two-character codes (e.g., "M-", "-A").
EZA_COLORS+=":gm=33"       # Git Modified: Peach
EZA_COLORS+=":ga=32"       # Git New: Green
EZA_COLORS+=":gd=31"       # Git Deleted: Red
EZA_COLORS+=":gr=31"       # Git Renamed: Red
EZA_COLORS+=":gi=38;5;244" # Git Ignored: Dim Grey

# --- File Globs ---
# Assign colors to specific file extensions.
EZA_COLORS+=":*.md=36"   # Markdown: Cyan
EZA_COLORS+=":*.toml=36" # TOML: Cyan
EZA_COLORS+=":*.zip=33"  # Archives: Peach
EZA_COLORS+=":*.tar=33"  # Archives: Peach
EZA_COLORS+=":*.gz=33"   # Archives: Peach
EZA_COLORS+=":*.tgz=33"  # Archives: Peach

# Export the final variable for eza to use.
export EZA_COLORS

# --- privacy

# next.js: https://nextjs.org/telemetry
export NEXT_TELEMETRY_DISABLED=1

# homebrew: https://docs.brew.sh/Manpage#environment
export HOMEBREW_INSTALL_BADGE='☕'
export HOMEBREW_NO_GITHUB_API=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_NO_ENV_HINTS=1
