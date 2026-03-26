#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Installing golang..."
mise install go

echo "🚀 Installing golang tools ..."
go install "golang.org/x/tools/gopls@latest"
