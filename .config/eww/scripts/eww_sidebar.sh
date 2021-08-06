#!/usr/bin/env bash
set -euo pipefail

state=$(eww windows | grep sidebar)

if [ "$state" == "*sidebar" ]; then
    eww close sidebar
else
    eww open sidebar
fi