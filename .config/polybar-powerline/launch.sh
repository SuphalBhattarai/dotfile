#!/usr/bin/env sh

## Add this to your wm startup file.

killall -q polybar

# wait until they die of blood loss
while pgrep -x polybar >/dev/null; do sleep 1; done

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar -c ~/.config/polybar/config.ini main &
