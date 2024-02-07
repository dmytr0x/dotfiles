#/usr/bin/env zsh

PASSED=$1

if [ -f "${PASSED}" ]; then
	bat --color=always --style="plain" $PASSED
else
	/bin/ls --color=always -lah $PASSED
fi
