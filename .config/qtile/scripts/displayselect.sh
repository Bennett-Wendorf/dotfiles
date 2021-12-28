#!/bin/bash

# Thanks to https://github.com/pawndev/rofi-autorandr for most of this script

set -u
set -e

# Leave this as an empty string to disable theme and use Rofi default
rofi_theme="-theme $HOME/.config/rofi/launchers/colorful/style_13"

function main()
{
    local layouts="$(autorandr)"

    local layout=$( (echo "${layouts}")  | rofi $rofi_theme -dmenu -p "Layout:")
    local matching=$( (echo "${layouts}") | grep "^${layout}$")

    autorandr --load $matching
}

main