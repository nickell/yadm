#!/usr/bin/env sh

filename="$(date +%F\ %T)".png

ffcast -q -# "$(xdotool getactivewindow)" png /tmp/"$filename"
xclip -selection clipboard -t image/png -i /tmp/"$filename"
rm /tmp/"$filename"
