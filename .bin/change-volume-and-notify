#!/bin/bash
# changeVolume

# Arbitrary but unique message id
msgId="991049"

# Unmute
pactl set-sink-mute @DEFAULT_SINK@ false

# Set volume
pactl set-sink-volume @DEFAULT_SINK@ $@

# Notify
dunstify -a "changeVolume" -u low -r "$msgId" -t 1000 "🔉: $(pamixer --get-volume-human)"
