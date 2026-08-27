#!/bin/bash
# Stay on a workspace when its last window closes, instead of following macOS
# focus to whatever window it activates next.
set -u

state="${TMPDIR:-/tmp}/aerospace-last-workspace"

# Let AeroSpace finish removing the closed window from its tree.
sleep 0.1

cur=$(aerospace list-workspaces --focused) || exit 0
prev=""
prev_count=0
read -r prev prev_count 2>/dev/null < "$state"

if [ -n "$prev" ] && [ "$prev" != "$cur" ] && [ "${prev_count:-0}" -gt 0 ] &&
   [ "$(aerospace list-windows --workspace "$prev" --count)" -eq 0 ]; then
    aerospace workspace "$prev"
    printf '%s 0\n' "$prev" > "$state"
    exit 0
fi

printf '%s %s\n' "$cur" "$(aerospace list-windows --workspace "$cur" --count)" > "$state"
