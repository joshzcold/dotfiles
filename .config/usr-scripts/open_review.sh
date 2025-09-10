#!/usr/bin/env bash
set -eou pipefail
remote="$(git config --get remote.origin.url)"

if [[ "$remote" =~ .*bitbucket.* ]]; then
	project_name="$(echo "$remote" | rev | cut -d/ -f2 | rev)"
	repo_name="$(basename -s .git "$remote")"
	branch_name="$(git rev-parse --abbrev-ref HEAD)"

	url="https://bitbucket.secmet.co/projects/${project_name}/repos/${repo_name}/pull-requests?create&sourceBranch=refs/heads/${branch_name}"
elif [[ "$remote" =~ .*github.* ]]; then
	repo_name="$(basename -s .git "$remote")"
	branch_name="$(git rev-parse --abbrev-ref HEAD)"
	project_name="$(echo "$remote" | rev | cut -d: -f1 | cut -d/ -f2 |  rev)"
	url="https://github.com/${project_name}/${repo_name}/compare/${branch_name}?expand=1"
else
	notify-send "$0: Unknown remote for this script: ${remote}"
fi

qutebrowser ":open -t $url"
