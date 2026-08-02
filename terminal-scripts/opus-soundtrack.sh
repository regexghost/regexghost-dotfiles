#!/usr/bin/env bash

set -e

BITRATE_KBPS="100"

oldIFS="$IFS"
IFS=$'\n'
dirs=( $(find m4asoundtracks/ -type d -links 2 | sort) )
soundtracks=( $(find m4asoundtracks/ -type f | grep -v 'output.jpg$' | sort) )
IFS="$oldIFS"

[ -d opus/ ] && rm -rf opus
mkdir opus

for dir in "${dirs[@]}"; do
	echo "Dir: ${dir}"
	firstFile="$(find "$dir" -type f | grep 'm4a$' |  head -n 1)"
	outputDir="$(echo "$dir" | sed 's/^m4asoundtracks/opus/g')"
	mkdir -p "$outputDir"
	echo "First File: ${firstFile}"
	ffmpeg -y -i "$firstFile" -map 0:1 "$dir/output.jpg"
	cp "${dir}/output.jpg" "${outputDir}/output.jpg"
done

i=0
for file in "${soundtracks[@]}"; do
	echo File: "$file"
	outputFile="$(echo "$file" | sed 's/^m4asoundtracks/opus/g' | sed 's/m4a$/opus/g')"
	outputDir="$(dirname "$outputFile")"
	mkdir -p "$outputDir"
	echo ffmpeg -i "$file" -b:a "${BITRATE_KBPS}000" "$outputFile"
	ffmpeg -i "$file" -b:a "${BITRATE_KBPS}000" "$outputFile"
	opustags --set-cover "$outputDir/output.jpg" "$outputFile" -i
	i=$((i+1))
done
