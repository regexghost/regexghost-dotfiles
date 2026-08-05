#!/bin/sh

LOC="${HOME}/Videos/Podcasts"
queueFile="${LOC}/toDownload.txt"

cp "$queueFile" /tmp/toDownload.txt

[ $(cat "$queueFile" | wc -l) = "0" ] && echo "No podcasts queued" && exit

while read -r podcast_file; do
	echo "$podcast_file"
	curl -L "$podcast_file" > /tmp/out.mp3
	if ! [ "$?" = "0" ]; then
		mv /tmp/toDownload.txt "$queueFile"
		echo "Error"
		exit
	fi

	filename="$(mediainfo /tmp/out.mp3  | grep -e "Track name" -e "Album" | sed 's/Track name/Trackname/g' | tr -s " " | cut -d " " -f 3- | tr  "\n" "+" | sed 's/[+]/ - /g' | sed 's/ - $//g')"
	# Sometimes there won't be a track name in the metadata, in which case just name it based on data and time downloaded. Not ideal
	[ "$filename" = "" ] && filename="$(date +"%y-%m-%d-%H-%M-%S")"
	mv /tmp/out.mp3 "${LOC}/${filename}.mp3"
	grep -v "$podcast_file" /tmp/toDownload.txt > /tmp/toDownload.txt.tmp
	mv /tmp/toDownload.txt.tmp /tmp/toDownload.txt
done < "$queueFile"

mv /tmp/toDownload.txt "$queueFile"
