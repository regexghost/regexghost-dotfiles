#!/bin/sh

# Backup script

BACKUP_FILE="$XDG_CONFIG_HOME/regexghost/backup.txt"
BACKUP_LOCATION="$HOME/Downloads/BackupMount/MainBackup"

if [ "$1" = "add" ]; then
	[ -e "$2" ] && echo "$2" | sed "s|$HOME||g" >> "$BACKUP_FILE"
elif [ "$1" = "remove" ] || [ "$1" = "rm" ]; then
	file="$(echo "$2" | sed "s|$HOME||g")"
	if grep -q "^${file}\$" "$BACKUP_FILE"; then
		sed "\:^$file\$:d" "$BACKUP_FILE" > /tmp/backup-tempfile
		mv /tmp/backup-tempfile "$BACKUP_FILE"
	fi
elif [ "$1" = "ls" ]; then
	cat "$BACKUP_FILE" | sed 's/^/~/g'
elif [ "$1" = "make" ]; then
	date "+y/%m/%d" >> "$XDG_DATA_HOME/regexghost/script-data/backup-history.txt"
	rsync -ar --links --delete --info=progress2 "${BACKUP_LOCATION}/latest/" "${BACKUP_LOCATION}/previous/"
	rsync -ar --links --delete --info=progress2 --files-from="${BACKUP_FILE}" "$HOME" "${BACKUP_LOCATION}/latest/"
fi
