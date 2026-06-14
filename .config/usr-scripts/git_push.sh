#!/usr/bin/env bash

push_out=$(git push -u 2>&1 | tee /dev/stderr)

if echo "$push_out" | grep -q "Create.*pull request"; then
	url=$(echo "$push_out" | grep -oP "https://.*" | head -n 1)
	echo "$url"
	if [[ -z "${SSH_CLIENT:-}" && -z "${SSH_TTY:-}" ]]; then
		qutebrowser ":open -t $url"
	fi
fi
