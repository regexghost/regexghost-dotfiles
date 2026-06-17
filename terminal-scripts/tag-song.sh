#!/usr/bin/env bash

genre="$1"
appleMusicID="$2"
shift
shift

if [ "$appleMusicID" = "file.jpg" ]; then
	cp file.jpg "$XDG_CACHE_HOME/art.jpg"
	art="file.jpg"
else
	searchLink="https://itunes.apple.com/lookup?id=${appleMusicID}&entity=song"
	json="$(curl "$searchLink")"
	if [[ "$(echo "$json" | jq .results[0].collectionName)" == "null" ]]; then
		echo null
		searchLink="https://itunes.apple.com/lookup?id=${appleMusicID}&entity=album"
		json="$(curl "$searchLink")"
	fi

	art="$(echo "$json" | jq -r .results[0].artworkUrl100 | sed 's/100x100bb/1500x1500/g')"
	if [ "$art" = "null" ]; then
		art="$(echo "$json" | jq -r .results[1].artworkUrl100 | sed 's/100x100bb/1500x1500/g')"
	fi
fi

echo $art
for arg; do
	echo "$arg"
	"$HOME/.local/share/regexghost/.venv/bin/python3" "${XDG_DATA_HOME}/regexghost/terminal/tag-music.py" "$arg" "$genre" "$art"
done

rm -f "$XDG_CACHE_HOME/art.jpg"
