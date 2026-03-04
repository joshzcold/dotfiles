#!/bin/bash

# Ensure dependencies and correct version are present
MIN_GH_VERSION="2.74.0"
for cmd in gh fzf parallel; do
	if ! command -v "$cmd" &>/dev/null; then
		echo "Error: '$cmd' is not installed."
		exit 1
	fi
done

# Check gh version
current_gh_version=$(gh version | head -n1 | awk '{print $3}')
if [[ "$(printf '%s\n%s' "$MIN_GH_VERSION" "$current_gh_version" | sort -V | head -n1)" != "$MIN_GH_VERSION" ]]; then
	echo "Error: 'gh' version $current_gh_version is too old. Minimum required is $MIN_GH_VERSION."
	exit 1
fi

# Define colors
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
NC=$'\033[0m' # No Color
# BOLD='\e[1m' # Unused

# Spinner function
spinner() {
	local delay=0.1
	local spinstr='|/-\'
	local message="${1:-Fetching PRs...}"
	echo -n "$message "
	while true; do
		local temp=${spinstr#?}
		printf " [%c]  " "$spinstr"
		local spinstr=$temp${spinstr%"$temp"}
		sleep $delay
		printf "\b\b\b\b\b\b"
	done
}

start_spinner() {
	spinner "$1" &
	SPIN_PID=$!
}

stop_spinner() {
	if [ -n "$SPIN_PID" ] && kill -0 "$SPIN_PID" 2>/dev/null; then
		kill "$SPIN_PID" >/dev/null 2>&1
		wait "$SPIN_PID" 2>/dev/null
		printf "\r\033[K" # Clear the spinner line
	fi
}

# Temporary files cleanup trap
cleanup() {
	if [ -n "$FIFO_FILE" ]; then
		rm -f "$FIFO_FILE"
	fi
	# Ensure spinner is stopped if script exits early
	stop_spinner
}
trap cleanup EXIT

# Ensure user is logged in to gh
if ! gh auth status &>/dev/null; then
	echo "Not logged in to GitHub CLI. Starting login..."
	gh auth login
fi

ORG="SecurityMetrics"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/github_reviews"
CACHE_FILE="$CACHE_DIR/prs.txt"
USER_CACHE_FILE="$CACHE_DIR/user.txt"
AUTH_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/gh/hosts.yml"
FIFO_FILE=""

mkdir -p "$CACHE_DIR"

# Get the current GitHub username (cache for faster startup)
start_spinner "Getting GitHub username..."
AUTH_FINGERPRINT=""
if [ -f "$AUTH_FILE" ]; then
	AUTH_FINGERPRINT=$(sha256sum "$AUTH_FILE" | awk '{print $1}')
fi

if [ -f "$USER_CACHE_FILE" ] && [ -s "$USER_CACHE_FILE" ]; then
	read -r CACHED_USER CACHED_FINGERPRINT <"$USER_CACHE_FILE"
	if [ -n "$CACHED_USER" ] && [ "$CACHED_FINGERPRINT" = "$AUTH_FINGERPRINT" ]; then
		USER="$CACHED_USER"
	else
		USER=$(gh api user --jq .login)
		printf "%s %s" "$USER" "$AUTH_FINGERPRINT" >"$USER_CACHE_FILE"
	fi
else
	USER=$(gh api user --jq .login)
	printf "%s %s" "$USER" "$AUTH_FINGERPRINT" >"$USER_CACHE_FILE"
fi
stop_spinner

# Function to fetch and format PRs
fetch_prs() {
	local query="$1"
	local sortnum="$2"
	local label="$3"
	local color="$4"

	gh search prs $query --limit 50 --json number,title,author,assignees,repository \
		--template "{{range .}}$sortnum$color$label | {{if gt (len .title) 60}}{{printf \"%.60s...\" .title}}{{else}}{{.title}}{{end}} | {{.repository.name}} | {{.number}} | @{{.author.login}} | {{range .assignees}}@{{.login}} {{end}}| {{.repository.nameWithOwner}}{{printf \"\\t\"}}{{.repository.nameWithOwner}}{{printf \"\\t\"}}{{.number}}{{printf \"\\n\"}}{{end}}"
}

fetch_all_prs() {
	parallel --keep-order --line-buffer --link fetch_prs "{1}" "{2}" "{3}" "{4}" ::: \
		"is:open is:pr archived:false user:$ORG review-requested:$USER draft:false" \
		"is:open is:pr archived:false user:$ORG review-requested:$USER draft:true" \
		"is:open is:pr archived:false user:$ORG author:$USER draft:false" \
		"is:open is:pr archived:false user:$ORG author:$USER draft:true" \
		"is:open is:pr archived:false user:$ORG draft:false" \
		"is:open is:pr archived:false user:$ORG draft:true" \
		::: "[1]" "[2]" "[3]" "[4]" "[5]" "[6]" \
		::: "[REVIEW]" "[REVIEW] (draft)" "[MINE]" "[MINE] (draft)" "[ORG]" "[ORG] (draft)" \
		::: "$YELLOW" "$YELLOW" "$GREEN" "$GREEN" "$BLUE" "$BLUE" |
		awk 'NF && !seen[$0]++' |
		sed 's/^\[[0-9]]//'
}

# Export for parallel
export -f fetch_prs
export ORG USER GREEN YELLOW BLUE NC

# Fetch PRs in parallel (streaming)
start_spinner "Fetching PRs..."

if [[ "$1" == "--debug" ]]; then
	INPUT_DATA=$(fetch_all_prs)
	stop_spinner
	printf "%s\n" "$INPUT_DATA" >"$CACHE_FILE"
	echo "Raw data:"
	echo -e "$INPUT_DATA"
	exit 0
fi

if [[ "$1" == "--test" ]]; then
	INPUT_DATA=$(fetch_all_prs)
	stop_spinner
	printf "%s\n" "$INPUT_DATA" >"$CACHE_FILE"
	printf "%s\n" "$INPUT_DATA" | head -n 5 | while IFS=$'\t' read -r display full_repo num; do
		echo "Testing: gh pr view \"$num\" --repo \"$full_repo\""
		gh pr view "$num" --repo "$full_repo" --json number,title -q '"#\(.number) \(.title)"'
	done
	exit 0
fi

FIFO_FILE=$(mktemp -u /tmp/github_reviews_fifo.XXXXXX)
mkfifo "$FIFO_FILE"

(
	if [ -f "$CACHE_FILE" ]; then
		cat "$CACHE_FILE"
	fi
	fetch_all_prs | tee "$CACHE_FILE"
) | awk 'NF && !seen[$0]++' >"$FIFO_FILE" &
FETCH_PID=$!
(
	wait "$FETCH_PID"
	stop_spinner
) &

fzf --ansi --multi --no-sort --delimiter $'\t' --with-nth 1 \
	--header "Select PRs (TAB: select, ENTER: open, CTRL-U/D: scroll preview)" \
	--bind "ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down" \
	--preview "GH_FORCE_TTY=100% gh pr view {3} --repo {2}" \
	--preview-window='top:40%' <"$FIFO_FILE" |
	while IFS=$'\t' read -r display full_repo num; do
		url="https://github.com/$full_repo/pull/$num"

		echo -e "Opening ${BLUE}$url${NC} in browser..."
		if [[ "$OSTYPE" == "linux-gnu"* ]]; then
			xdg-open "$url" &>/dev/null
		elif [[ "$OSTYPE" == "darwin"* ]]; then
			open "$url" &>/dev/null
		else
			if ! gh pr view --repo "$full_repo" "$num" --web; then
				echo -e "\n\033[0;31mError: Failed to open browser.\033[0m"
				echo -e "You can set your preferred browser using: \033[0;32mexport BROWSER=google-chrome\033[0m (or your browser of choice)"
				echo -e "Or open manually: \033[0;34m$url\033[0m\n"
			fi
		fi
	done
