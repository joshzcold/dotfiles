#!/usr/bin/env bash

exec 5>&1
git config --global push.default current
push_out=$(git push -u 2>&1 | tee >(cat - >&5))

echo "PUSH --> $push_out"

if echo "$push_out" | grep "pull-requests"; then
	url=$(echo "$push_out" | grep -oP "https://.*")
	qutebrowser ":open $url" &
fi

git_repo="$(basename $(git rev-parse --show-toplevel))"
if [[ ${git_repo} =~ .*\.role ]]; then
	pushd ~/git/master.inventory
	require_block=$(grep -A 2 "$git_repo" ansible-requirements.yml)
	src=$(echo "$require_block" | grep -Po "(?<=src: ).*")
	version=$(echo "$require_block" | grep -Po "(?<=version: ).*")
	name=$(echo "$require_block" | grep -Po "(?<=name: ).*")
	ansible-galaxy install "$src,$version,$name" -f
	popd
fi
