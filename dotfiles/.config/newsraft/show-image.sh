#!/bin/sh

if echo "$1" | grep -q -e "youtube" -e "youtu.be" -e youtube.com/shorts; then
	~/.config/newsraft/extract-thumbnail.sh "$1"
	${IMAGE_VIEWER:-feh} /tmp/youtube_thumbnail.webp
	rm -f /tmp/youtube_thumbnail.webp
	rm -f /tmp/maxresdefault.webp
elif echo "$1" | grep -q "redd.it"; then
	filename="$(echo "$1" | sed 's/.*\///g')"
	wget -P /tmp "$1"
	${IMAGE_VIEWER:-feh} "/tmp/${filename}"
	rm -rf "/tmp/${filename}"
elif echo "$1" | grep -q "reddit.com/gallery"; then
	~/.config/newsraft/reddit-gallery.sh "$1"
fi
