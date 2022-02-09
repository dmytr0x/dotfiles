#!/usr/bin/env bash

# install postgresql tools
brew install libpq

# link all libpq binaries to the PATH
brew link --force libpq
