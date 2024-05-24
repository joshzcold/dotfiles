#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

WIN=$(yabai -m query --spaces --space $SID | jq '.windows[0]')
HAS_WINDOWS="true"
if [ "$WIN" = "null" ];then
  HAS_WINDOWS="false"
fi
sketchybar --set $NAME background.drawing=$SELECTED icon.highlight=$HAS_WINDOWS icon.highlight_color=0xffadd5ff
