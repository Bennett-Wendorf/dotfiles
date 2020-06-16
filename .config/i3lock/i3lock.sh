#!/bin/bash

#run i3lock with given parameters

timecolor="FFFFFFFF"
datecolor="FFFFFFFF"
background="/usr/share/wallpapers/DarkestHour/contents/images/1920x1080.jpg"

i3lock --clock --indicator --timecolor=$timecolor --datecolor=$datecolor --pass-media-keys --pass-screen-keys --pass-power-keys --image=$background
