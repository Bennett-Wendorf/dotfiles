#!/usr/bin/bash

# Call this script with ./volumeControl.sh up/down/toggle_mute

bar_length=20

function send_notification {
	scripts_folder=$(dirname $(realpath $0))
	case $1 in
		change_volume)
			current_volume=$(pactl list sinks | grep Volume | tail -n 2 | head -n 1| awk '{print $3}')
			echo "Current Volume: "$current_volume
			max_volume=$(pactl list sinks | grep Volume | tail -n 1 | awk '{print $3}')
			echo  "Max Volume: "$max_volume
			icon="./symbolic/audio-volume-high-symbolic"
			bar=$($scripts_folder/getProgressBar.sh $bar_length $current_volume $max_volume)
			# Send the notification with custom appname for styling via dunst rules
			dunstify -i "$icon" -r 66666 -a "brightness/volume_control" "$bar"
			;;
		mute)
			icon="./symbolic/audio-volume-muted-symbolic"
			# Send the notification with custom appname for styling via dunst rules
			dunstify -i "$icon" -r 66666 -a "brightness/volume_control" "Muted"
			;;
	esac
}

is_muted=$(pactl list sinks | grep "Mute" | tail -n 1 | awk '{print $2}')

echo "Is Muted: "$is_muted"!"

if [ $is_muted == "yes" ]; then
	# Handle operations for muted volume
	echo "Muted operations need to be handled here"
	case $1 in
		up)
			# Show notification that the system is muted
			send_notification mute
			;;
		down)
			# Show notification that the system is muted
			send_notification mute
			;;
		toggle_mute)
			# Toggle mute off
			pactl set-sink-mute @DEFAULT_SINK@ toggle
			send_notification change_volume
			;;
	esac
elif [ $is_muted == "no" ]; then
	# Handle normal non-muted operations
	echo "Non-muted operations need to be handled here"
	case $1 in
		up)
			# Increase the volume by 10%
			pactl set-sink-volume @DEFAULT_SINK@ +10%
			send_notification change_volume
			;;
		down)
			# Decrease the volume by 10%
			pactl set-sink-volume @DEFAULT_SINK@ -10%
			send_notification change_volume
			;;
		toggle_mute)
			# Mute the volume
			pactl set-sink-mute @DEFAULT_SINK@ toggle
			send_notification mute
			;;
	esac
else
	echo "This should not happen! The volume was neither muted nor not muted. Prepare for a headache!"
fi	
