#!/usr/bin/env bash
# check out https://github.com/Barbarossa93/Genome/tree/main/.config/qtile for much of the basis of this script
set -euo pipefail

if [ -e /tmp/bright ]; then
    true
else
    touch /tmp/bright && echo "$(xbacklight -get | cut -d . -f 1)" > /tmp/bright 
fi

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

echo "$(xbacklight -get | cut -d . -f 1)" > /tmp/bright

state="$(eww windows | grep vol)"

if [ ! "$state" == "*vol" ]; then
    current_monitor_qtile="$(qtile cmd-obj -o screen -f info | awk -F ',' '{print $2}' | sed 's/[^0-9]//g')"
    eww open bright -m "$current_monitor_qtile"
    state="$(eww windows | grep bright)"
fi

start=$SECONDS

while [ "$state" == "*bright" ]; do
    duration=$(( SECONDS - start ))
    if [[ $duration -gt 1 ]]; then
        eww close bright       
        state="$(eww windows | grep bright)"
    fi
    sleep 0.2
done