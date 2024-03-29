#!/usr/bin/bash

# Call this script with ./brightnessControl.sh up/down

function send_notification {
	current_brightness=$(brightnessctl -d intel_backlight g)
	max_brightness=$(brightnessctl -d intel_backlight m)
	icon="./symbolic/display-brightness-medium-symbolic"
	scripts_folder=$(dirname $(realpath $0))
	bar=$($scripts_folder/getProgressBar.sh 20 $current_brightness $max_brightness)
	# Send the notification with custom app name for styling via dunst rules
	dunstify -i "$icon" -r 55555 -a "brightness/volume_control" "$bar"	
}

case $1 in
	up)
		# Increase the backlight by 10%
		# brightnessctl -d intel_backlight s +10%
		xbacklight -inc 10
		send_notification
		;;
	down)
		# Decrease the backlight by 10%
		# brightnessctl -d intel_backlight s 10%-
		xbacklight -dec 10
		send_notification
		;;
esac
