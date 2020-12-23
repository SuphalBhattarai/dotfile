#!/bin/bash

value=$(cat /sys/class/backlight/radeon_bl0/actual_brightness)
percent=$((value * 100 / 255))
echo $percent"%"
