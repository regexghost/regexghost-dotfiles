#!/bin/sh

# Get basic data for a YouTube video without yt-dlp

url="$1"
TEMP_FILE=/tmp/yt-data.html

curl -s "$url" > "$TEMP_FILE"

title="$(cat "$TEMP_FILE" | tr "}" "\n" | grep "videoDetails\":{\"videoId" | sed -nE 's/.*"title":"([^"]*).*/\1/p')"
channel="$(cat "$TEMP_FILE" | tr "}" "\n" | grep ownerProfileUrl | head -n 1 | sed -nE 's/.*https?:\/\/www.youtube.com\/[@]([^"]*).*/\1/p')"
description="$(cat "$TEMP_FILE" | tr "}" "\n" | grep "shortDescription" | head -n 1 | sed -nE 's/.*shortDescription":"([^"]*)".*/\1/p' | sed 's/\\u0026/\&/g')"
release_date="$(cat "$TEMP_FILE" | tr "}" "\n" | grep "publishDate\":{\"simpleText\"" | sed -nE 's/.*publishDate":\{"simpleText":"([^"]*).*/\1/p')"
[ "$description" = "" ] && description="$title"

echo "$title"
echo "$channel"
echo "$description"
echo "$release_date"
