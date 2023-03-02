#!/usr/bin/env bash

while true; do
	server="${BITBUCKETSERVER:-"https://bitbucket.secmet.co"}"
	TOKEN=$(cat ~/git/codepaste/BitBucketPat)
	email="joshua.cold@securitymetrics.com"

	open_pulls=$(curl -s \
		-H "Authorization: Bearer $TOKEN" \
		--request GET \
		"$server/rest/api/1.0/dashboard/pull-requests?state=open" |
		jq \
			-r \
			--arg EMAIL "${email}" \
			'.values[] | { title: .title, status: [.reviewers[] | select(.user.name==$EMAIL) ]} | select(.status[].status=="UNAPPROVED")')

	titles=$(echo $open_pulls | jq -r '.title')
	[ -n "$titles" ] &&
		notify-send -u 'normal' "Open pull requests not reviewed
-------------------------------------------------------
${titles}"
	sleep 1h
done
