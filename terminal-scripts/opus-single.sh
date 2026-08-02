#!/usr/bin/env bash

BITRATE_KBPS="100"

oldIFS="$IFS"
IFS=$'\n'
files=( $(find m4asingle/ -type f | grep -v 'output.jpg$' | sort) )
IFS="$oldIFS"

[ -d opus/ ] && rm -rf opus
mkdir opus

i=0
for file in "${files[@]}"; do
	echo File: "$file"
	outputFile="$(echo "$file" | sed 's/^m4asingle/opus/g' | sed 's/m4a$/opus/g')"
	filename="$(basename "$file" | sed 's/.m4a//g')"
	outputDir="$(dirname "$outputFile")"
	mkdir -p "$outputDir"

	success=no
	ffmpeg -y -i "$file" -map 0:1 "${outputDir}/${filename}.jpg" && success=yes
	ffmpeg -i "$file" -b:a "${BITRATE_KBPS}000" "$outputFile"
	[[ "$success" == "yes"  ]] && opustags --set-cover "${outputDir}/${filename}.jpg" "$outputFile" -i
	i=$((i+1))
done
