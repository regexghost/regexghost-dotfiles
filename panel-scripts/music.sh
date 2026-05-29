#!/usr/bin/env sh

# Music playing script

DMENU_SCRIPT="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"
MUSIC_DIR="$HOME/Music"
FAVOURITES_DIR="$MUSIC_DIR/Favourites"

ping_panel () {
	kill -35 "$(cat ~/.cache/bar_pid)"
}

# Technically these first 4 are unnecessary, could just bind directly to the command
# but I like it all being in one file
if [ "$1" = "--toggle-pause" ]; then
	mocp --toggle-pause
	ping_panel
	exit
elif [ "$1" = "--quit" ]; then
	mocp --stop
	ping_panel
	exit
elif [ "$1" = "--next" ]; then
	mocp --next
	ping_panel
	exit
elif [ "$1" = "--previous" ]; then
	mocp --previous
	ping_panel
	exit
elif [ "$1" = "--favourite" ]; then
	song="$(mocp -i | grep "File:" | sed 's/File: //g')"
	echo "$song" | grep -q "CurrentPlaylist/" && exit
	favourite_path="$(echo "$song" | sed "s|$MUSIC_DIR/||g")"
	favourite_dir="$(dirname "$favourite_path")"
	mkdir -p "$FAVOURITES_DIR/${favourite_dir}"
	ln -sf "$song" "$FAVOURITES_DIR/${favourite_path}"
	notify-send "Added to favourites"
	exit
elif [ "$1" = "--get-song" ]; then
	song="$(mocp -i 2> /dev/null | awk '/^Title:/ {S1 = ""; printf $0}')"
	[ "$song" = "" ] && echo "None" && exit
	echo "$song"
	exit
fi

# Start mocp if not running, and set mode to shuffle
if ! pgrep mocp 2> /dev/null > /dev/null; then
	mocp -S
	mocp -t shuffle,repeat
fi

# If mocp is currently playing music, just notify-send the song title
if ! mocp -i | grep -q "State: STOP"; then
	mocp_i="$(mocp -i)"
	song_name="$(echo "$mocp_i" | grep "^Title: " | sed 's/Title: //g')"
	total="$(echo "$mocp_i" | awk '/^TotalSec/ {print $2}')"
	current="$(echo "$mocp_i" | awk '/^CurrentSec/ {print $2}')"
	progress=$(echo "$current/$total*100" | bc -l | cut -d "." -f 1)
	notify-send -i emblem-music-symbolic "Currently Playing:" "$song_name" -h "int:value:${progress}"
	exit
fi

if [ "$1" = "--choice" ]; then
	# Ask for playlist
	playlist="$(ls "$MUSIC_DIR" | sed 's/\([A-Z][a-z]\)/ \1/g' | sed 's/\([a-z]\)\([0-9]\)/\1 \2/g' | sed 's/^ //g' | "${DMENU_SCRIPT}" "Select Playlist:")"
	[ "$?" != "0" ] && exit
	playlist_path="$MUSIC_DIR/$(echo "$playlist" | sed 's/ //g')"
else
	playlist_path="$MUSIC_DIR/CurrentPlaylist"
fi

# Check for sub playlists
if find "$playlist_path" -mindepth 1 -type d | grep -q ""; then
	playlist="$(ls "$playlist_path" | sed 's/\([A-Z][a-z]\)/ \1/g' | sed 's/\([a-z]\)\([0-9]\)/\1 \2/g' | sed 's/^ //g' | awk 'BEGIN {RS = ""} {print "All Songs\n"$0}' | "${DMENU_SCRIPT}" "Select Playlist:")"
	[ "$?" != "0" ] && exit
	# If all songs, don't change playlist path
	if ! [ "$playlist" = "All Songs" ]; then
		playlist_path="$playlist_path/$(echo "$playlist" | sed 's/ //g')"
	fi
fi

mocp --clear
mocp --append "$playlist_path"
mocp --play
ping_panel
