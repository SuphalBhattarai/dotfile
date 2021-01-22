#!/usr/bin/bash
rg "^Exec" /usr/share/applications/ | sed -r 's/\/.*\///g' | sed 's/.*\:Exec=//' | awk '{print }' | dmenu | bash
