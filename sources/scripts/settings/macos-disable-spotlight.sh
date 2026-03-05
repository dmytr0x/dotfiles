#!/usr/bin/env bash

# Quick check
mdutil -as

# Disable Spotlight indexing
#   -i off disables indexing on all volumes
#   -E erases existing index
sudo mdutil -a -i off
sudo mdutil -a -E

# Stop currently running index workers
sudo killall mds mds_stores mdworker mdworker_shared 2>/dev/null

# Quick check
mdutil -as
