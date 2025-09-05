#!/usr/bin/env bash
in_array() { local x="$1"; shift; for i; do [[ "$i" == "$x" ]] && return 0; done; return 1; }

declare -A label=(
  ["1"]=""
  ["2"]=""
  ["3"]=""
  ["8"]="󰒱"
  ["9"]=""
)
hide_when_empty=(4 5 6 7 9)
focused="${FOCUSED_WORKSPACE:-}"
non_empty="$(aerospace list-workspaces --monitor all --empty no 2>/dev/null | tr '\n' ' ')"

ws="$1"                                     # e.g. "1"

pretty="${label[$ws]:-$ws}"                 # default to the raw name

sketchybar --set "space.$ws" label="$pretty"

# highlight if focused (AeroSpace env gives the focused workspace name)
if [ "$focused" = "$ws" ]; then
  sketchybar --set "space.$ws" background.drawing=on
else
  sketchybar --set "space.$ws" background.drawing=off
fi

# Hide logic: only hide 4–7 when they’re empty and not focused
if in_array "$ws" "${hide_when_empty[@]}"; then
  if [[ " $non_empty " == *" $ws "* ]] || [[ "$ws" == "$focused" ]]; then
    sketchybar --set "space.$ws" drawing=on
  else
    sketchybar --set "space.$ws" drawing=off
  fi
else
  # Always show workspaces not in the hide list
  sketchybar --set "space.$ws" drawing=on
fi
