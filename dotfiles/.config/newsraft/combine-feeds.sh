#!/bin/sh

TMP_DIR="/tmp/combined-feeds"

mkdir -p "$TMP_DIR"

while read feed; do
	url="$(echo "$feed" | cut -d " " -f 1)"
	name="$(echo "$feed" | cut -d " " -f 2-)"
	curl -s "$url" > "${TMP_DIR}/${name}.xml"
done < ~/.config/newsraft/combined-feeds.txt

xmlstarlet sel -t -c "//*[local-name()='entry']" "$TMP_DIR"/* | echo "<feed>$(cat)</feed>"
