#!/bin/bash
rm -rf /home/suphal/Pictures/screen
mkdir /home/suphal/Pictures/screen
sleep 1
scrot -e 'mv $f /home/suphal/Pictures/screen/screen.png'
sleep 1
convert /home/suphal/Pictures/screen/screen.png -filter Gaussian -blur 0x6 /home/suphal/.cache/i3lock/current/l_blur.png
sleep 2
betterlockscreen --lock blur
