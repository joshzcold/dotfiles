#!/usr/bin/env bash
# shellcheck disable=SC2068
# Recursive function that will
# - List all the secrets in the given $path
# - Call itself for all path values in the given $path

CACHE_FILE="$HOME/.cache/vault_names"
# Reset
Color_Off='\033[0m' # Text Reset

export VAULT_ADDR="https://vault.secmet.co:8200"

# Regular Colors
Yellow='\033[0;33m' # Yellow
PS4="${Yellow}>>>${Color_Off} "


SELECTION_CMD=(dmenu -l 20)
CLIPBOARD_CMD=(xclip -selection clipboard)
SED_COMMAND="sed"

if [[ "$(uname -s)" == "Darwin" ]]; then
	SELECTION_CMD=(choose -m)
	CLIPBOARD_CMD=(pbcopy)
SED_COMMAND="gsed"
fi


function notify(){
	if [[ "$(uname -s)" == "Darwin" ]]; then
		osascript -e "display notification \"$1\" with title \"vault-clipboard.sh\""
	else
		notify-send -h string:x-canonical-private-synchronous:anything "$1"
	fi
}

touch "$CACHE_FILE"
VAULT_TOKEN=$(cat $HOME/.vault-token)
export VAULT_TOKEN


echo "$VAULT_TOKEN" | vault login - || notify "Vault login failed"


function traverse() {
	path="${1}"

	result=$(vault kv list -format=json "$path" 2>&1)

	status=$?
	if [ ! $status -eq 0 ]; then
		echo "$path $status"
		if [[ $result =~ "permission denied" ]]; then
			return 1
		fi
		if [ ! "$result" = "{}" ]; then
			echo >&2 "No keys ${path} $result"
		fi
	fi

	for secret in $(echo "$result" | jq -r '.[]'); do
		if [[ "$secret" == */ ]]; then
			echo "TRAVERSE" "$path$secret" >/dev/stderr
			traverse "$path$secret" &
		else
			if ! grep -qxF "$path$secret" "${CACHE_FILE}"; then
				echo "$path$secret" >>"${CACHE_FILE}"
				echo "ADD" "$path$secret" >/dev/stderr
			else
				echo "FOUND IN CACHE" "$path$secret" >/dev/stderr
			fi
		fi
	done
}

mapfile -t -d $'\n' vaults < <(vault secrets list -format=json | jq -r 'to_entries[] | select(.value.type =="kv") | .key')

notify "Looking up secrets..."
for vault in "${vaults[@]}"; do
	traverse "$vault" &
done

function max4 {
	while [ "$(jobs | wc -l)" -ge 4 ]; do
		true
	done
}

set -e
set -o pipefail

function lookup_secret_folder() {

	json=$(vault kv get -format=json "${selection}")

	echo "$json" | jq -r '.data.data | keys' &>/dev/null || {
		notify "No secrets found..."
		exit 1
	}
}

function lookup_secret() {
	secret=$(echo "$json" | jq -r --arg secret_key "${secret_selection}" '.data.data[$secret_key]')
	notify "Copied key: ${selection}:${secret_selection} to clipboard"
	printf "%s" "$secret" | ${CLIPBOARD_CMD[@]}

	# Make sure last selected appears at top of list
	${SED_COMMAND} -i "\#^.*${selection}:${secret_selection}\$#d" "$CACHE_FILE"
	echo "$selection:${secret_selection}" >>"$CACHE_FILE"
}

selection=$(tac "$CACHE_FILE" | ${SELECTION_CMD[@]})

if [[ ! "$selection" =~ .*:.* ]]; then
	lookup_secret_folder
	secret_selection=$(echo "$json" | jq -r '.data.data | keys | .[]' | ${SELECTION_CMD[@]})
else
	secret_selection=$(echo "$selection" | rev | cut -d: -f1 | rev)
	selection=$(echo "$selection" | cut -d: -f1)
	lookup_secret_folder
fi

lookup_secret
