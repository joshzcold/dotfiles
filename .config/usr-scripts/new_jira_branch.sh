#!/usr/bin/env bash

Color_Off='\033[0m'
Yellow='\033[0;33m'

function git_convert_to_branch_name() {
  output="$1"
  output="$(echo "${output}" | tr '[:upper:]' '[:lower:]')"      # To lowercase
  output="$(echo "${output}" | tr '[:punct:]' '_' | tr ' ' '_')" # Replace special characters with underscores
  output="$(echo "${output}" | tr -s '_')"                       # Remove duplicate underscores
  output="$(echo "${output}" | cut -c 1-200)"                    # Shorten to 200
  output="$(echo "${output}" | sed -e 's/_$//')"                 # Remove trailing underscores
  echo "$output"
}

FZF_TABS=('All' 'In Progress' 'Code Review' 'Other')

function fzf_tab_header() {
  local tab out=""
  for tab in "${FZF_TABS[@]}"; do
    if [ "${tab}" = "$1" ]; then
      out+=$'\033[7m'" ${tab} "$'\033[0m'"  "
    else
      out+=" ${tab}   "
    fi
  done
  echo "${out}"
}

# Non-issue lines (CHORE, HOTFIX, ...) have one field and show on every tab.
function fzf_tab_filter() {
  awk -F '\t' -v tab="$1" '
    NF == 1 || tab == "All" { print; next }
    tab == "Other" { if ($2 != "In Progress" && $2 != "Code Review") print; next }
    $2 == tab
  ' "$2"
}

# Prints the fzf actions that move from the current tab ($FZF_PROMPT) by $1 steps.
function fzf_tab_switch() {
  local step="$1" current="${2%> }" file="$3" i next
  for i in "${!FZF_TABS[@]}"; do
    [ "${FZF_TABS[$i]}" = "${current}" ] && break
  done
  next="${FZF_TABS[$(((i + step + ${#FZF_TABS[@]}) % ${#FZF_TABS[@]}))]}"
  echo "change-prompt(${next}> )+change-header($(fzf_tab_header "${next}"))+reload('${BASH_SOURCE[0]}' --fzf-tab-filter '${next}' '${file}')+first"
}

case "$1" in
--fzf-tab-filter)
  fzf_tab_filter "$2" "$3"
  exit
  ;;
--fzf-tab-switch)
  fzf_tab_switch "$2" "$3" "$4"
  exit
  ;;
esac

(git fetch origin &>/dev/null &)

MAIN_BRANCH=$(git branch --format '%(refname:short)' --list master main)

echo -e "${Yellow}Getting jira issues...${Color_Off}" 1>&2

JIRA_PROJECT="DV6"
JIRA_STATUSES=(
  'In Progress'
  'Code Review'
  'In QA'
  'QA Ready'
  'Merge Ready'
  'In Approval'
  'Release Ready'
)

status_jql="$(printf '"%s",' "${JIRA_STATUSES[@]}" | sed 's/,$//')"

if ! acli jira auth status &>/dev/null; then
  echo "Not authenticated to Jira. Run: acli jira auth login" 1>&2
  exit 1
fi

jira_issues="$(
  acli jira workitem search \
    --jql "(project = ${JIRA_PROJECT} AND status IN (${status_jql})) OR (assignee = currentUser() AND issuetype IN (Story, Task, Bug, Sub-task) AND statusCategory != Done) ORDER BY updated DESC" \
    --fields 'key,status,issuetype,assignee,summary' \
    --limit 200 \
    --json |
    jq -r --arg prefix "${JIRA_PROJECT}-" 'sort_by(.key | startswith($prefix) | not) | .[] | [
      .key,
      .fields.status.name,
      .fields.issuetype.name,
      (.fields.assignee.displayName // "Unassigned"),
      (.fields.summary | gsub("[\t\n]"; " "))
    ] | @tsv'
)"

if [ -z "${jira_issues}" ]; then
  echo "No Jira issues returned" 1>&2
fi

list=""
list+="CHORE"$'\n'
list+="HOTFIX"$'\n'
list+="ENHANCEMENT"$'\n'
list+="EXPERIMENT"$'\n'
list+="${jira_issues}"

list_file="$(mktemp)"
trap 'rm -f "${list_file}"' EXIT
printf '%s\n' "${list}" >"${list_file}"

self="${BASH_SOURCE[0]}"
selected_line="$(
  fzf_tab_filter 'In Progress' "${list_file}" | fzf --query '' \
    --prompt 'In Progress> ' \
    --header "$(fzf_tab_header 'In Progress')" \
    --bind "tab:transform:'${self}' --fzf-tab-switch 1 \"\$FZF_PROMPT\" '${list_file}'" \
    --bind "shift-tab:transform:'${self}' --fzf-tab-switch -1 \"\$FZF_PROMPT\" '${list_file}'"
)"
[ -z "$selected_line" ] && exit 1
key="$(echo "${selected_line}" | awk '{print $1}')"

branch_summary="$(echo "${selected_line}" | tr -s '\t' | awk -F '\t' '{print $5}')" # Start with the summary
suffix_prompt="Branch suffix ($branch_summary)?: "
read -r -p "${suffix_prompt}" user_input
if [ -n "$user_input" ]; then
  branch_summary="$user_input"
fi
branch_summary=$(git_convert_to_branch_name "$branch_summary")
branch="${key}_${branch_summary}"

if git rev-parse --verify "${branch}" &>/dev/null; then
  echo "Branch ${branch} already exists" 1>&2
  exit 1
fi

if [ "$(git rev-parse --abbrev-ref HEAD)" = "${MAIN_BRANCH}" ]; then
  ans=y
  worktree_path="$(dirname "$(git rev-parse --show-toplevel)")/$(basename -s .git "$(git config --get remote.origin.url)").${branch}"
  echo -e "${Yellow}This worktree is currently '${MAIN_BRANCH}' do you want to create a new worktree at '${worktree_path}'? [n/Y]:${Color_Off}" 1>&2
  read -r -n1 ans

  if [ "$ans" = "Y" ] || [ "$ans" = "y" ] || [ -z "$ans" ]; then
    set -x
    git worktree add "${worktree_path}" -b "${branch}" 1>&2
    set +x
    if [[ $(git status --porcelain) ]]; then
      echo -e "${Yellow}Worktree added${Color_Off}" 1>&2
      echo -e "${Yellow}At this point you need to:${Color_Off}" 1>&2
      echo -e "git add <whatever>" 1>&2
      echo -e "git stash" 1>&2
      echo -e "cd ${worktree_path}" 1>&2
      echo -e "git stash pop" 1>&2
      echo "" 1>&2
      git status 1>&2
    else
      cd "${worktree_path}"
      echo "Changed to directory: ${worktree_path}" 1>&2
      echo "${worktree_path}"
    fi
  else
    git checkout --no-track -b "${branch}" origin/${MAIN_BRANCH} 1>&2
  fi
else
  git checkout --no-track -b "${branch}" origin/${MAIN_BRANCH} 1>&2
fi
