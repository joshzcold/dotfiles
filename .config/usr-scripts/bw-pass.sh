#!/usr/bin/env bash

set -e
set -o pipefail

SESSION_CACHE_FILE=~/.bw-session
SELECTION_ID=
SELECTION_NAME=
SELECTION_URI=
SELECTION_USERNAME=
SELECTION_PASS=

get_required_apps() {
	needed=(jq bw fzf xclip)
	for need in "${needed[@]}"; do
		if ! command -v "$need" >/dev/null; then
			echo "Missing  required app: ${need}"
			exit 1
		fi
	done
}

function get_session() {
	status=$(bw status | jq '.status')
	NEW_SESSION_KEY=$(bw login --raw || true)

	if [ -n "$NEW_SESSION_KEY" ]; then
		echo "$NEW_SESSION_KEY" >"$SESSION_CACHE_FILE"
	elif [ "$status" = "unauthenticated" ]; then
		bw logout
		NEW_SESSION_KEY=$(bw login --raw || true)
	fi
	BW_SESSION=$(cat "$SESSION_CACHE_FILE")
	export BW_SESSION
}

function select_items() {
	SELECTION=$(
		bw --nointeraction list items |
			jq -r '.[] | [.name, .login.username, .login.uris[0].uri, .id] | join(",")' |
			fzf --bind 'ctrl-b:reload(bw --nointeraction sync)' --prompt 'Ctrl+B to sync -> '
	)

	IFS=, read SELECTION_NAME SELECTION_USERNAME SELECTION_URI SELECTION_ID <<<${SELECTION}
}

function get_pass() {
	SELECTION_PASS=$(bw --nointeraction get item "${SELECTION_ID}" | jq -r '.login.password')
	echo "$SELECTION_PASS" | xclip -selection clipboard
	notify-send "Got password: ${SELECTION_USERNAME} ${SELECTION_NAME} ${SELECTION_URI}"
}

get_session

select_items || {
	get_session
	select_items || exit 1
}

get_pass
