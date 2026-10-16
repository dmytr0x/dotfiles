source_dir() {
  local parent="$1" pattern="$2" file

  [[ -d "$parent" ]] || return 0

  while IFS= read -r -d '' file; do
    source "$file"
  done < <(
    fd --type f --glob --full-path --absolute-path --print0 \
       --case-sensitive --no-ignore -- "$pattern" "$parent" |
      LC_ALL=C sort -z
  )
}

# Source the predefined sources. Respect the ordering and priority.
source_dir "$HOME/.config/zsh/sources" "**/*.sh"

# Source the local sources if they exist.
source_dir "$HOME/.zsources/" "**/*.sh"
