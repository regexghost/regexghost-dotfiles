#!/usr/bin/env bash

channelUrl="$1"
if ! echo "$channelUrl" | grep -q "youtube.com"; then
	if echo "$1" | grep -q "@"; then
		channelUrl="https://www.youtube.com/${1}"
	else
		channelUrl="https://www.youtube.com/@${1}"
	fi
fi

name="$(echo "$channelUrl" | sed 's/.*@//g')"

id="$(yt-dlp --flat-playlist -J --playlist-end 1 "$channelUrl" | jq -r .channel_id)"
echo "https://www.youtube.com/feeds/videos.xml?channel_id=${id} ${name}"
