#!/usr/bin/env bash

# Setup pywall for Firefox if not already
if [ ! -f ~/.mozilla/native-messaging-hosts/pywalfox.json ]; then
  pywalfox install
fi

# Wpg install
if [[ ! -L ~/.config/wpg/templates/gtk2 ]] || [[ ! -L ~/.config/wpg/templates/gtk3.0 ]] || [[ ! -L ~/.config/wpg/templates/dunstrc ]]
then
  mkdir -p ~/.themes
  wpg-install.sh -g -i #-d
  # Manually link dunstrc so install.sh doesn't replace symlink for dunstrc.base
  rm -rf ~/.config/wpg/templates/dunstrc ~/.config/dunst/dunstrc
  ln -sf ~/.config/dunst/dunstrc ~/.config/wpg/templates/dunstrc
fi

# Generate schemes for all wallpaper
wpg -a $1/*

# If no second argument, take a random wallapper
if [ -z "$2" ]; then
  wpg -m
else
  wpg -s $2
fi

# Update Emacs
kill -USR1 $(pgrep emacs)

# Restart dunst
pkill dunst > /dev/null 2>&1
# Dunst starts automatically
# https://github.com/dunst-project/dunst/issues/63#issuecomment-586764246
#dunst& > /dev/null

# Start pywalfox daemon
pkill pywalfox
pywalfox start&
#pywalfox update

if ! pgrep firefox > /dev/null
then
  firefox&
fi

if ! pgrep thunderbird > /dev/null
then
  thunderbird&
fi
