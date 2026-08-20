#!/bin/sh

# Reddit gallery link viewer

OUTPUT_FOLDER="/tmp/reddit_images"

[ -d "$OUTPUT_FOLDER" ] && rm -rf "/tmp/reddit_images"
mkdir -p "$OUTPUT_FOLDER"

cd "$OUTPUT_FOLDER"

notify-send "Downloading"

gallery-dl "$1"

notify-send "Displaying"

${IMAGE_VIEWER:-feh} "$OUTPUT_FOLDER"/*/*/*/
