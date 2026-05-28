#!/bin/sh

# Get basic data for a YouTube video

url="$1"
TEMP_FILE=/tmp/yt-data.html

curl -s "$url" > "$TEMP_FILE"

title="$(cat "$TEMP_FILE" | sed -nE 's/.*videoDescriptionHeaderRenderer":\{"title":\{"runs":\[\{"text":"([^}]*)"\}.*/\1/p')"
channel="$(cat "$TEMP_FILE" | sed -nE 's/.*ownerProfileUrl[^@]*@([^"]*).*/\1/p' | head -n 1)"
description="$(cat "$TEMP_FILE" | sed -nE 's/.*videoDescriptionHeaderRenderer":\{"title":\{"runs":\[\{"text":"([^}]*).*/\1/p' | sed -nE 's/([^\]*)(\\n|").*/\1/p')"..
release_date="$(cat "$TEMP_FILE" | sed -nE 's/.*publishDate":\{"simpleText":"([^"]*)".*/\1/p')"

echo "$title"
echo "$channel"
echo "$description"
echo "$release_date"
