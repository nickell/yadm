#!/bin/bash

windowname=$(xdotool getwindowfocus getwindowclassname)

if [ "$windowname" = "kitty" ]; then
  xdotool key --clearmodifiers Ctrl+Shift+n
else
  kitty
fi
