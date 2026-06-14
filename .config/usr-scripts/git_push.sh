#!/usr/bin/env bash

exec 5>&1
push_out=$(git push -u 2>&1 | tee >(cat - >&5))

if echo "$push_out" | grep "Create.*pull request"; then
	url=$(echo "$push_out" | grep -oP "https://.*" | head -n 1)
	if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
		printf "\033]52;c;%s\a" "$(printf '%s' "$url" | base64 -w0)"
		echo -e "\n\033[1;32m  ✔ URL copied to clipboard\033[0m \033[2m(SSH session detected)\033[0m\n  \033[1;36m$url\033[0m\n"
	else
		qutebrowser ":open -t $url"
	fi
fi
