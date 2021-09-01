#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

autorandr -c

#start the conky to learn the shortcuts
# (conky -c $HOME/.config/qtile/scripts/system-overview) &

#starting utility applications at boot time
# picom --config $HOME/.config/qtile/scripts/picom.conf &

#starting user applications at boot time
nitrogen --restore &
flameshot &
megasync &
# run onedrive_tray &
screenrotator &
run greenclip daemon &
wal -restore &
xss-lock --transfer-sleep-lock -- /home/bennett/.config/i3lock/i3lock.sh --nofork &
killall xidlehook
xidlehook --not-when-fullscreen --not-when-audio --timer 1800 '~/.config/i3lock/i3lock.sh' '' &
eww daemon &
