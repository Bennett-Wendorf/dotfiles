#!/bin/bash

# Run i3lock with given parameters

# Any of the capitalized sections can be commented out with a '#' to be omitted from the command

use_image=false
use_bar=false
debug=false

font_color="000000ff"
dark_font_color="000000ff"
font="Hack"
greeter_font="Font Awesome 6 Free Solid"
date_time_size=50
image="/home/bennett/files/Pics/Lock_Bg.jpg"
base_color="303030ff"
clear_color="00000000"
accent_color="86c8e0ff"
verify_color="348e71ff"

# Pre lock hooks
function pre_lock() {
	:
}

# Stuff to render on top of the i3lock screen
function on_lock() {
    :
}

# Post unlock hooks
function post_unlock() {
    :
}

if $use_image; then
	BACKGROUND=( --image=$image -t)
else
	BACKGROUND=(-B 10)
fi

RING=( --radius=30 --ring-width=5.0 --inside-color=$clear_color --ring-color=$base_color \
	--line-color=$base_color --keyhl-color=$accent_color --ind-pos="x+50:y+h-50" --insidever-color=$clear_color \
	--insidewrong-color=$clear_color --ringver-color=$verify_color --verif-text="" --wrong-text="X" --noinput-text="")

BAR=( --bar-indicator --bar-orientation=vertical --bar-color=$base_color --bar-position="x")

PARAM=( --clock --pass-media-keys --pass-screen-keys --pass-power-keys)

#This particular greeter requires that the greeter_font is a font that has a valid character for the text. Font awesome does this, so make sure it's installed!
GREETER=( --greeter-text="" --greeter-font="$greeter_font" --greeter-color=$base_color --greeter-pos="x+w/2:y+h/2+30" --greeter-size=100)

DATETIME=( --date-color=$font_color --time-color=$font_color --time-str="%I:%M:%S %p" \
	--time-size=$date_time_size --date-size=$date_time_size --date-str="%A %B %d, %Y" --time-pos="x+w/2:(y+h/2)-90" \
	--date-pos="x+w/2:(y+h/2)+120" --time-font=$font --date-font=$font)

command_params=()

if $debug; then
	command_params+=(--no-verify --debug)
fi

echo "Command params: "${command_params[@]}

for p in "${PARAM[@]}"; do
	command_params+=("$p")
done

if $use_bar; then
	for p in "${BAR[@]}"; do
		command_params+=("$p")
	done
else	
	for p in "${RING[@]}"; do
		command_params+=("$p")
	done
fi

for p in "${GREETER[@]}"; do
	command_params+=("$p")
done

for p in "${DATETIME[@]}"; do
	command_params+=("$p")
done

for p in "${BACKGROUND[@]}"; do
	command_params+=("$p")
done

echo ${command_params[@]}

pre_lock

i3lock "${command_params[@]}" -n & # -n and & are needed to ensure that $! gets the correct PID

PID=$!

sleep 1 # Give i3lock some time to properly render

on_lock # Run applications that we want to render on top of the lockscreen

wait "$PID"

post_unlock # Run any post unlock hooks
