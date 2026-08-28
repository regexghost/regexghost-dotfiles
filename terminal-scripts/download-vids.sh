#!/bin/sh

LOC="${HOME}/Videos/YouTube"
targetDir="${LOC}/toDownload"

[ -d "$targetDir/done" ] || mkdir "$targetDir/done"

quality_options_videos="bestvideo[height<=720][fps<=60][vcodec*=avc]+bestaudio[ext=m4a]"
quality_options_shorts="bestvideo[width<=720][vcodec*=avc]+bestaudio[ext=m4a]"
filename_options="%(channel)s - %(title)s.%(ext)s"
sub_options="--embed-subs --sub-langs en.*"
metadata_options="--embed-chapters"

if [ "$1" = "s" ]; then
	targetDir="${targetDir}/Shorts"
elif [ "$1" = "v" ]; then
	targetDir="${targetDir}/Videos"
fi

i=1
while read -r info_file; do
	[ "$info_file" = "" ] && echo "No videos queued" && exit
	video_name_channel="$(cat "$info_file" | head -n 2 | tac | awk '{print}' ORS=' - ' | sed 's/..$//g')"
	echo "${i}: ${video_name_channel}"
	i=$((i+1))
done <<EOF
$(find "$targetDir/Shorts" "$targetDir/Videos" -type f | sort)
EOF

read -p "Select videos to download/delete (e.g. 1 2 -3): " toDownload

[ -f /tmp/to_download ] && rm /tmp/to_download
[ -f /tmp/to_delete ] && rm /tmp/to_delete

[ "$toDownload" = "" ] && exit

if [ "$toDownload" = "a" ] || [ "$toDownload" = "all" ]; then
	find "$targetDir/Shorts" "$targetDir/Videos" -type f | sort >> /tmp/to_download
else
	for i in $toDownload; do
		index="$(echo "$i" | sed 's/^-//g')"
		path="$(find "$targetDir/Shorts" "$targetDir/Videos" -type f | sort | sed -n "${index}p")"
		if [ "$(echo "$i" | cut -c 1)" = "-" ]; then
			echo "$path" >> /tmp/to_delete
		else
			echo "$path" >> /tmp/to_download
		fi
	done
fi

if [ -f /tmp/to_delete ]; then
	while read -r path; do
		rm "$path"
	done <<EOF
$(cat /tmp/to_delete)
EOF
fi

[ -f /tmp/to_download ] || exit

while read -r path; do
	id="$(basename "$path" | sed 's/.txt//g')"
	if echo "$path" | grep -q Shorts; then
		yt-dlp $sub_options $metadata_options -o "$filename_options" -f "$quality_options_shorts" -P "$LOC/Shorts" -- "$id"
	else
		yt-dlp $sub_options $metadata_options -o "$filename_options" -f "$quality_options_videos" -P "$LOC/Videos" -- "$id"
	fi
	if [ "$?" = "0" ]; then
		mv "$path" "$targetDir/done"
	fi
done <<EOF
$(cat /tmp/to_download)
EOF

[ -f /tmp/to_download ] && rm /tmp/to_download

rm "$HOME/Videos/YouTube/Videos/*.json
rm "$HOME/Videos/YouTube/Shorts/*.json
