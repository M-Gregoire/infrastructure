#!/usr/bin/env bash
LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
if [ $LAYOUT = "us" ]
then
    setxkbmap -layout fr -option
elif [ $LAYOUT = "fr" ]
then
    setxkbmap -layout us -option compose:ralt
fi
