#!/bin/sh

LOC="${HOME}/Videos/YouTube/toDownload"
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
	notify-send "Podcast Queued"
	exit
else
	notify-send "Not a video or podcast"
	exit
fi

notify-send "Video Queued"
