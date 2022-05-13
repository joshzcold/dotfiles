#!/usr/bin/env bash
set -eou pipefail
project_name="$(git config --get remote.origin.url | rev | cut -d/ -f2 | rev)"
repo_name="$(basename -s .git $(git config --get remote.origin.url))"
branch_name="$(git rev-parse --abbrev-ref HEAD)"

url="https://bitbucket.secmet.co/projects/${project_name}/repos/${repo_name}/pull-requests?create&sourceBranch=refs/heads/${branch_name}"
qutebrowser ":open -t $url"
