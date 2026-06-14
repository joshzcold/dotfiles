#!/usr/bin/env bash
set -eou pipefail

remote="$(git config --get remote.origin.url)"
open_jenkins=false
if [[ "${1:-}" == "--jenkins" || "${1:-}" == "jenkins" || "${1:-}" == "-j" ]]; then
	open_jenkins=true
fi

if [[ "$open_jenkins" == true ]]; then
	branch_name="$(git rev-parse --abbrev-ref HEAD)"
	branch_path="${branch_name//\//%2F}"
	url="https://jenkins-build.secmet.co/job/Github/job/sm/job/${branch_path}/"
elif [[ "$remote" =~ .*bitbucket.* ]]; then
	project_name="$(echo "$remote" | rev | cut -d/ -f2 | rev)"
	repo_name="$(basename -s .git "$remote")"
	branch_name="$(git rev-parse --abbrev-ref HEAD)"
	url="https://bitbucket.secmet.co/projects/${project_name}/repos/${repo_name}/pull-requests?create&sourceBranch=refs/heads/${branch_name}"
elif [[ "$remote" =~ .*github.* ]]; then
	repo_name="$(basename -s .git "$remote")"
	branch_name="$(git rev-parse --abbrev-ref HEAD)"
	project_name="$(echo "$remote" | rev | cut -d: -f1 | cut -d/ -f2 | rev)"
	if command -v gh >/dev/null 2>&1; then
		if pr_url="$(gh pr view --json url -q .url 2>/dev/null)"; then
			url="$pr_url"
		else
			url="https://github.com/${project_name}/${repo_name}/compare/${branch_name}?expand=1"
		fi
	else
		url="https://github.com/${project_name}/${repo_name}/compare/${branch_name}?expand=1"
	fi
else
	echo "$0: Unknown remote: ${remote}" >&2
	exit 1
fi

echo "$url"
if [[ -z "${SSH_CLIENT:-}" && -z "${SSH_TTY:-}" ]]; then
	qutebrowser ":open -t $url"
fi
