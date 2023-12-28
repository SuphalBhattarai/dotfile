#!/usr/bin/bash

# -n = non empty string
running=$(pgrep swaylock)
if [[ -n $running ]]; then
   sh ~/.config/swayidle/lock.sh  &
fi
