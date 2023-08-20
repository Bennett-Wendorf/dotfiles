#!/usr/bin/env bash
# check out https://github.com/Barbarossa93/Genome/tree/main/.config/qtile for much of the basis of this script
set -euo pipefail

script_name="eww_vol.sh"
for pid in $(pgrep -f $script_name); do
    if [ $pid != $$ ]; then
        kill -9 $pid
    fi 
done

change_amount=5

case $1 in
    up)
        amixer -D pulse sset Master "$change_amount"%+
    ;;
    down)
        amixer -D pulse sset Master "$change_amount"%-
    ;;
    mute)
        amixer -D pulse set Master 1+ toggle
    ;;
esac

state="$(eww windows | grep vol)"

# This will make the widget show up on the current monitor in qtile, but it greatly increases the time it takes the widget to show up
# current_monitor_qtile="$(qtile cmd-obj -o screen -f info | awk -F ',' '{print $2}' | sed 's/[^0-9]//g')"

current_monitor="$(~/.config/eww/scripts/get_curr_screen.sh)"

if [ ! "$state" == "*vol" ]; then
    eww open vol --screen "$current_monitor"
    state="$(eww windows | grep vol)"
fi

start=$SECONDS

while [ "$state" == "*vol" ]; do
    duration=$(( SECONDS - start ))
    if [[ $duration -gt 1 ]]; then
        eww close vol       
        state="$(eww windows | grep vol)"
    fi
    sleep 0.2
done