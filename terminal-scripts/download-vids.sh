#!/bin/sh

LOC="${HOME}/Videos/YouTube"
targetDir="${LOC}/toDownload"

[ -d "$targetDir/done" ] || mkdir "$targetDir/done"

quality_options_videos="bestvideo[height<=480][vcodec*=avc]+bestaudio[ext=m4a]"
quality_options_shorts="bestvideo[width<=480][vcodec*=avc]+bestaudio[ext=m4a]"
filename_options="%(channel)s - %(title)s.%(ext)s"
sub_options="--embed-subs --all-subs"

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

read -p "Select videos to download (e.g. 1 2 3): " toDownload

[ -f /tmp/to_download ] && rm /tmp/to_download

for i in $toDownload; do
	path="$(find "$targetDir/Shorts" "$targetDir/Videos" -type f | sort | sed -n "${i}p")"
	echo "$path" >> /tmp/to_download
done

while read -r path; do
	id="$(basename "$path" | sed 's/.txt//g')"
	if echo "$path" | grep -q Shorts; then
		yt-dlp $sub_options -o "$filename_options" -f "$quality_options_shorts" -P "$LOC/Shorts" -- "$id"
	else
		yt-dlp $sub_options -o "$filename_options" -f "$quality_options_videos" -P "$LOC/Videos" -- "$id"
	fi
	if [ "$?" = "0" ]; then
		mv "$path" "$targetDir/done"
	fi
done <<EOF
$(cat /tmp/to_download)
EOF

[ -f /tmp/to_download ] && rm /tmp/to_download
