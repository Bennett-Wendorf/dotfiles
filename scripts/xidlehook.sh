#!/bin/bash

flags="--not-when-fullscreen --not-when-audio"

timer_len="1800"

action_command="$HOME/.config/i3lock/i3lock.sh"

# xidlehook will not manage its own instances, so we need to make sure that it is never launched without killing current instances first
killall xidlehook
xidlehook $flags --timer $timer_len $action_command '' &
