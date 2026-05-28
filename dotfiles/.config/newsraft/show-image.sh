#!/bin/sh

if echo "$1" | grep -q "youtube"; then
	~/.config/newsraft/extract-thumbnail.sh "$1"
	feh /tmp/youtube_thumbnail.webp
	rm -f /tmp/youtube_thumbnail.webp
	rm -f /tmp/maxresdefault.webp
elif echo "$1" | grep -q "redd.it"; then
	filename="$(echo "$1" | sed 's/.*\///g')"
	wget -P /tmp "$1"
	feh "/tmp/${filename}"
	rm -rf "/tmp/${filename}"
fi
