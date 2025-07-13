#!/usr/bin/env bash

source ./core.sh

# Install golang
mise install go

info "🚀 Installing golang tools ..."
go install "golang.org/x/tools/gopls@latest"
