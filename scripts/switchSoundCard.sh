#!/usr/bin/env bash
# paswitch 2011-02-02 by Ng Oon-Ee <ngoonee@gmail.com>
# I can't remember where I found this script, can't locate the original author.
# Please inform me if you know, so that I can give proper attribution.
# CHANGES: Added auto-move all inputs to new default sound card.
# WAS: Pulse Audio Sound Card Switcher v1.0 2010-01-13
#   Switches between soundcards when run. All streams are moved to the new default sound-card.

# $totalsc: Number of sound cards available
totalsc=$(pacmd "list-sinks" | grep card: | wc -l) # total of sound cards: $totalsc
if [ $totalsc -le 1 ]; then # Check whether there are actually multiple cards available
    notify-send -u critical -t 5000 "Nothing to switch, system only has one sound card."
    exit
fi
# $scindex: The Pulseaudio index of the current default sound card
scindex=$(pacmd list-sinks | awk '$1 == "*" && $2 == "index:" {print $3}')
# $cards: A list of card Pulseaudio indexes
cards=$(pacmd list-sinks | sed 's|*||' | awk '$1 == "index:" {print $2}')
PICKNEXTCARD=1 # Is true when the previous card is default
count=0 # count of number of iterations
for CARD in $cards; do
    if [ $PICKNEXTCARD == 1 ]; then
	# $nextsc: The pulseaudio index of the next sound card (to be switched to)
	nextsc=$CARD
	PICKNEXTCARD=0
	# $nextind: The numerical index (1 to totalsc) of the next card
	nextind=$count
    fi
    if [ $CARD == $scindex ]; then # Choose the next card as default
	PICKNEXTCARD=1
    fi
    count=$((count+1))
done
pacmd "set-default-sink $nextsc" # switch default sound card to next

# $inputs: A list of currently playing inputs
inputs=$(pacmd list-sink-inputs | awk '$1 == "index:" {print $2}')
for INPUT in $inputs; do # Move all current inputs to the new default sound card
    pacmd move-sink-input $INPUT $nextsc
done
# $nextscdec: The device.description of the new default sound card
# NOTE: This is the most likely thing to break in future, the awk lines may need playing around with
nextscdesc=$(pacmd list-sinks | awk '$1 == "device.description" {print substr($0,5+length($1 $2))}' \
                 | sed 's|"||g' | awk -F"," 'NR==v1{print$0}' v1=$((nextind+1)))
notify-send "Default sound-card changed to $nextscdesc"
exit
# Below text was from original author and remains unaltered
# CC BY - creative commons
# Thanks God for help :) and guys lhunath, geirha, Tramp and others from irc #bash on freenode.net
