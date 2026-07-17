#!/usr/bin/env sh

# Music playing script (mpd/mpc)

DMENU_SCRIPT="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"
MUSIC_DIR="$HOME/Music"
FAVOURITES_DIR="$MUSIC_DIR/Favourites"

# Technically these first 4 are unnecessary, could just bind directly to the command
# but I like it all being in one file
if [ "$1" = "--toggle-pause" ]; then
	mpc pause-if-playing || play
	exit
elif [ "$1" = "--quit" ]; then
	mpc stop
	mpc clear
	exit
elif [ "$1" = "--next" ]; then
	mpc next
	exit
elif [ "$1" = "--previous" ]; then
	mpc prev
	exit
elif [ "$1" = "--favourite" ]; then
	song="$(mpc current -f '%file%')"
	echo "$song" | grep -q "CurrentPlaylist/" && exit
	favourite_path="$song"
	favourite_dir="$(dirname "$favourite_path")"
	mkdir -p "$FAVOURITES_DIR/${favourite_dir}"
	ln -sf "${MUSIC_DIR}/${song}" "$FAVOURITES_DIR/${favourite_path}"
	notify-send "Added to favourites"
	exit
elif [ "$1" = "--get-song" ]; then
	song="$(mpc current -f '%title%')"
	[ "$song" = "" ] && echo "None" && exit
	echo "$song"
	exit
fi

# Start mpd if not running, and set mode to shuffle
if ! pgrep mpd 2> /dev/null > /dev/null; then
	mpd
	sleep 0.5
fi

# If mpd is currently playing music, just notify-send the song title
if ! mpc status | grep -q "^\[playing\]"; then
	song_name="$(mpc current -f '%artist% - %title%')"
	notify-send -i emblem-music-symbolic "Currently Playing:" "$song_name"
	exit
fi

if [ "$1" = "--choice" ]; then
	# Ask for playlist
	playlist="$(ls "$MUSIC_DIR" | sed 's/\([A-Z][a-z]\)/ \1/g' | sed 's/\([a-z]\)\([0-9]\)/\1 \2/g' | sed 's/^ //g' | "${DMENU_SCRIPT}" "Select Playlist:")"
	[ "$?" != "0" ] && exit
	playlist_path="$(echo "$playlist" | sed 's/ //g')"
else
	playlist_path="CurrentPlaylist"
fi

# Check for sub playlists
if [ $(find "$playlist_path" -type d | wc -l) -ne 1 ]; then
	playlist="$(ls "$playlist_path" | sed 's/\([A-Z][a-z]\)/ \1/g' | sed 's/\([a-z]\)\([0-9]\)/\1 \2/g' | sed 's/^ //g' | awk 'BEGIN {RS = ""} {print "All Songs\n"$0}' | "${DMENU_SCRIPT}" "Select Playlist:")"
	[ "$?" != "0" ] && exit
	# If all songs, don't change playlist path
	if ! [ "$playlist" = "All Songs" ]; then
		playlist_path="$playlist_path/$(echo "$playlist" | sed 's/ //g')"
	fi
fi

mpc clear
mpc add "$playlist_path"
mpc repeat on
mpc shuffle
mpc play
