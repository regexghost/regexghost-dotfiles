#!/usr/bin/env bash

# Script to cut media file without re-encoding

if [[ "$#" != "4" ]]; then
	echo "Usage:"
	echo "  ./media_cut.sh input_file start_time end_time output_file"
	exit
fi

input_file="$1"
start_time="$2"
end_time="$3"
output_file="$4"

cut_time=$(awk -v start="$start_time" -v end="$end_time" '
	BEGIN {
		split(start, a, ":")
		split(end, b, ":")
		t1 = a[1]*3600 + a[2]*60 + a[3]
		t2 = b[1]*3600 + b[2]*60 + b[3]
		diff = t2 - t1
		printf "%02d:%02d:%02d\n", diff/3600, diff%3600/60, diff%60
	}
')

ffmpeg -v quiet -stats -ss "$start_time" -i "$input_file" -to "$cut_time" -c copy "$output_file"
