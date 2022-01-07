#!/usr/bin/env bash

exec 5>&1
push_out=$(git push -u 2>&1 | tee >(cat - >&5))

if echo "$push_out" | grep "Create pull-requests"; then
	url=$(echo "$push_out" | grep -oP "https://.*")
	qutebrowser ":open -t $url"
fi

git_repo="$(basename $(git rev-parse --show-toplevel))"
if [[ ${git_repo} =~ .*\.role ]]; then
	pushd ~/git/in/master.inventory
	require_block=$(grep -A 2 "$git_repo" ansible-requirements.yml)
	src=$(echo "$require_block" | grep -Po "(?<=src: ).*")
	version=$(echo "$require_block" | grep -Po "(?<=version: ).*")
	name=$(echo "$require_block" | grep -Po "(?<=name: ).*")
	ansible-galaxy install "$src,$version,$name" -f
	popd
fi
