#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Installing podman desktop ..."
brew install --cask podman-desktop

echo "🚀 Create a docker alias ..."
ln -s $(which podman) ~/.local/bin/docker

echo ""
echo "To disable Podman’s compose warning"
echo "Add the following line under [engine] in ~/.config/containers/containers.conf"
echo "compose_warning_logs = false"
echo ""
echo "After that you can run the `docker compose --version` without any warnings"
