#!/bin/bash

#run i3lock with given parameters

timecolor="FFFFFFFF"
datecolor="FFFFFFFF"
background="/home/bennett/Desktop/pics/rAqXlM.jpg"

i3lock --clock --indicator --timecolor=$timecolor --datecolor=$datecolor --pass-media-keys --pass-screen-keys --pass-power-keys --image=$background
