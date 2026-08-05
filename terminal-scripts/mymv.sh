#!/bin/sh

# Wrapper for mv as suckless sbase doesn't have `mv -i`

if [ "$#" -eq 2 ]; then
	file="$2"
	[ -d "$file" ] && file="${2}/$(basename "$1")"
	if [ -f "$file" ]; then
		read -p "Overwrite existing file? (y/N) " yesOrNo
		if [ "$yesOrNo" = "y" ] || [ "$yesOrNo" = "Y" ]; then
			mv "$1" "$file"
		fi
		exit
	else
		mv "$1" "$file"
	fi
else
	mv "$@"
fi
