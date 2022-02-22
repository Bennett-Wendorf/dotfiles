#!/usr/bin/env bash
set -euo pipefail

screen_1_width=$(xrandr | grep '*' | awk '{print $1}' | head -n 1 | awk 'BEGIN { FS = "x" } ; { print $1 }')

mouse_x=$(xdotool getmouselocation --shell | grep "X=" | awk 'BEGIN { FS = "=" } ; { print $2 }')

if [[ $mouse_x -gt screen_1_width ]]; then
    printf "1"
else 
    printf "0"
fi
