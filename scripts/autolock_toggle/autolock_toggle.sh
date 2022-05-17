#!/bin/bash

set -u
set -e

# Leave this as an empty string to disable theme and use Rofi defualt
rofi_theme="-theme $HOME/.config/rofi/launchers/colorful/style_13"

function main() {
    local opts="Autolock on
Autolock off"

    local selected=$( (echo "${opts}") | rofi $rofi_theme -dmenu -p "Autolock:")

    local matching=$( (echo "${opts}") | grep "^${selected}$")

    if [[ $matching = "Autolock on" ]]; then
        $HOME/scripts/xidlehook.sh
        notify-send "Autolock Toggle" "🔒 ${matching}"
    else
        killall xidlehook
        notify-send "Autolock Toggle" "🔓 ${matching}"
    fi
}

main
