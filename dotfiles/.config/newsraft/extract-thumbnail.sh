#!/bin/sh

URL="$1"
OUTPUT_FILENAME="${2:-/tmp/youtube_thumbnail.webp}"

video_id=$(echo $URL | sed 's/.*[?]v=//g')
if echo "$video_id" | grep -q "www."; then
	video_id=$(echo "$URL" | sed 's/.*\/shorts\///g')
elif echo "$video_id" | grep -q "youtu.be"; then
	video_id="$(echo "$URL" | sed 's/.*youtu.be\///g')"
fi

video_id="$(echo "$video_id" | sed 's/?.*//g')"

wget "https://i.ytimg.com/vi_webp/${video_id}/maxresdefault.webp" -P /tmp
mv /tmp/maxresdefault.webp "$OUTPUT_FILENAME"
