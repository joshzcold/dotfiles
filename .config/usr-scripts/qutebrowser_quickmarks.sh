#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# quickmarks_file="$HOME/.config/qutebrowser/quickmarks"
quickmarks_file="$HOME/.vieb/quickmarks"

if [[ ! -f "$quickmarks_file" ]]; then
	echo "Quickmarks file not found: $quickmarks_file" >&2
	exit 1
fi

selection=$(cat "$quickmarks_file" |
	fzf --multi --delimiter $'\t' --with-nth 1 --prompt "Quickmarks > ")

if [[ -z "$selection" ]]; then
	exit 0
fi

urls=()
while IFS=$'\n' read -r line; do
	url=$(echo "$line" | rev | cut --delimiter=' ' --fields=-1 | rev)
	if [[ -n "$url" ]]; then
		# qutebrowser ":open -t $url"
		urls+=("$url")
	fi
done <<<"$selection"

# One hand-off for every pick, since each Vieb launch takes about a second.
if [[ ${#urls[@]} -gt 0 ]]; then
	vieb.sh "${urls[@]}"
fi
