#!/usr/bin/env bash

# GitHub equivalent of check_bb_reviews.sh: hourly notification of open PRs
# where I am a requested reviewer.
#
# review-requested: is the whole list, matching what github_reviews.sh labels
# [NEEDS REVIEW]. Do not try to narrow it with -reviewed-by:, which looks like
# it would drop PRs already reviewed but also drops the ones that most need
# another look: a dismissed CHANGES_REQUESTED and a comment-only review both
# leave the request standing, yet both match reviewed-by:.
#
# A second query for reviewed-by: is what separates a first look from a repeat
# one, so each PR is tagged 🆕 or 🔄.
#
# Run with --once to print the list and exit (no loop, no notification).
# Set GITHUB_REVIEW_DEBUG=1 to trace.

[ -n "${GITHUB_REVIEW_DEBUG:-}" ] && set -x

org="${GITHUB_REVIEW_ORG:-SecurityMetrics}"
interval="${GITHUB_REVIEW_INTERVAL:-1h}"

# Colors mirror github_reviews.sh: yellow for a review not yet given, purple for
# one already submitted. Pango hex for the notification, ANSI for the terminal.
new_emoji='🆕' new_hex='#d7af5f' new_ansi='33'
seen_emoji='🔄' seen_hex='#af87d7' seen_ansi='35'

# Emits one PR per line: state \t title \t repo \t number \t author \t url
needs_review() {
	local user base seen items

	# gh writes the error response body to stdout and skips --jq when a call
	# fails, so every call is checked rather than parsed on faith.
	user=$(gh api user --jq .login 2>/dev/null) || return 1
	base="is:open is:pr archived:false draft:false user:${org} review-requested:${user}"

	seen=$(gh api -X GET search/issues -f per_page=100 \
		-f q="${base} reviewed-by:${user}" --jq '[.items[].number]' 2>/dev/null) || return 1

	items=$(gh api -X GET search/issues -f per_page=100 -f q="${base}" 2>/dev/null) || return 1

	# Oldest first: the PR that has been waiting longest is the one to open.
	jq -r --argjson seen "$seen" '
		.items | sort_by(.created_at) | .[] | . as $pr | [
			(if ($seen | index($pr.number)) then "seen" else "new" end),
			.title,
			(.repository_url | split("/") | last),
			(.number | tostring),
			.user.login,
			.html_url
		] | @tsv
	' <<<"$items"
}

# dunst renders Pango in the body only, and its format bolds the summary
# already, so the list goes in the body argument with titles escaped.
notify_body() {
	local state title repo num author url emoji hex
	while IFS=$'\t' read -r state title repo num author url; do
		if [ "$state" = seen ]; then
			emoji="$seen_emoji" hex="$seen_hex"
		else
			emoji="$new_emoji" hex="$new_hex"
		fi

		title=${title//&/&amp;}
		title=${title//</&lt;}
		title=${title//>/&gt;}

		printf '%s <b>%s</b>\n<span foreground="%s">   <a href="%s">%s #%s</a> · @%s</span>\n' \
			"$emoji" "$title" "$hex" "$url" "$repo" "$num" "$author"
	done
}

print_list() {
	local state title repo num author url emoji ansi
	while IFS=$'\t' read -r state title repo num author url; do
		if [ "$state" = seen ]; then
			emoji="$seen_emoji" ansi="$seen_ansi"
		else
			emoji="$new_emoji" ansi="$new_ansi"
		fi

		printf '%s \033[1m%s\033[0m\n   \033[%sm%s #%s · @%s\033[0m  %s\n' \
			"$emoji" "$title" "$ansi" "$repo" "$num" "$author" "$url"
	done
}

if [ "${1:-}" = "--once" ]; then
	needs_review | print_list
	exit "${PIPESTATUS[0]}"
fi

while true; do
	prs=$(needs_review) && [ -n "$prs" ] &&
		notify-send -u 'normal' \
			"Open PRs awaiting your review ($(wc -l <<<"$prs"))" \
			"$(notify_body <<<"$prs")"

	sleep "$interval"
done
