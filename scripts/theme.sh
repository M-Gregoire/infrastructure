#!/usr/bin/env bash

# Args (WIP)
# 1 -> Path to wallpapers folder
# 2 -> Specific wallpaper file to use in wallpaper folder
# 3 -> Preset theme
# 4 -> If not null, use light theme

reload_dunst() {
  . "${HOME}/.cache/wal/colors.sh"
  pkill dunst

  dunst \
    -frame_width 0 \
    -lb "${color0}" \
    -nb "${color0}" \
    -cb "${color0}" \
    -lf "${color7}" \
    -bf "${color7}" \
    -cf "${color7}" \
    -nf "${color7}" &
}

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
wpg -a $1/* > /dev/null

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
# TODO: Check this
# kill -USR1 $(pgrep emacs)

# Restart dunst
reload_dunst

# Start pywalfox daemon
pkill pywalfox
pywalfox start&
#pywalfox update

# Wait for network before starting Firefox and Thunderbird
while ! systemctl is-active --quiet network-online.target; do sleep 3; done;

# pgrep might be missing, prefer ps
# Need [.] to not return ps process as result
# https://stackoverflow.com/a/8965530
if ! ps -aux | grep "[.]firefox">/dev/null
then
  echo "[+] Firefox not running. Starting..."
  firefox&
fi

if ! ps -aux | grep "[.]thunderbird" > /dev/null
then
  echo "[+] Thunderbird not running. Starting..."
  thunderbird&
fi
