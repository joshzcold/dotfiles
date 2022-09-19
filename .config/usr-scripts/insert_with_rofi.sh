#!/usr/bin/env bash
set -euo pipefail
set -x
IFS=$'\n\t'

selection=$(rofi -i -width 1000 -theme sidebar -dmenu "$@" -q < ~/.config/usr-scripts/rofi_snippets.txt)

if [[ -n "$selection" ]]; then
	delimiter="%EVAL"
	if [[ $selection =~ .*$delimiter.* ]]; then
		halfs=()
		string=$selection$delimiter
		while [[ $string ]]; do
			halfs+=( "${string%%"$delimiter"*}" )
			string=${string#*"$delimiter"}
		done
		echo "${halfs[*]}"
		# TODO any way to get each %EVAL[  ]%EVAL snip?
		halfs[1]=$(eval echo "${halfs[1]}")
		selection="$(echo "${halfs[@]}" | sed 's/ / /g')"
		echo -n "$selection" | xclip -selection clipboard
	fi
	sleep 0.1
	xdotool key ctrl+shift+v >/dev/null

fi
