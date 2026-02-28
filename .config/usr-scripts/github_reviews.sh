#!/bin/bash

# Ensure dependencies are present
for cmd in gh fzf parallel; do
	if ! command -v "$cmd" &>/dev/null; then
		echo "Error: '$cmd' is not installed."
		exit 1
	fi
done

# Define colors
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
GRAY='\e[90m'
NC='\e[0m' # No Color
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
	rm -f /tmp/combined_prs*
	# Ensure spinner is stopped if script exits early
	stop_spinner
}
# trap cleanup EXIT

# Ensure user is logged in to gh
if ! gh auth status &>/dev/null; then
	echo "Not logged in to GitHub CLI. Starting login..."
	gh auth login
fi

# Get the current GitHub username
start_spinner "Getting GitHub username..."
USER=$(gh api user --jq .login)
stop_spinner

ORG="SecurityMetrics"

# Function to fetch and format PRs
fetch_prs() {
	local query="$1"
	local sortnum="$2"
	local label="$3"
	local color="$4"

	gh search prs $query --limit 50 --json number,title,author,assignees,repository \
		--template "{{range .}}$sortnum$color$label | {{if gt (len .title) 60}}{{printf \"%.60s...\" .title}}{{else}}{{.title}}{{end}} | {{.repository.name}} | {{.number}} | @{{.author.login}} | {{range .assignees}}@{{.login}} {{end}}| {{.repository.nameWithOwner}}{{printf \"\\n\"}}{{end}}"
}

# Export for parallel
export -f fetch_prs
export ORG USER GREEN YELLOW BLUE NC

# Fetch PRs in parallel
start_spinner "Fetching PRs..."
parallel --link fetch_prs "{1}" "{2}" "{3}" "{4}" ::: \
	"is:open is:pr archived:false user:$ORG review-requested:$USER draft:false" \
	"is:open is:pr archived:false user:$ORG review-requested:$USER draft:true" \
	"is:open is:pr archived:false user:$ORG author:$USER draft:false" \
	"is:open is:pr archived:false user:$ORG author:$USER draft:true" \
	"is:open is:pr archived:false user:$ORG draft:false" \
	"is:open is:pr archived:false user:$ORG draft:true" \
	::: "[1]" "[2]" "[3]" "[4]" "[5]" "[6]" \
	::: "[REVIEW]" "[REVIEW] (draft)" "[MINE]" "[MINE] (draft)" "[ORG]" "[ORG] (draft)" \
	::: "$YELLOW" "$YELLOW" "$GREEN" "$GREEN" "$BLUE" "$BLUE" \
	>/tmp/combined_prs
stop_spinner

# Deduplicate so a PR shows up only in the first category it appears in.
INPUT_DATA=$(grep -v '^$' /tmp/combined_prs | sort | awk '!seen[$0]++')

# Remove the sorting prefix [1][REVIEW]...
INPUT_DATA=$(echo -e "$INPUT_DATA" | sed 's/^\[[0-9]]//')

if [[ "$1" == "--debug" ]]; then
	echo "Raw data:"
	echo -e "$(cat /tmp/combined_prs)"
	echo -e "\nProcessed data:"
	echo -e "$INPUT_DATA"
	exit 0
fi

if [[ "$1" == "--test" ]]; then
	echo -e "$INPUT_DATA" | column -t -s '|' | head -n 5 | while read -r line; do
		# The repo is always the last field.
		full_repo=$(echo "$line" | grep -o '[^ ]*$' | sed 's/\x1b\[[0-9;]*m//g')
		# The PR number is the 4th field from the end in the | separated data,
		# but in column -t it's usually 4 fields back from the repo (author, reviewer, number, repo).
		# We use the fact that the PR number is purely numeric.
		num=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g' | awk '{for(i=NF-1;i>0;i--) if($i ~ /^[0-9]+$/) {print $i; break}}')
		echo "Testing: gh pr view \"$num\" --repo \"$full_repo\""
		gh pr view "$num" --repo "$full_repo" --json number,title -q '"#\(.number) \(.title)"'
	done
	exit 0
fi

echo -e "$INPUT_DATA" | column -t -s '|' |
	fzf --ansi --multi --no-sort \
		--header "Select PRs (TAB: select, ENTER: open, CTRL-U/D: scroll preview)" \
		--bind "ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down" \
		--preview "full_repo=\$(echo {} | grep -o '[^ ]*$' | sed 's/\x1b\[[0-9;]*m//g'); num=\$(echo {} | sed 's/\x1b\[[0-9;]*m//g' | awk '{for(i=NF-1;i>0;i--) if(\$i ~ /^[0-9]+\$/) {print \$i; break}}'); GH_FORCE_TTY=100% gh pr view \"\$num\" --repo \"\$full_repo\"" \
		--preview-window='top:40%' |
	while read -r line; do
		full_repo=$(echo "$line" | awk '{print $NF}' | xargs)
		num=$(echo "$line" | awk '{for(i=NF-1;i>0;i--) if($i ~ /^[0-9]+$/) {print $i; break}}' | xargs)
		url="https://github.com/$full_repo/pull/$num#partial-pull-merging"

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
