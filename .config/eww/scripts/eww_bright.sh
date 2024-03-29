#!/usr/bin/env bash
# check out https://github.com/Barbarossa93/Genome/tree/main/.config/qtile for much of the basis of this script
set -euo pipefail

script_name="eww_bright.sh"
for pid in $(pgrep -f $script_name); do
    if [ $pid != $$ ]; then
        kill -9 $pid
    fi 
done

change_amount=10

case $1 in
    up)
        xbacklight -inc "$change_amount"
    ;;
    down)
        xbacklight -dec "$change_amount"
    ;;
esac

# This will make the widget show up on the current monitor in qtile, but it greatly increases the time it takes the widget to show up
# current_monitor_qtile="$(qtile cmd-obj -o screen -f info | awk -F ',' '{print $2}' | sed 's/[^0-9]//g')"

current_monitor="$(~/.config/eww/scripts/get_curr_screen.sh)"

if ! $(eww active-windows | grep -q bright); then
    eww open bright --screen "$current_monitor"
fi

start=$SECONDS

while $(eww active-windows | grep -q bright); do
    duration=$(( SECONDS - start ))
    if [[ $duration -gt 1 ]]; then
        eww close bright       
    fi
    sleep 0.2
done
