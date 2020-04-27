#!/usr/bin/env bash

# Create colorschemes for every wallpaper
wpg -a $1/*

# Choose random wallpaper
wpg -m

# Update Emacs
kill -USR1 $(pgrep emacs)

# Restart dunst
pkill dunst
dunst&

# Update Firefox theme
while ! pgrep "firefox";
do
  sleep 5
done
$CONFIGROOT/vendor/Pywalfox/daemon/pywalfox.py update
