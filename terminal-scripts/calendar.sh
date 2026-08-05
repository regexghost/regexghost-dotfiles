#!/bin/sh

MAGENTA_COLOUR='\033[0;35m\033[1m'
RED_COLOUR='\033[0;34m\033[1m'
BLUE_COLOUR='\033[0;36m\033[1m'
RESET_COLOUR='\033[0m'

suffix () {
	if [ "$1" = "1" ] || [ "$1" = "21" ] || [ "$1" = "31" ]; then
		echo "st"
	elif [ "$1" = "2" ] || [ "$1" = "22" ]; then
		echo "nd"
	elif [ "$1" = "3" ] || [ "$1" = "23" ]; then
		echo "rd"
	else
		echo "th"
	fi
}

# Unbuffer keeps the little box around the current day, sed deletes empty line at the end
unbuffer cal -w -n 3 "$@" | sed '/^ *$/d'

day="$(date +'%A')"
date="$(date +'%d')"
week="$(date +'%V')"

echo "${RED_COLOUR}Day:${RESET_COLOUR}  ${day}"
echo "${BLUE_COLOUR}Date:${RESET_COLOUR} ${date}$(suffix $date)"
echo "${MAGENTA_COLOUR}Week:${RESET_COLOUR} ${week}"
