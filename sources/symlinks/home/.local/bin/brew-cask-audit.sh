#!/usr/bin/env bash

for c in $(brew list --cask); do
  brew info --json=v2 --cask "$c" 2>/dev/null
done | jq -sr '
  def fmt:
    if . == null then ""
    elif type == "array" then map(tostring) | join(",")
    else tostring
    end;

  map(.casks[]) |
  sort_by(.outdated) | reverse[] |
  [
    "outdated=" + (.outdated | tostring),
    .token,
    "cask=" + (.version | fmt),
    "app=" + ((.bundle_short_version | fmt) // "n/a"),
    "installed=" + (.installed | fmt)
  ] | @tsv
'
