#!/usr/bin/env bash

export LANG=en_US.UTF-8

selection=$(
    cat "$HOME/.config/usr-scripts/emoji" | \
    choose | \
    cut -d= -f2
)

[[ -z "$selection" ]] && exit 1

printf "%s" "$selection" | pbcopy
