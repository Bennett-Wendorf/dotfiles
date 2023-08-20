#!/bin/bash
set -e
set -o pipefail

tmp_dir="/tmp/spotify"
tmp_cover_path=$tmp_dir/cover.png

if [ ! -d $tmp_dir ]; then
	mkdir -p $tmp_dir
fi

if [ ! -f "$tmp_cover_path" ]; then
	cp ~/.config/eww/images/image.png $tmp_cover_path;
fi

stdbuf -o0 playerctl metadata mpris:artUrl | sed -e 's/open.spotify.com/i.scdn.co/g' |
	while read arturl; do
		if [[ "$arturl" == http?(s)://* ]]; then
			curl -s "$arturl" --output $tmp_cover_path;
		else
			cp ~/.config/eww/images/image.png $tmp_cover_path;
		fi
	done