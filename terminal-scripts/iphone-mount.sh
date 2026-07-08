#!/usr/bin/env bash

MOUNTPOINT="$HOME/Downloads/USBDrive"

if [[ "$1" == "mount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse "$MOUNTPOINT"
elif [[ "$1" == "fbmount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse --documents com.foobar2000.mobile "$MOUNTPOINT"
elif [[ "$1" == "vlcmount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse --documents org.videolan.vlc-ios "$MOUNTPOINT"
elif [[ "$1" == "infusemount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse --documents com.firecore.infuse "$MOUNTPOINT"
elif [[ "$1" == "pdfmount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse --documents com.pspdfkit.viewer "$MOUNTPOINT"
elif [[ "$1" == "readeramount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse --documents org.readera.book-reader "$MOUNTPOINT"
elif [[ "$1" == "ashellmount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse --documents org.AsheKube.app.a-Shell "$MOUNTPOINT"
elif [[ "$1" == "pocketbookmount" ]]; then
	idevicepair validate
	idevicepair pair || exit
	ifuse --documents com.obreey.reader "$MOUNTPOINT"
elif [[ "$1" == "unmount" ]] || [[ "$1" == "umount" ]]; then
	fusermount -u "$MOUNTPOINT"
elif [[ "$1" == "force" ]]; then
	fusermount -uz "$MOUNTPOINT"
fi

echo "Done"
