#!/usr/bin/env bash
# Pull UNRESOLVED code-review feedback from a GitHub PR as readable markdown.
#
# Why GraphQL: the REST API (`gh api repos/.../pulls/N/comments`) does NOT expose
# whether a review thread is resolved. Thread resolution lives only on the GraphQL
# `reviewThreads.isResolved` field, so that is the only reliable source of truth
# for "what feedback is still open".
#
# Usage:
#   ./pull-unresolved-feedback.sh            # PR for the current branch
#   ./pull-unresolved-feedback.sh 2895       # explicit PR number
#   ./pull-unresolved-feedback.sh --all 2895 # include resolved threads too
#
# Requires: gh (authenticated), jq.

set -euo pipefail

INCLUDE_RESOLVED=false
PR=""
for arg in "$@"; do
  case "$arg" in
    --all) INCLUDE_RESOLVED=true ;;
    *) PR="$arg" ;;
  esac
done

command -v gh >/dev/null || { echo "error: gh CLI not found" >&2; exit 1; }
command -v jq >/dev/null || { echo "error: jq not found" >&2; exit 1; }

read -r OWNER REPO < <(gh repo view --json owner,name --jq '.owner.login + " " + .name')

if [[ -z "$PR" ]]; then
  PR=$(gh pr view --json number --jq .number 2>/dev/null) \
    || { echo "error: no PR for the current branch; pass a PR number" >&2; exit 1; }
fi

echo "# Unresolved review feedback — ${OWNER}/${REPO} PR #${PR}" >&2
echo >&2

RESP=$(gh api graphql \
  -F owner="$OWNER" -F repo="$REPO" -F pr="$PR" \
  -f query='
query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      title
      reviews(first: 100) {
        nodes { author { login } state body url }
      }
      reviewThreads(first: 100) {
        totalCount
        nodes {
          isResolved
          isOutdated
          comments(first: 50) {
            nodes {
              author { login }
              body
              path
              line
              originalLine
              diffHunk
              url
              createdAt
            }
          }
        }
      }
    }
  }
}')

# Warn if a PR has more than the 100-thread cap so coverage is never silently truncated.
TOTAL=$(jq -r '.data.repository.pullRequest.reviewThreads.totalCount' <<<"$RESP")
if (( TOTAL > 100 )); then
  echo "> WARNING: PR has ${TOTAL} review threads; only the first 100 were fetched." >&2
  echo >&2
fi

jq -r --argjson keepresolved "$INCLUDE_RESOLVED" '
  .data.repository.pullRequest as $pr
  | ($pr.reviewThreads.nodes
      | map(select(if $keepresolved then true else (.isResolved | not) end)))
    as $threads
  | (
      "## Review-level feedback (change requests + review bodies)\n",
      ( [ $pr.reviews.nodes[]
          # Any still-standing review that carries feedback: every CHANGES_REQUESTED,
          # plus COMMENTED reviews with a body (where CodeRabbit posts nitpick batches).
          # APPROVED and DISMISSED reviews are not open feedback.
          | select(.state != "APPROVED" and .state != "DISMISSED"
                   and (.state == "CHANGES_REQUESTED" or .body != "")) ]
        | if length == 0 then "_none_\n"
          else ( .[]
            | "- **\(.author.login)** [\(.state)] \(.url)\n"
              + (if .body != "" then "  \n  " + (.body | gsub("\n"; "\n  ")) + "\n" else "" end) )
          end ),
      "\n## Unresolved inline threads (\($threads | length))\n"
    ),
    ( $threads[]
      | .comments.nodes[0] as $first
      | "### \($first.path):\($first.line // $first.originalLine)"
        + (if .isOutdated then "  ⚠️ OUTDATED (code moved since comment)" else "" end)
        + "\n\($first.url)\n"
        + "\n```\n\($first.diffHunk // "(no diff hunk)")\n```\n"
        + ( [ .comments.nodes[] | "**\(.author.login):** \(.body)" ] | join("\n\n") )
        + "\n"
    )
' <<<"$RESP"
