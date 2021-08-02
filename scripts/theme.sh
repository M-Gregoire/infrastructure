#!/usr/bin/env bash

# Setup pywall for Firefox if not already
if [ ! -f ~/.mozilla/native-messaging-hosts/pywalfox.json ]; then
  pywalfox install
fi

# Wpg install
if [[ ! -e ~/.config/wpg/templates/gtk2 ]] || [[ ! -e ~/.config/wpg/templates/gtk3.0 ]]
then
  mkdir -p ~/.themes
  wpg-install.sh -g -i
fi

if ! [[ -L ~/.gtkrc-2.0 || "$(readlink ~/.gtkrc-2.0)" = "~/.config/wpg/templates/gtk2" ]]
then
    rm -rf ~/.gtkrc-2.0 ~/.config/wpg/templates/gtk2
    ln -s ~/.config/wpg/templates/gtk2 ~/.gtkrc-2.0
fi

if ! [[ -L ~/.config/gtk-3.0/settings.ini || "$(readlink ~/.config/gtk-3.0/settings.ini)" = "~/.config/wpg/templates/gtk3.0" ]]
then
    rm -rf ~/.config/gtk-3.0/settings.ini ~/.config/wpg/templates/gtk3.0
    ln -s ~/.config/wpg/templates/gtk3.0 ~/.config/gtk-3.0/settings.ini
fi

# Generate schemes for all wallpaper
wpg -a $1/* > /dev/null

if ! [[ -L ~/.config/dunst/dunstrc || "$(readlink ~/.config/dunst/dunstrc)" = "~/.config/wpg/templates/dunstrc" ]]
then
    rm -rf ~/.config/dunst/dunstrc ~/.config/wpg/templates/dunstrc
    ln -s ~/.config/wpg/templates/dunstrc ~/.config/dunst/dunstrc
fi

# If no second argument, take a random wallapper
if [ -z "$2" ]; then
  wpg -m > /dev/null
else
  wpg -s $2 > /dev/null
fi

# Update Emacs
kill -USR1 $(pgrep emacs)

# Restart dunst
pkill dunst > /dev/null
dunst& > /dev/null

# Start pywalfox daemon
pkill pywalfox
pywalfox update
pywalfox start&

if ! pgrep firefox > /dev/null
then
  firefox&
fi

if ! pgrep thunderbird > /dev/null
then
  thunderbird&
fi
