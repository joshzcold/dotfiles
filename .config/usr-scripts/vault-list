#!/usr/bin/env bash

# Recursive function that will
# - List all the secrets in the given $path
# - Call itself for all path values in the given $path
function traverse {
    local readonly path="$1"

    result=$(vault kv list -format=json $path 2>&1)

    status=$?
    if [ ! $status -eq 0 ];
    then
        if [[ $result =~ "permission denied" ]]; then
            return
        fi
        >&2 echo "$result"
    fi

    for secret in $(echo "$result" | jq -r '.[]'); do
        if [[ "$secret" == */ ]]; then
            traverse "$path$secret"
        else
            echo "$path$secret"
        fi
    done
}

# Iterate on all kv engines or start from the path provided by the user
if [[ "$1" ]]; then
    # Make sure the path always end with '/'
    vaults=("${1%"/"}/")
else
    vaults=$(vault secrets list -format=json | jq -r 'to_entries[] | select(.value.type =="kv") | .key')
fi

for vault in $vaults; do
    traverse $vault
done
