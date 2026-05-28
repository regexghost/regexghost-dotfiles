#!/bin/sh

# wrapper script around the rm, and trash-cli commands

command="trash-put"
dialog="rm: Trash"

if [ "$1" = "-p" ]; then
	shift
	command="/usr/bin/rm -rf"
	dialog="rm: Delete (Permanently)"
else
	if ! which trash-put > /dev/null; then
		echo "trash-cli not installed"
		exit 1
	fi
fi

for arg; do
	filename="$arg"

	# Refuse to delete / or ~
	if [ "$filename" = "$HOME" ] || [ "$filename" = "/" ]; then
		echo "Refusing to delete"
		exit
	fi

	! [ -e "$filename" ] && echo "File/Directory doesn't exit" && continue
	if [ -d "$filename" ]; then
		if [ -z "$(ls -A "$filename")" ]; then
			read -p "${dialog} ${filename} (empty dir) (y/N) " confirm
		else
			read -p "${dialog} ${filename} (non-empty dir) (y/N) " confirm
		fi
		[ "$confirm" = "y" ] && $command -- "$filename"
		continue
	fi

	read -p "${dialog} ${filename} (y/N) " confirm
	[ "$confirm" = "y" ] && $command -- "$filename"
done
