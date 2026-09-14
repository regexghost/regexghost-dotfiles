#!/bin/sh

while true; do
	sleep 4
	if bluetoothctl devices | grep -q Inateck; then
		if ! setxkbmap -query | grep -q "caps:escape"; then
			~/.local/share/regexghost/wm-scripts/keyboard-settings.sh
		fi
	fi
done
