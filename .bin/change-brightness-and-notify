#!/bin/bash
# changeBrightness

source /home/chad/.dotfiles/arch/bin/get-progress-string.sh

# Arbitrary but unique message id
msgId="991052"

# Change the brightness using brightnessctl
brightnessctl set "$@" > /dev/null

# Query brightnessctl for the current brightness
brightness="$(brightnessctl -m | cut -d',' -f4 | sed s'/.$//')"

# Show the volume notification
dunstify -a "changeBrightness" -u low -r "$msgId" -t 1000 \
"🔆: ${brightness}%" "<span font=\"monospace\">$(getProgressString 10 "#" "-" $brightness)</span>"
