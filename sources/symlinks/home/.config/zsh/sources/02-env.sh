# --- environment

# Use the `bun` bin folder to look at binaries
export PATH="$PATH:$HOME/.bun/bin"

# Prefer UK English and use UTF-8
export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"
export LANGUAGE="en_GB.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"

# Use Neovim as the default editor, unless already configured.
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="bat"

# Pale 256-colour greys/yellow are unreadable on light backgrounds; pick by macOS appearance
# at shell start (light values match Rex's contrast-adjusted rendering).
if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
  _eza_user="38;5;222" _eza_date="38;5;248" _eza_grey="38;5;244"
else
  _eza_user="38;2;121;68;45" _eza_date="38;2;95;97;101" _eza_grey="38;2;117;118;121"
fi

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
EZA_COLORS+=":uu=$_eza_user" # User: Yellow
EZA_COLORS+=":gu=$_eza_user" # Group: Yellow
EZA_COLORS+=":da=$_eza_date" # Timestamps: Subdued Grey
EZA_COLORS+=":in=36"       # Inode number: Cyan
EZA_COLORS+=":bl=36"       # Number of blocks: Cyan

# --- Permissions ---
# Use a subtle grey for all permission bits to reduce noise.
EZA_COLORS+=":ur=$_eza_grey" # User read
EZA_COLORS+=":uw=$_eza_grey" # User write
EZA_COLORS+=":ux=$_eza_grey" # User execute
EZA_COLORS+=":gr=$_eza_grey" # Group read
EZA_COLORS+=":gw=$_eza_grey" # Group write
EZA_COLORS+=":gx=$_eza_grey" # Group execute
EZA_COLORS+=":tr=$_eza_grey" # Other read
EZA_COLORS+=":tw=$_eza_grey" # Other write
EZA_COLORS+=":tx=$_eza_grey" # Other execute
EZA_COLORS+=":su=31"       # Files with setuid bit: Red
EZA_COLORS+=":sg=31"       # Files with setgid bit: Red
EZA_COLORS+=":tw=32"       # Sticky directory: Green

# --- Punctuation and Indicators ---
EZA_COLORS+=":xx=38;5;240" # Punctuation (- .): Dim Grey
EZA_COLORS+=":xa=31"       # Extended attribute marker (@): Red

# --- File Sizes ---
# A subtle gradient from grey to white as files get larger.
EZA_COLORS+=":nb=38;5;240" # Files under 1 KB
EZA_COLORS+=":nk=$_eza_grey" # Files under 1 MB
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
unset _eza_user _eza_date _eza_grey

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
