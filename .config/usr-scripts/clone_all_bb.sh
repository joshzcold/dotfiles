#!/usr/bin/env bash
server="${BITBUCKETSERVER:-"https://bitbucket.secmet.co"}"
clone_type="${CLONE_TYPE:-"ssh"}"
TOKEN=$(cat ~/git/codepaste/BitBucketPat)

PROJECTS="$(curl -s -H "Authorization: Bearer $TOKEN" --request GET "$server/rest/api/1.0/projects?limit=999" | jq --raw-output ".values[].key")"

pushd ~/git

while IFS= read -r PROJECT; do
	PROJECT=$(echo "$PROJECT" | awk '{print tolower($0)}')
	repos=$(curl -s -H "Authorization: Bearer $TOKEN" --request GET "$server/rest/api/1.0/projects/$PROJECT/repos?limit=999" | jq --raw-output ".values[].links.clone[] | select(.name == \"$clone_type\") | .href")
	mkdir -p "${PROJECT}"
	cd "${PROJECT}" || exit
	echo "$repos" | parallel -I% git clone %
	cd ../
done <<<"$PROJECTS"

popd
