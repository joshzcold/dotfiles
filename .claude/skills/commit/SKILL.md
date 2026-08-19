---
name: commit
description: Do a git commit following this repo's conventions — jira-tagged summary line (e.g. DV6-1234), a minimal description, and no co-authored line. Use when asked to commit staged or unstaged work.
---

# Do a git commit

Git commit with this branch's jira tag. Example: (DV6-1234)_some_more_context. example selected in ()

Do not create a co-authored line.

Sometimes there isn't a jira tag. look for uppercase letters as a prefix like CHORE_, EXPERIMENT_, ETC_

Git commits should have a good, short summary line then a "Only as descriptive as necessary" description.

Example:

```
DV6-3402 new app to apply feature flags as code in CI

Add a feature-flags-as-code project: declare flags in feature-flags/flags.toml,
create-only applied to each environment's Unleash admin API by CI (never toggles
...
```
