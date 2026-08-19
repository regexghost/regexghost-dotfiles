#!/usr/bin/env bash

# Syntax for playlist csv file:
# `TerrariaSoundtrack,Terraria Soundtrack`
# `local-dirname,remote-title`

PLAYLISTS_FILE="$XDG_CONFIG_HOME/regexghost/playlists-phone-sync.csv"

MOUNT_LOCATION="$HOME/Downloads/USBDrive"

# Mount phone

if ! lsusb | grep -q Apple; then
	echo "Plug in iPhone"
	exit
fi

idevicepair validate
idevicepair pair

[[ "$?" == "0" ]] || exit

ifuse --documents com.foobar2000.mobile "$MOUNT_LOCATION"

[[ "$?" == "0" ]] || exit

# Create folder for playlists

[ -d "${MOUNT_LOCATION}/Playlists" ] || mkdir "${MOUNT_LOCATION}/Playlists"

# Copy/update playlists

while read -r line; do
	# Local path
	computer="$(echo "$line" | cut -d "," -f 1)"
	# Phone path
	phone="$(echo "$line" | cut -d "," -f 2)"
	echo "${computer} -> ${phone}"
	# Create phone dir if non existant
	[ -d "${MOUNT_LOCATION}/${phone}" ] || mkdir "${MOUNT_LOCATION}/${phone}"
	# Copy, with --copy-links, so locally symlinked playlists (e.g. CurrentPlaylist) copy as files
	rsync -vr --copy-links --update --delete --modify-window=1 --info=progress2 "${HOME}/Music/${computer}/" "${MOUNT_LOCATION}/${phone}/"
	# Shuffle into playlist file
	find "${MOUNT_LOCATION}/${phone}/" -type f | sort | sed "s|.*${phone}/|../${phone}/|g" > "/tmp/${phone}.m3u8"
	cp "/tmp/${phone}.m3u8" "${MOUNT_LOCATION}/Playlists/"
done < "$PLAYLISTS_FILE"

# Unmount phone

fusermount -u "${MOUNT_LOCATION}"
idevicepair unpair
