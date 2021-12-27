#!/usr/bin/env bash
set -euo pipefail

state=$(eww windows | grep sidebar)

# This will make the widget show up on the current monitor in qtile, but it greatly increases the time it takes the widget to show up
# current_monitor_qtile="$(qtile cmd-obj -o screen -f info | awk -F ',' '{print $2}' | sed 's/[^0-9]//g')"

current_monitor="$(~/.config/eww/scripts/get_curr_screen.sh)"

if [ "$state" == "*sidebar" ]; then
    eww close sidebar
else
    eww open sidebar --screen "$current_monitor"
fi