#!/usr/bin/env bash

# Args (WIP)
# 1 -> Path to wallpapers folder
# 2 -> Specific wallpaper file to use in wallpaper folder
# 3 -> Preset theme
# 4 -> If not null, use light theme
#
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
  echo "[+] Using random wallpaper"
  wpg -m
  else
    echo "[+] Using wallpaper $2"
  wpg -s $2
fi
# If third argument, use a preset color scheme, otherwise, generate from wallpaper
if [ ! -z "$3" ]; then
  if [ -z "$4" ]; then
  echo "[+] Using preset theme: $3"
  wpg --theme $3
  else
  echo "[+] Using light theme"
  wpg -L --theme $3
  fi

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
