#!/usr/bin/env sh

# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar top-main &
# ICP symlink for Spotify module
rm /tmp/ipc-bottom
ln -s /tmp/polybar_mqueue.$! /tmp/ipc-bottom
