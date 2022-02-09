#!/usr/bin/env bash

LAST_NODE_LTS=16

# install js runtime
brew install node@$LAST_NODE_LTS

# add links for files from /bin
brew link node@$LAST_NODE_LTS
