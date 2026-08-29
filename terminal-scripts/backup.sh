#!/bin/sh

# Backup script

BACKUP_FILE="$XDG_CONFIG_HOME/regexghost/backup.txt"
BACKUP_LOCATION="$HOME/Downloads/BackupMount/MainBackup"

if [ "$1" = "add" ]; then
	# Get real filename, and remove "/home/<user>"
	[ -e "$2" ] && echo "$(readlink -f "$2")" | sed "s|$HOME||g" >> "$BACKUP_FILE"
elif [ "$1" = "remove" ] || [ "$1" = "rm" ]; then
	# Get real filename, and remove "/home/<user>"
	file="$(readlink -f "$2" | sed "s|$HOME||g")"
	# Check if it's in backup file, if so, remove and overwrite
	if grep -q "^${file}\$" "$BACKUP_FILE"; then
		sed "\:^$file\$:d" "$BACKUP_FILE" > /tmp/backup-tempfile
		mv /tmp/backup-tempfile "$BACKUP_FILE"
	fi
elif [ "$1" = "ls" ]; then
	# Add "~" to the start of each path
	cat "$BACKUP_FILE" | sed 's/^/~/g'
elif [ "$1" = "make" ]; then
	# Log backup
	date +"%y-%m-%d" >> "$XDG_DATA_HOME/regexghost/script-data/backup-history.txt"
	# Copy last backup, to previous slot
	rsync -ar --links --delete --info=progress2 "${BACKUP_LOCATION}/latest/" "${BACKUP_LOCATION}/previous/"
	# Make backup from live system
	rsync -ar --links --delete --info=progress2 --files-from="${BACKUP_FILE}" "$HOME" "${BACKUP_LOCATION}/latest/"
	# Hash all files (on PC) and save to file
	hashFile="${BACKUP_LOCATION}/hashes/$(date +"%y%m%d-%H%M").txt"
	while read -r thing; do
		echo "Hashing: ${HOME}${thing}"
		[ -f "${HOME}${thing}" ] && sha256sum "${HOME}${thing}" >> "$hashFile"
		[ -d "${HOME}${thing}" ] && hashfolder "${HOME}${thing}" >> "$hashFile"
	done  <<EOF
$(cat "$BACKUP_FILE")
EOF
elif [ "$1" = "diff" ]; then
	# Get last 2 hash files and compare
	last2="$(find "${BACKUP_LOCATION}/hashes" | sort | tail -n 2 | head -n 1)"
	last1="$(find "${BACKUP_LOCATION}/hashes" | sort | tail -n 1)"
	# --color=always so that you can grep -v while maintaining colour
	diff --color=always "$last2" "$last1"
else
	echo "Options:"
	echo "  add"
	echo "  remove/rm"
	echo "  ls"
	echo "  make"
	echo "  diff"
fi
