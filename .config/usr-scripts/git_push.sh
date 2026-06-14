#!/usr/bin/env bash

exec 5>&1
push_out=$(git push -u 2>&1 | tee >(cat - >&5))

if echo "$push_out" | grep "Create.*pull request"; then
	url=$(echo "$push_out" | grep -oP "https://.*" | head -n 1)
	if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
		printf "\033]52;c;%s\a" "$(printf '%s' "$url" | base64 -w0)"
	else
		qutebrowser ":open -t $url"
	fi
fi
