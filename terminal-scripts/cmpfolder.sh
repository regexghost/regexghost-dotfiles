#!/usr/bin/env bash

# Script to compare two folders to ensure they are byte for byte identical 

if [[ "$2" == "" ]]; then
	echo "Usage: ./cmpfolder.sh [-o] folder1 folder2"
	echo "  -o means compare only files in first dir"
	exit
fi

IFS=$'\n'
filesA=( $(find "$1" -type f | sort) )
filesB=( $(find "$2" -type f | sort) )

if [[ "$3" == "-o" ]]; then
	for fileA in "${filesA[@]}"; do
		fileName=$(basename "$fileA")
		fileToCmp="${2}/${fileName}"
		cmp "$fileA" "$fileToCmp"
	done
	exit
fi

index=0
for fileA in "${filesA[@]}"; do
	fileToCmp="${filesB[index]}"
	indexA=$((index+1))
	index="$indexA"
	cmp "$fileA" "$fileToCmp"
done
