#!/usr/bin/evn bash

# standard libraries
export GOROOT=$HOME/.golang
if ! echo "$PATH" | grep -q "$GOROOT/bin"; then
  export PATH="$PATH:$GOROOT/bin"
fi

# third-party libraries
export GOPATH=$HOME/.gotools
if ! echo "$PATH" | grep -q "$GOPATH/bin"; then
  export PATH="$PATH:$GOPATH/bin"
fi
