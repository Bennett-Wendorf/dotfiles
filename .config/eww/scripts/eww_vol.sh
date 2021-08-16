#!/usr/bin/env bash
# check out https://github.com/Barbarossa93/Genome/tree/main/.config/qtile for much of the basis of this script
set -euo pipefail

check_mute() {
    muted=$(amixer get Master | tail -2 | grep -c '\[on\]')
    if [[ "$muted" == "2" ]]; then
        # Then we are not muted because left and right channels show 'on'
        echo "" > /tmp/vol-icon
    else 
        echo "" > /tmp/vol-icon
    fi
}

if [ -e /tmp/vol ] && [ -e /tmp/vol-icon ]; then
    true
else
    touch /tmp/vol && echo "$(amixer get Master | grep % | awk '{print $5}'| sed 's/[^0-9]//g' | tail -1)" > /tmp/vol 
    touch /tmp/vol-icon && check_mute
fi

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
        # Used '|| true' here to ensure the command returns with success code
        muted="$(amixer get Master | tail -2 | grep -c '\[on\]' || true)"
        if [[ "$muted" == "2" ]]; then
            # Then we are not muted because left and right channels show 'on'
            echo "" > /tmp/vol-icon
        else 
            echo "" > /tmp/vol-icon
        fi
        
        if [ "$(eww windows | grep vol)" == "*vol" ]; then
            # Then the volume window is open and we should close it to allow for icon refresh
            eww close vol
        fi
    ;;
esac

echo $(amixer get Master | grep % | awk '{print $5}'| sed 's/[^0-9]//g' | tail -1) > /tmp/vol 

state="$(eww windows | grep vol)"

if [ ! "$state" == "*vol" ]; then
    # This will make the widget show up on the current monitor in qtile, but it greatly increases the time it takes the widget to show up
    current_monitor_qtile="$(qtile cmd-obj -o screen -f info | awk -F ',' '{print $2}' | sed 's/[^0-9]//g')"
    eww open vol -m "$current_monitor_qtile"
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