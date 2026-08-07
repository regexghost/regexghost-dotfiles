#!/bin/sh

VOLUME_CACHE_FILE="$XDG_CACHE_HOME/panel_volume/volume"
MUTED_CACHE_FILE="$XDG_CACHE_HOME/panel_volume/muted"
SINK_CACHE_FILE="$XDG_CACHE_HOME/panel_volume/sink"

if [ "$2" = "--bluez" ]; then
	sink="$(pactl list sinks | grep "Name:" | grep "bluez" | sed 's/.*Name: //g')"
	echo "bluez" > "$SINK_CACHE_FILE"
else
	sink="@DEFAULT_SINK@"
	echo "default" > "$SINK_CACHE_FILE"
fi

volume_up () {
	current_volume=$(pactl get-sink-volume "$sink" | awk ' /Volume/ {print $5}' | sed 's/%//g')
	if [ $current_volume -gt 97 ]; then
		pactl set-sink-volume "$sink" 100%
		echo "100" > "$VOLUME_CACHE_FILE"
	else
		pactl set-sink-volume "$sink" +3%
		echo $((current_volume+3)) > "$VOLUME_CACHE_FILE"
	fi
}

volume_down () {
	current_volume=$(pactl get-sink-volume "$sink" | awk ' /Volume/ {print $5}' | sed 's/%//g')
	if [ $current_volume -lt 3 ]; then
		pactl set-sink-volume "$sink" 0%
		echo "0" > "$VOLUME_CACHE_FILE"
	else
		pactl set-sink-volume "$sink" -3%
		echo $((current_volume-3)) > "$VOLUME_CACHE_FILE"
	fi
}

toggle_mute () {
	pactl set-sink-mute "$sink" toggle
	pactl get-sink-mute "$sink" | awk '{print $2}' > "$MUTED_CACHE_FILE"
}

if [ "$1" = "--up" ]; then
	volume_up
elif [ "$1" = "--down" ]; then
	volume_down
elif [ "$1" = "--toggle-mute" ]; then
	toggle_mute
fi

barpid="$(cat ~/.cache/bar_pid)"
if ! [ "$barpid" = "" ]; then
	kill -34 "$barpid"
fi
