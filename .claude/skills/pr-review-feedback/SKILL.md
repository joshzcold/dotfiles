---
name: pr-review-feedback
description: Use when asked to pull, triage, or act on code-review feedback on a GitHub pull request — especially "unresolved"/"open"/"outstanding" review comments — and validate whether each concern is actually valid against the current code before recommending changes. Covers gh CLI, GraphQL reviewThreads, isResolved, CodeRabbit/bot noise, and outdated threads.
---

# Analyzing unresolved PR review feedback

## Overview

Two hard parts, both easy to get wrong:

1. **Finding what's actually unresolved.** REST (`gh api repos/.../pulls/N/comments`) returns every review comment but **not** whether its thread is resolved — resolution lives only on the GraphQL `reviewThreads.isResolved` field. Use REST and you'll re-surface comments the author already closed.
2. **Not trusting the comment blindly.** Reviewers — especially AI ones like CodeRabbit — are frequently wrong, out of date, or commenting on code that has since changed. Validate every concern against the _current_ file, not the diff hunk quoted in the comment.

**Core principle: the reviewer tells you where to look, not what's true.**

## Workflow

### 1. Pull unresolved feedback

```bash
~/.claude/skills/pr-review-feedback/pull-unresolved-feedback.sh            # current branch's PR
~/.claude/skills/pr-review-feedback/pull-unresolved-feedback.sh 2895       # explicit PR
~/.claude/skills/pr-review-feedback/pull-unresolved-feedback.sh --all 2895 # include resolved
```

It prints review-level feedback (change requests, plus review bodies like CodeRabbit's nitpick batches), then each unresolved inline thread with its file:line, permalink, diff hunk, and full comment chain. Threads flagged `⚠️ OUTDATED` point at code that has moved since the comment.

### 2. Investigate each concern against the real code

Read the file at `path:line` _now_ — the `diffHunk` is a snapshot from when the comment was written. Confirm the code the reviewer described still exists and behaves as claimed, and check whether a later commit already addressed it (an unresolved thread is often just one nobody clicked "Resolve" on).

### 3. Classify each item

Valid / Invalid / Already-addressed / Out-of-scope / Judgment-call — each with the evidence that led you there: the line you read, the test that covers it, the commit that fixed it.

### 4. Report

Group by classification, most-actionable first. Give a concrete recommendation for valid items; for invalid or already-addressed ones, state why, so the author can resolve the thread with confidence.

### 5. Ask before touching code

This skill is analysis by default — stop here unless the user opts in. Use AskUserQuestion:

- 🚀 **Fix recommended issues** — apply fixes for the items classified Valid → step 6
- ⏭️ **Report only** — change nothing → exit

### 6. Commit and push

After fixing, use the `/commit` skill. Ask whether to push; if the user pushes, continue to step 7.

### 7. Reply to threads

Reply to AI-reviewer threads with the outcome. For human-authored threads, ask the user before posting an AI-written reply. For issues left unfixed, ask whether to reply with the reason they were deferred.

## Where feedback lives

| Source           | GraphQL field          | Contains                                                      |
| ---------------- | ---------------------- | ------------------------------------------------------------- |
| Inline threads   | `reviewThreads.nodes`  | Line-anchored comments; the only ones with `isResolved`       |
| Review summaries | `reviews.nodes[].body` | Top-level review text (CodeRabbit posts nitpick batches here) |
| Issue comments   | `comments.nodes`       | General PR conversation, not line-anchored                    |

"Unresolved feedback" = unresolved **review threads** + still-standing **reviews that carry feedback** (every `CHANGES_REQUESTED`, plus `COMMENTED` reviews with a body; `APPROVED` and `DISMISSED` are excluded). The helper covers both. Reach for issue comments only if the reviewer raised something in general conversation.

## Manual query (when the helper won't fit)

```bash
gh api graphql -F owner=OWNER -F repo=REPO -F pr=NUMBER -f query='
query($owner:String!,$repo:String!,$pr:Int!){
  repository(owner:$owner,name:$repo){ pullRequest(number:$pr){
    reviewThreads(first:100){ nodes{
      isResolved isOutdated
      comments(first:50){ nodes{ author{login} body path line diffHunk url } } } } } } }' \
  | jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved | not)'
```

## Common mistakes

- **Using the REST comments endpoint for "unresolved."** It has no resolution field, so you'll report already-handled comments. Use GraphQL `reviewThreads.isResolved`.
- **Trusting the `diffHunk`.** It's frozen at comment time. Open the current file before judging validity — this is the whole point of the skill.
- **Treating CodeRabbit / bot output as authoritative.** AI reviewers post large "nitpick" batches (see `reviews[].body`) that are often stylistic, already-followed, or wrong for this repo's conventions. Validate each like any other concern; don't mass-apply.
- **Mistaking bot noise for feedback.** `github-actions` posts checklists (e.g. "Required Testing") that read like review comments but aren't reviewer concerns. Filter them out.
- **Missing review-level change requests.** A `CHANGES_REQUESTED` review can carry the blocking feedback in its body with no inline thread at all.
- **Assuming unresolved = unaddressed.** Authors fix code but forget to click "Resolve." Check for a later commit before flagging.
- **Silent truncation.** The helper caps at 100 threads and warns on stderr if there are more; page further before claiming full coverage.
