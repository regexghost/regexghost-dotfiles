#!/bin/sh

# Wrapper for mv as suckless sbase doesn't have `mv -i`

if [ "$#" -eq 2 ]; then
	if [ -f "$2" ]; then
		read -p "Overwrite existing file? (y/N) " yesOrNo
		if [ "$yesOrNo" = "y" ] || [ "$yesOrNo" = "Y" ]; then
			mv "$1" "$2"
		fi
		exit
	else
		mv "$1" "$2"
	fi
else
	mv "$@"
fi
