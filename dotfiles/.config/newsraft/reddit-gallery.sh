#!/bin/sh

# Reddit gallery link to actual, full size image links

USER_AGENT="NetSurf/3.10 (Linux)"
OUTPUT_FOLDER="/tmp/reddit_images"

[ -d "$OUTPUT_FOLDER" ] && rm -rf "/tmp/reddit_images"
mkdir -p "$OUTPUT_FOLDER"

notify-send "Extracting"

url="$1"
id="$(echo "$url" | cut -d "/" -f 5)"

curl -s -L --user-agent "$USER_AGENT" "https://old.reddit.com/${id}" > /tmp/reddit_gallery.html

links="$(cat /tmp/reddit_gallery.html | pup 'a[class="may-blank gallery-item-thumbnail-link"]' | grep gallery-item-thumbnail-link | sed -nE 's/.*(https:\/\/[^"]*).*/\1/p' | xmlstarlet unesc | grep -v ".gif$")"

notify-send "Downloading"

for link in $links; do
	wget --hsts-file="$XDG_STATE_HOME/wget-hsts" -P "$OUTPUT_FOLDER" "$link" &
done
wait

cd "$OUTPUT_FOLDER"; rename 's/[?].*//g' *

notify-send "Displaying"
notify-send "$IMAGE_VIEWER"
${IMAGE_VIEWER:-feh} "$OUTPUT_FOLDER"/*
