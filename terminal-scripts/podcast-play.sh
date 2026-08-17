#!/bin/sh

LOC="$HOME/Videos/Podcasts"

vid="$(find "${LOC}/" -type f | sed "s|${LOC}/||g" | fzf)"

[ "$vid" = "" ] && exit

fullpath="${LOC}/${vid}"

${VIDEO_PLAYER:-mpv} "$fullpath"

read -p "Delete podcast? (y/N) " yesOrNoDelete

if [ "$yesOrNoDelete" = "y" ] || [ "$yesOrNoDelete" = "Y" ]; then
	trash-put "$fullpath"
fi
