#!/usr/bin/env bash

# Icon location is set in dunstrc template

notify-send -i element -u low "Test notification" "of low priority. With a bunch of text! The image is mostly green."
notify-send -i bluetooth -u normal "Test notification" "of normal priority. With a bunch of text! The image is mostly blue."
notify-send -i gtk-dialog-error -u critical "Test notification" "of critical priority. With a bunch of text! The image is mostly red."
