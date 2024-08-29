#!/usr/bin/env bash

source ./dotfiles/zsh/golang.sh

VERSION="1.23.0"
ARCHIVE="go.tar.gz"

info "🚀 Installing golang $VERSION ..."

if [ ! -d "$GOROOT" ]; then
  curl -sLo $ARCHIVE https://go.dev/dl/go$VERSION.darwin-arm64.tar.gz
  tar -xzf $ARCHIVE -C $HOME
  rm -f $ARCHIVE
  mv $HOME/go $GOROOT
fi

info "🚀 Installing golang tools ..."
go install "golang.org/x/tools/gopls@latest"
