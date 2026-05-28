#!/usr/bin/env bash

for arg; do
	id="$(yt-dlp --flat-playlist -J --playlist-end 1 "$arg" | jq -r .channel_id)"
	echo https://www.youtube.com/feeds/videos.xml?channel_id="${id}"
done
