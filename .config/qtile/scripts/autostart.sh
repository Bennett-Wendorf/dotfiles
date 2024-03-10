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
megasync &
# run onedrive_tray &
screenrotator &
run greenclip daemon &
wal -restore &
$HOME/scripts/xss-lock.sh
$HOME/scripts/xidlehook.sh
xset s off -dpms
eww daemon &
run solaar -w hide &
