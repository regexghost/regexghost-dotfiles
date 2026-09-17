#!/bin/sh

LOC="$HOME/Videos/YouTube"

if [ "$1" = "-s" ] || [ "$1" = "s" ]; then
	dir="Shorts"
	shift
else
	dir="Videos"
fi

# Remove .txt files as there might be yt-dlp archive files, and sh scripts
vid="$(find "${LOC}/${dir}/" -type f | grep -v "[.]txt$" | grep -v "[.]sh$" | sed "s|${LOC}/${dir}/||g" | grep -i "^${1}" | fzf)"

[ "$vid" = "" ] && exit

fullpath="${LOC}/${dir}/${vid}"

${VIDEO_PLAYER:-mpv} "$fullpath"

read -p "Delete video? (y/N) " yesOrNoDelete

if [ "$yesOrNoDelete" = "y" ] || [ "$yesOrNoDelete" = "Y" ]; then
	trash-put "$fullpath"
fi
