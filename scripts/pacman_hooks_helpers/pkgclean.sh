#!/bin/sh
yaycache="$(find /home/bennett/.cache/yay/ -maxdepth 1 -type d | tail -n +2 | awk '{ printf "-c %s ",$1 }')"

/usr/bin/paccache -rvk1 -c /var/cache/pacman/pkg $yaycache
