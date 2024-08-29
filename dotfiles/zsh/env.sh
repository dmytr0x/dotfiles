# --- environment

# Prefer UK English and use UTF-8
export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"
export LANGUAGE="en_GB.UTF-8"

export TERM="xterm-256color"

export EDITOR='hx'
export PAGER="bat"

# eza colors: https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md
EZA_COLORS="reset:$LS_COLORS"                      # Reset default colors, like making everything yellow
EZA_COLORS+="da=36:"                               # Timestamps
EZA_COLORS+="ur=0:uw=0:ux=0:ue=0:"                 # User permissions
EZA_COLORS+="gr=0:gw=0:gx=0:"                      # Group permissions
EZA_COLORS+="tr=0:tw=0:tx=0:"                      # Other permissions
EZA_COLORS+="xa=0:"                                # Extended attribute marker ('@')
EZA_COLORS+="xx=38;5;240:"                         # Punctuation ('-')
EZA_COLORS+="nb=38;5;240:"                         # Files under 1 KB
EZA_COLORS+="nk=0:"                                # Files under 1 MB
EZA_COLORS+="nm=37:"                               # Files under 1 GB
EZA_COLORS+="ng=38;5;250:"                         # Files under 1 TB
EZA_COLORS+="nt=38;5;255:"                         # Files over 1 TB
EZA_COLORS+="do=32:*.md=32:"                       # Documents
EZA_COLORS+="co=35:*.zip=35:"                      # Archives
EZA_COLORS+="tm=38;5;242:cm=38;5;242:.*=38;5;242:" # Hidden and temporary files
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
