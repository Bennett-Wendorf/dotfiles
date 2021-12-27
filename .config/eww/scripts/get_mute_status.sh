#!/bin/sh

if [ "$(amixer get Master | tail -2 | grep -c '\[on\]')" == 2 ]; then
    printf ""
else
    printf ""
fi