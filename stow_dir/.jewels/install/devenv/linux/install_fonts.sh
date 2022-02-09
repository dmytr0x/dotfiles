#!/usr/bin/env bash

echo "---- install firacode" && sudo apt install fonts-firacode && \
echo "---- update font cache" && fc-cache -f
