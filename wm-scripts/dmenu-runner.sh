#!/bin/sh

. "$XDG_CONFIG_HOME/regexghost/current-theme.sh"

# Check for index and print anyway arguments
arg1=""
arg2=""
for arg; do
	if [ "$arg" = "-ix" ]; then
		arg1="-ix"
	elif [ "$arg" = "-pa" ]; then
		arg2="-pa"
	fi
done

dmenu -i $arg1 $arg2 -p "$1" -l 20 -fn "$FONT_FAMILY: 14" -nb "#${BACKGROUND_BLACK}" -nf "#${FOREGROUND_WHITE}" -pb "#${BACKGROUND_BLACK}" -pf "#${FOREGROUND_WHITE}" -sb "#${BLUE}" -sf "#${BLACK}" -bb "#${GREEN}"
