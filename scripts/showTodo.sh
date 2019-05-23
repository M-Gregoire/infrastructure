#!/usr/bin/env bash
SSID=$(iwgetid -r)

# Ethernet
if [ -z "$SSID" ]
then
    task project.not:Work
# Wifi
else
    # In the office
    if [ "$SSID" = "$WORKWIFI" ]
    then
	task project:Work
    # Elsewhere
    else
	task project.not:Work
    fi
fi
