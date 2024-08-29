#!/usr/bin/env bash

default_color=$(tput sgr 0)
red="$(tput setaf 1)"
yellow="$(tput setaf 3)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"

info() {
  printf "%s==> %s%s\n" "$blue" "$1" "$default_color"
}

success() {
  printf "%s==> %s%s\n" "$green" "$1" "$default_color"
}

error() {
  printf "%s==> %s%s\n" "$red" "$1" "$default_color"
}

warning() {
  printf "%s==> %s%s\n" "$yellow" "$1" "$default_color"
}

symlink() {
  local src=$1
  local dst=$2

  # Check if the source file exists
  if [ ! -e "$src" ]; then
    error "Error: Source file '$src' not found. Skipping link creation for '$dst'."
    return 1
  fi

  # Check if the symbolic link already exists
  if [ -L "$dst" ]; then
    warning "Symbolic link already exists: $dst"
  elif [ -f "$dst" ]; then
    warning "File already exists: $dst"
  else
    # Extract the directory portion of the target path
    target_dir=$(dirname "$dst")

    # Check if the target directory exists, and if not, create it
    if [ ! -d "$target_dir" ]; then
      mkdir -p "$target_dir"
      info "Created directory: $target_dir"
    fi

    # Create the symbolic link
    ln -s "$src" "$dst"
    success "Created symbolic link: $dst"
  fi
  return 0
}

get_last_brew_package_version() {
  local name=$1
  echo $(brew info "$name" --json | jq ".[0].versions.stable" | tr -d '"')
}

get_last_brew_cask_version() {
  local name=$1
  echo $(brew info --cask "$name" --json=v2 | jq ".casks[0].version" | tr -d '"')
}
