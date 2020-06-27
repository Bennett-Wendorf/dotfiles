#!/usr/bin/bash

# Call this script with ./brightnessControl.sh up/down

function send_notification {
	current_brightness=$(brightnessctl -d intel_backlight g)
	max_brightness=$(brightnessctl -d intel_backlight m)
	icon="./symbolic/display-brightness-medium-symbolic"
	scripts_folder=$(dirname $(realpath $0))
	bar=$($scripts_folder/getProgressBar.sh 20 $current_brightness $max_brightness)
	# Send the notification
	dunstify -i "$icon" -r 55555 -u control "$bar"	
}

case $1 in
	up)
		# Increase the backlight by 10%
		brightnessctl -d intel_backlight s +10%
		send_notification
		;;
	down)
		# Decrease the backlight by 10%
		brightnessctl -d intel_backlight s 10%-
		send_notification
		;;
esac
