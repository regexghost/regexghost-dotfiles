#!/bin/sh

LOC="${HOME}/Videos/YouTube/toDownload"

notify () {
	if [ -t 1 ]; then
		echo "$1"
	else
		notify-send "$1"
	fi
}

[ -d "$LOC" ] || mkdir -p "$LOC"
[ -d "$LOC/Shorts" ] || mkdir "$LOC/Shorts"
[ -d "$LOC/Videos" ] || mkdir "$LOC/Videos"

if echo "$1" | grep -q "youtube.com/watch"; then
	id="$(echo "$1" | sed -nE 's/.*=(.*)/\1/p')"
	setsid yt-data "$1" > "${LOC}/Videos/${id}.txt" &
elif echo "$1" | grep -q "youtube.com/shorts"; then
	id="$(echo "$1" | sed -nE 's/.*\/(.*)/\1/p')"
	setsid yt-data "$1" > "${LOC}/Shorts/${id}.txt" &
elif echo "$1" | grep -q ".mp3"; then
	echo "$1" >> "${HOME}/Videos/Podcasts/toDownload.txt"
	notify "Podcast Queued"
	exit
else
	notify "Not a video or podcast"
	exit
fi

notify "Video Queued"
