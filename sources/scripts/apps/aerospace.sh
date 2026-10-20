#!/usr/bin/env bash
set -euo pipefail

# https://github.com/nikitabobko/AeroSpace
echo "🚀 Installing AeroSpace ..."

# i3-like tiling window manager for macOS
brew tap "nikitabobko/tap"
brew install --cask "nikitabobko/tap/aerospace"

# https://github.com/FelixKratz/JankyBorders
echo "🚀 Installing JankyBorders ..."

# A lightweight window border system for macOS
brew tap "FelixKratz/formulae"
brew trust --formula "felixkratz/formulae/borders"
brew install "felixkratz/formulae/borders"
