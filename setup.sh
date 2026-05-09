#!/bin/sh

file="$2"


if [ "$1" = "save" ]; then
	while read -r filepath; do
		repo_path=$(echo "$filepath" | sed "s|~|dotfiles|g")
		real_path=$(echo "$filepath" | sed "s|~|$HOME|g")
		basename=$(basename "$filepath")
		repo_dirname=$(dirname "$repo_path")
		mkdir -p "$repo_dirname"
		if grep -q "START SUBSTITUTE" "$real_path"; then
			sub save "$basename" "$repo_dirname" "$real_path" "$repo_path"
		else
			cp "$real_path" "$repo_path"
		fi
		echo $real_path
		echo $repo_path
	done < $file
elif [ "$1" = "make" ]; then
	while read -r filepath; do
		repo_path=$(echo "$filepath" | sed "s|~|dotfiles|g")
		real_path=$(echo "$filepath" | sed "s|~|$HOME|g")
		basename=$(basename "$filepath")
		real_dirname=$(dirname "$real_path")
		repo_dirname=$(dirname "$repo_path")
		mkdir -p "$real_dirname"
		if grep -q "START SUBSTITUTE" "$repo_path"; then
			sub make "$basename" "$repo_dirname" "$repo_path" "$real_path"
		else
			echo cp "$real_path" "$repo_path"
		fi
		echo $real_path
		echo $repo_path
	done < $file
fi
