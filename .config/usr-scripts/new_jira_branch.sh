#!/usr/bin/env bash


function git_convert_to_branch_name() {
  output="$1"
  output="$(echo "${output}" | tr '[:upper:]' '[:lower:]')" # To lowercase
  output="$(echo "${output}" | tr '[:punct:]' '_' | tr ' ' '_')" # Replace special characters with underscores
  output="$(echo "${output}" | tr -s '_')" # Remove duplicate underscores
  output="$(echo "${output}" | cut -c 1-200)" # Shorten to 200
  output="$(echo "${output}" | sed -e 's/_$//')" # Remove trailing underscores
  echo "$output"
}

(git fetch origin &>/dev/null &)

jira_command=(
	jira issue list --plain
	--columns 'KEY,STATUS,TYPE,ASSIGNEE,SUMMARY'
	-s 'In Progress' -s 'Code Review' -s 'In QA' -s 'QA Ready'
	--no-headers
)
jira_issues="$("${jira_command[@]}" | grep -oP "^\w+.*")"
list=""
list+="CHORE"$'\n'
list+="ENHANCEMENT"$'\n'
list+="${jira_issues}"
selected_line="$(printf '%s' "${list}" | fzf --query '')"
[ -z "$selected_line" ] && return
key="$(echo "${selected_line}" | awk '{print $1}')"

branch_summary="$(echo "${selected_line}" | tr -s '\t' | awk -F '\t' '{print $4}')" # Start with the summary
suffix_prompt="Branch suffix ($branch_summary)?: "
read -r -p  "${suffix_prompt}" user_input
if [ -n "$user_input" ]; then
	branch_summary="$user_input"
fi
branch_summary=$(git_convert_to_branch_name "$branch_summary")
branch="${key}_${branch_summary}"

if git rev-parse --verify "${branch}" &>/dev/null; then
	echo "Branch ${branch} already exists"
	exit 1
fi

git checkout --no-track -b "${branch}" origin/master
