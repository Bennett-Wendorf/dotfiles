#!/bin/bash
dir="/tmp"
params=$(flameshot gui -g)

# Use IFS to split on both 'x' and '+'
IFS='x+' read -r w h x y <<< "$params"

# Round down to nearest even number
w=$(( w / 2 * 2 ))
h=$(( h / 2 * 2 ))

now=$(date "+%F_%H-%M-%S")
filename="${dir}/${now}.mp4"
ffmpeg -video_size "${w}x${h}" -framerate 30 -f x11grab -i :0.0+"$x","$y" -c:v libx264 -pix_fmt yuv420p -movflags +faststart "${filename}"   
