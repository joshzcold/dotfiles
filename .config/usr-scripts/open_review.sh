#!/usr/bin/env bash
set -eou pipefail

# Print the current URL of an already-open qutebrowser tab matching $1, if any.
# Dumping the live session is the only way to read tab state from outside
# qutebrowser; :tab-select then matches that URL as a substring.
qb_find_tab() {
	local url="$1" dump found=""

	# With no running instance there is nothing to search, and sending it a
	# command would start a browser in the foreground and block.
	compgen -G "${XDG_RUNTIME_DIR:-/run/user/$UID}/qutebrowser/ipc-*" >/dev/null || return 1

	dump="$(mktemp -t qb-session.XXXXXX.yml)"
	qutebrowser ":session-save --quiet --no-history $dump" >/dev/null 2>&1 || { rm -f "$dump"; return 1; }
	found="$(python3 - "$dump" "$url" <<-'PY'
		import sys, time, yaml

		dump, target = sys.argv[1], sys.argv[2]

		# session-save runs asynchronously in the browser process.
		for _ in range(30):
		    try:
		        session = yaml.safe_load(open(dump)) or {}
		    except yaml.YAMLError:
		        session = {}
		    if session.get('windows'):
		        break
		    time.sleep(0.1)
		else:
		    sys.exit(1)

		for window in session['windows']:
		    for tab in window.get('tabs') or []:
		        history = tab.get('history') or []
		        current = next((e for e in history if e.get('active')), history[-1] if history else None)
		        if current is None:
		            continue
		        tab_url = current.get('url', '')
		        # Prefix match so .../pull/123 finds a tab sitting on
		        # .../pull/123/files, but never on .../pull/1234.
		        rest = tab_url[len(target):] if tab_url.startswith(target) else None
		        if rest is not None and (rest == '' or rest[0] in '/?#'):
		            print(tab_url)
		            sys.exit(0)
		sys.exit(1)
	PY
	)" || found=""
	rm -f "$dump"

	[[ -n "$found" ]] || return 1
	printf '%s\n' "$found"
}

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
	if open_tab="$(qb_find_tab "$url")"; then
		qutebrowser ":tab-select $open_tab"
	else
		qutebrowser ":open -t $url"
	fi
fi
