#!/usr/bin/env bash

exec 5>&1
push_out=$(git push -u 2>&1 | tee >(cat - >&5))

if echo "$push_out" | grep "Create pull request"; then
	url=$(echo "$push_out" | grep -oP "https://.*")
	qutebrowser ":open -t $url"
fi
