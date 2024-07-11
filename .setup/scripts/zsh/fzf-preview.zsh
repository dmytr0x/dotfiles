#/usr/bin/env bash

PASSED=$1

if [ -f "${PASSED}" ]; then
  bat --color=always --style="plain" --line-range 0:500 $PASSED
else
  # /bin/ls --color=always -lah $PASSED
  eza --tree --level=2 --color=always $PASSED
fi
