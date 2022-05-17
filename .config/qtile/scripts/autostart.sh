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
xss-lock --transfer-sleep-lock -- $HOME/.config/i3lock/i3lock.sh --nofork &
killall xidlehook
$HOME/scripts/xidlehook.sh
eww daemon &
