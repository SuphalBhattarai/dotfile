#!/bin/bash
blight set -5%
notify-send 'Brightness' "The current brightness is $(blight get)"
