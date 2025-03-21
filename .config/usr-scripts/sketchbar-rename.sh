#!/usr/bin/env bash

current_aerospace=$(aerospace list-workspaces --focused)

new=$(echo "${current_aerospace}" | choose -m)

if [ -n "$new" ]; then
	sketchybar --set space.${current_aerospace} label="${current_aerospace} ${new}"
else
	sketchybar --set space.${current_aerospace} label=${current_aerospace}
fi
