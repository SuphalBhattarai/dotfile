#!/bin/bash
blight set -5%

x=$(blight get)
notify-send 'Brightness' "The current brightness is $(($x*100/255))%"
