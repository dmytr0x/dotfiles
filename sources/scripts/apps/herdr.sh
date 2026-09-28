#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Installing herdr ..."

# Agent multiplexer that lives in your terminal
brew install herdr

echo "🚀 Installing herdr plugins ..."
# post create
herdr plugin install dmytr0x/herdr-post-create
# task picker
herdr plugin install dmytr0x/herdr-task-picker
# herdr tokens
herdr plugin install dmytr0x/dmytr0x-herdr-tokens
herdr plugin action invoke dmytr0x-herdr-tokens.start
#

echo "🚀 Reload herdr config ..."
herdr server reload-config
