#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

selection=$(rofi -i -width 1000 -dmenu "$@" -q < ~/.config/usr-scripts/rofi_snippets.txt)

if [[ -n "$selection" ]]; then
	echo -n "$selection" | xclip -selection clipboard
	sleep 0.1
	xdotool key ctrl+shift+v >/dev/null
fi
