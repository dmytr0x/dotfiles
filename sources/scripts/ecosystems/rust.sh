#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Installing rust ..."
mise install rust

echo "🚀 Installing rust-analyzer ..."
mise exec --quiet rust -- cargo install rust-analyzer
