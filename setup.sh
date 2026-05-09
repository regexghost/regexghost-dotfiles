#!/bin/sh

file="$2"

exec 3<&0
if [ "$1" = "save" ]; then
	while read -r filepath; do
		repo_path=$(echo "$filepath" | sed "s|~|dotfiles|g")
		real_path=$(echo "$filepath" | sed "s|~|$HOME|g")
		basename=$(basename "$filepath")
		repo_dirname=$(dirname "$repo_path")
		mkdir -p "$repo_dirname"
		echo $filepath
		if grep -q "Start Substitute" "$real_path"; then
			sub save "$basename" "$repo_dirname" "$real_path" <&3
			sub clean "$basename" "$repo_dirname" "$real_path" "$repo_path"
		else
			cp "$real_path" "$repo_path"
		fi
	done < $file
elif [ "$1" = "make" ]; then
	while read -r filepath; do
		repo_path=$(echo "$filepath" | sed "s|~|dotfiles|g")
		real_path=$(echo "$filepath" | sed "s|~|$HOME|g")
		basename=$(basename "$filepath")
		real_dirname=$(dirname "$real_path")
		repo_dirname=$(dirname "$repo_path")
		echo $filepath
		mkdir -p "$real_dirname"
		if grep -q "Start Substitute" "$repo_path"; then
			sub make "$basename" "$repo_dirname" "$repo_path" "$real_path" <&3
		else
			cp "$repo_path" "$real_path"
		fi
	done < $file
fi
exec 3<&-
