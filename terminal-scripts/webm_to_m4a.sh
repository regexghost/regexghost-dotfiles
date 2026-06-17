#!/usr/bin/env bash

oldIFS="$IFS"
IFS=$'\n'
files=( $(find initial/ -type f) )
IFS="$oldIFS"

for file in "${files[@]}"; do
	echo $file
	new="$(echo "$file" | sed 's/webm$/m4a/g; s/^initial/done/g')"
	dir="$(dirname "$new")"
	[ -d "$dir" ] || mkdir "$dir"
	ffmpeg -i "$file" -map_metadata -1 -vn -acodec aac -aac_pns 0 "$new"
done
