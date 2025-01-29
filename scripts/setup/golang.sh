#!/usr/bin/env bash

source ./dotfiles/zsh/golang.sh

VERSION=$(curl -s https://go.dev/dl/?mode=json | jq -r '.[0].version')
ARCHIVE="go.tar.gz"

info "🚀 Installing golang $VERSION ..."

if [ ! -d "$GOROOT" ]; then
  curl -sLo $ARCHIVE https://go.dev/dl/$VERSION.darwin-arm64.tar.gz
  tar -xzf $ARCHIVE -C $HOME
  rm -f $ARCHIVE
  mv $HOME/go $GOROOT
fi

info "🚀 Installing golang tools ..."
go install "golang.org/x/tools/gopls@latest"
