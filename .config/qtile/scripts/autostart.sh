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
run volumeicon &
nitrogen --restore &