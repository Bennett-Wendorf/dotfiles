#!/usr/bin/env bash
set -euo pipefail

state=$(eww windows | grep sidebar)

if [ "$state" == "*sidebar" ]; then
    eww close sidebar
else
    current_monitor_qtile="$(qtile cmd-obj -o screen -f info | awk -F ',' '{print $2}' | sed 's/[^0-9]//g')"
    eww open sidebar -m "$current_monitor_qtile"
fi