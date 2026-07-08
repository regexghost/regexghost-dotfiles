#!/usr/bin/env bash

root="$(pwd)"

oldIFS="$IFS"
IFS=$'\n'
dirs=( $(find "$1" -type d) )
IFS="$oldIFS"

for dir in "${dirs[@]}"; do
	if [ "$(find "$dir" -type d | wc -l)" -gt 2 ]; then
		continue
	fi
	cd "$dir"
	if [[ "$(ls | head -n 1)" == *".m4a" ]]; then
		aacgain -c -r -m 1 *.m4a
	else
		rsgain easy .
	fi
	cd "$root"
done
