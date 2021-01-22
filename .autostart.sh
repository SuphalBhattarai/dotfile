#!/bin/bash

apps=("picom" "dunst" "lxsession" "flameshot" "greenclip" "unclutter" "transmission-daemon")

for i in "${apps[@]}"; do
    x=$(pgrep $i)
    if [ $x -gt 100 ]; then
        killall $i
    fi
done
picom &
numlockx &
dunst &
lxsession &
flameshot &
greenclip daemon &
unclutter &
emacs --daemon &
nitrogen --random --set-scaled /home/suphal/Data/wallpapers/
transmission-daemon -w /home/suphal/Videos &
