#!/usr/bin/env bash
set -e
set -o pipefail

SESSION_CACHE_FILE=~/.bw-session
USER_NAME_CACHE_FILE=~/.bw-user
BW_USERNAME=
SELECTION_ID=
SELECTION_NAME=
SELECTION_URI=
SELECTION_USERNAME=
SELECTION_PASS=

get_required_apps() {
	needed=(jq bw dmenu xclip notify-send)
	for need in "${needed[@]}"; do
		if ! command -v "$need" >/dev/null; then
			echo "Missing  required app: ${need}"
			exit 1
		fi
	done
}

function get_session() {
	local status
	status=$(bw status | jq '.status')

	if [ "$status" = "unauthenticated" ] || [ ! -f "$SESSION_CACHE_FILE" ]; then
		notify-send -h string:x-canonical-private-synchronous:anything "Doing login..."
		bw logout || true
		if [ ! -f "$USER_NAME_CACHE_FILE" ]; then
			BW_USERNAME=$(: | dmenu -i -p "Username:")
		else
			BW_USERNAME=$(cat "$USER_NAME_CACHE_FILE")
		fi
		echo "$BW_USERNAME" >"$USER_NAME_CACHE_FILE"

		# NOTE: this is just changing the color of the input to match the background of demnu
		# This isn't actually obscuring the password
		BW_PASSWORD=$(: | dmenu -i -p "Password ($BW_USERNAME):" -nb "#222222" -nf "#222222")

		NEW_SESSION_KEY=$(bw login "${BW_USERNAME}" "${BW_PASSWORD}" --raw || true)
		echo "$NEW_SESSION_KEY" >"$SESSION_CACHE_FILE"
	fi
	BW_SESSION=$(cat "$SESSION_CACHE_FILE")
	export BW_SESSION
}

function select_items() {
	echo "$BW_SESSION"
	notify-send -h string:x-canonical-private-synchronous:anything "Getting items..."

	local items
	items=$(bw --nointeraction list items)

	if [ -z "$items" ]; then
		return 1
	fi
	SELECTION=$(
		echo "$items" |
			jq -r '.[] | [.name, .login.username, .login.uris[0].uri, .id] | join(",")' |
			dmenu -l 25
	)

	IFS=, read SELECTION_NAME SELECTION_USERNAME SELECTION_URI SELECTION_ID <<<${SELECTION}
}

function get_pass() {
	notify-send -h string:x-canonical-private-synchronous:anything "Looking up Password..."
	SELECTION_PASS=$(bw --nointeraction get item "${SELECTION_ID}" | jq -r '.login.password')
	echo "$SELECTION_PASS" | xclip -selection clipboard
	notify-send -h string:x-canonical-private-synchronous:anything "Got password: ${SELECTION_USERNAME} ${SELECTION_NAME} ${SELECTION_URI}"
}

notify-send -h string:x-canonical-private-synchronous:anything "Bitwarden Get Password..."
get_session

select_items || {
	notify-send -h string:x-canonical-private-synchronous:anything "Need to re-authenticate..."
	rm "$SESSION_CACHE_FILE"
	get_session
	select_items || exit 1
}

get_pass
