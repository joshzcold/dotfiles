---
name: commit-and-pr
description: Do a git commit, push the branch, and open a new GitHub PR in the default browser. Follows the commit skill's conventions (jira-tagged summary, no co-authored line), then git push -u, gh pr create, and xdg-open on the PR URL. Use when asked to commit and open/raise a PR.
---

# Do a git commit, push the branch, and open a PR

## Step 1: commit

Read `~/.claude/skills/commit/SKILL.md` and follow it exactly for the commit itself —
message format, jira tag, and the no-co-authored-line rule all live there.

## Step 2: push and open a PR

1. If on the default branch, create a branch first (same jira tag / prefix naming as the commit).
2. Push with upstream tracking: `git push -u origin HEAD`
3. Create the PR with `gh pr create`. Title = the commit summary line (keep the jira tag). Body = the commit description, expanded only as much as a reviewer needs. No co-authored or generated-by lines.
4. Open it in the default browser: `xdg-open "$(gh pr view --json url -q .url)"`

If a PR already exists for the branch, skip creation and just open the existing one.
