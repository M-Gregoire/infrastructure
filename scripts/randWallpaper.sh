#!/usr/bin/env bash
WALL=$(find "$PRIVATEROOT/images/backgrounds/" -type f | sort -R | tail -1)
feh --randomize --no-fehbg --bg-scale "$WALL" --bg-scale "$WALL"
