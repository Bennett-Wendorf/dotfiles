#!/bin/bash

connected_screens=$(xrandr | grep -w 'connected')

screen_info=()

while IFS= read -r line; do
    dim=$(echo "$line" | awk '{ print $3 }')
    if [ "$dim" == "primary" ]; then
        dim=$(echo "$line" | awk '{ print $4 }')
    fi
    screen_info+=("$dim")
done <<< "$connected_screens"

window_geometry=$(xdotool getwindowgeometry --shell "$(xdotool getwindowfocus)")

window_x=$(echo "$window_geometry" | awk -F= '/X/ { print $2 }')
window_y=$(echo "$window_geometry" | awk -F= '/Y/ { print $2 }')

focused_screen_index=-1
for i in "${!screen_info[@]}"; do
    screen_dimensions="${screen_info[$i]}"
    screen_x=$(echo "$screen_dimensions" | cut -d'+' -f2)
    screen_y=$(echo "$screen_dimensions" | cut -d'+' -f3)
    screen_width=$(echo "$screen_dimensions" | cut -dx -f1)
    screen_height=$(echo "$screen_dimensions" | cut -dx -f2 | cut -d'+' -f1)

    if [ "$window_x" -ge "$screen_x" ] && [ "$window_x" -lt "$((screen_x + screen_width))" ] &&
       [ "$window_y" -ge "$screen_y" ] && [ "$window_y" -lt "$((screen_y + screen_height))" ]; then
        focused_screen_index="$i"
        break
    fi
done

printf "$focused_screen_index"
