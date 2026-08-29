#!/usr/bin/env bash

# Backup and restore ~/Music/Favourites

if [[ "$1" == "restore" ]]; then
	if [ -d "$HOME/Music/Favourites" ]; then
		cp -r "$HOME/Music/Favourites/" /tmp/favourites-backup
		rm -rf "$HOME/Music/Favourites"
	fi
	inputFile="$2"
	oldIFS="$IFS"
	IFS=$'\n'
	lines=( $(cat "$inputFile") )
	IFS="$oldIFS"
	for line in "${lines[@]}"; do
		if ! [[ "$line" == *".m4a" ]]; then
			mkdir "$HOME/Music/${line}"
			continue
		fi
		realFile="$(echo "$line" | sed 's/Favourites\///g')"
		ln -sf "$HOME/Music/${realFile}" "$HOME/Music/${line}"
	done
elif [[ "$1" == "backup" ]]; then
	outputFile="$2"
	cp "$outputFile" /tmp/backup-file
	find "$HOME/Music/Favourites" > "$outputFile"
else
	echo "Options:"
	echo "  backup"
	echo "  restore"
fi
