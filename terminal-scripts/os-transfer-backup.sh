#!/bin/sh

# Backup all the stuff my main backup doesn't, for transfering to a new OS

if lsblk | grep -q Downloads; then
	echo "Mount backup drive at ~/temp, not in ~/Downloads as ~/Downloads is part of the backup"
	exit
fi

if ! lsblk | grep -q temp; then
	echo "Mount backup drive at ~/temp"
	exit
fi

if pgrep firefox; then
	echo "Close Firefox"
	exit
fi

if pgrep chromium; then
	echo "Close Chromium"
	exit
fi

BACKUP_LOCATION="$HOME/temp/OSTransfer"
mkdir -p "$BACKUP_LOCATION"

echo "Copying ~/Music"
cp -r "$HOME/Music" "${BACKUP_LOCATION}/Music"

echo "Copying ~/Videos"
cp -r "$HOME/Videos" "${BACKUP_LOCATION}/Videos"

echo "Copying ~/Downloads"
cp -r "$HOME/Downloads" "${BACKUP_LOCATION}/Downloads"

echo "Copying ~/.local/bin"
cp -r "$HOME/.local/bin" "${BACKUP_LOCATION}/local-bin"

echo "Copying ~/.local/state/mpv"
cp -r "$HOME/.local/state/mpv" "${BACKUP_LOCATION}/mpv-state"

echo "Copying Firefox data"
cd "$HOME"
tar czf firefox-backup.tar.gz .mozilla
cp "$HOME/firefox-backup.tar.gz" "${BACKUP_LOCATION}/firefox-backup.tar.gz"

echo "Copying Chromium data"
cd "$HOME/.local/share"
tar czf chromium-backup.tar.gz chromium
cp "$HOME/.config/chromium-backup.tar.gz" "${BACKUP_LOCATION}/chromium-backup.tar.gz"

echo "Done"
