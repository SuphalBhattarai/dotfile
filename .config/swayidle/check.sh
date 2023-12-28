#!/usr/bin/bash

# -z = empty string
# before(){
#     grimshot save screen /tmp/shot.jpg
#     convert /tmp/shot.jpg -gaussian-blur 0x4 -blur 0x4 /tmp/shot.jpg
# }
running=$(pactl list | rg -i running)
if [[ -z $running ]]; then
    # before
    # gtklock -b /tmp/shot.jpg &
    swaylock &
fi
