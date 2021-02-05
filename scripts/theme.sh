#!/usr/bin/env bash

# Update Firefox theme
while ! pgrep "firefox";
do
  sleep 5
done

# Setup pywall for Firefox if not already
if [ ! -f ~/.mozilla/native-messaging-hosts/pywalfox.json ]; then
  pywalfox setup
fi

# Wpg install
if { [ ! -f ~/.config/wpg/templates/gtk2 ] || [ ! -f ~/.config/wpg/templates/gtk3.0 ] || [ ! -f ~/.config/wpg/templates/dunstrc ]; }; then
  wpg-install.sh -g -i -d
fi

if ! [[ -L "~/.gtkrc-2.0" || "$(readlink ~/.gtkrc-2.0)" = "~/.config/wpg/templates/gtk2" ]]
then
    rm -rf ~/.gtkrc-2.0
    ln -s ~/.config/wpg/templates/gtk2 ~/.gtkrc-2.0
fi

if ! [[ -L "~/.config/gtk-3.0/settings.ini" || "$(readlink ~/.config/gtk-3.0/settings.ini)" = "~/.config/wpg/templates/gtk3.0" ]]
then
    rm -rf ~/.config/gtk-3.0/settings.ini
    ln -s ~/.config/wpg/templates/gtk3.0 ~/.config/gtk-3.0/settings.ini
fi

# Generate schemes for all wallpaper
wpg -a $1/* > /dev/null 2>&1

# If no second argument, take a random wallapper
if [ -z "$2" ]; then
  wpg -m > /dev/null
else
  wpg -s $2 > /dev/null
fi

# Update Emacs
kill -USR1 $(pgrep emacs)

# Restart dunst
pkill dunst > /dev/null 2>&1
dunst& > /dev/null 2>&1

# Start pywalfox daemon
pkill pywalfox
pywalfox daemon&

pywalfox update
