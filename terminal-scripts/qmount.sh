#!/bin/sh

mount_points="~/Downloads/USBDrive
~/Downloads/BackupMount"

root_device="$(/usr/bin/lsblk -l -n --output NAME,MOUNTPOINTS | grep '/$' | sed 's/p[0-9] \///g; s/[0-9] \///g')"

mount () {
	# Filter out root disk
	unmounted="$(/usr/bin/lsblk -l -n --output NAME,FSTYPE,SIZE,MOUNTPOINTS,TYPE | grep "part" | grep -v "/" | grep -v "$root_device" | tr -s " " | cut -d " " -f 1-3)"

	[ "$unmounted" = "" ] && echo "No drives to mount" && exit

	chosen="$(echo "$unmounted" | fzf)"
	chosen_partition="$(echo "$chosen" | cut -d " " -f 1)"
	chosen_fstype="$(echo "$chosen" | cut -d " " -f 2)"
	[ "$chosen_partition" = "" ] && exit
	chosen_mount_point="$(echo "$mount_points" | fzf | sed "s|~|$HOME|")"
	[ "$chosen_mount_point" = "" ] && exit

	# Check if vfat or exfat, if so need special mount options to get permissions right
	args=""
	if [ "$chosen_fstype" = "vfat" ] || [ "$chosen_fstype" = "exfat" ]; then
		args="-o rw,users,umask=000"
	fi

	sudo mount $args "/dev/${chosen_partition}" "$chosen_mount_point" && echo "Mounted Successfully" || echo "Mount Failed"
}

unmount () {
	# Filter out root disk
	mounted="$(/usr/bin/lsblk -l -n --output NAME,MOUNTPOINTS | grep "/" | grep -v "$root_device" | tr -s " ")"
	[ "$mounted" = "" ] && echo "No drives to unmount" && exit

	chosen_path="$(echo "$mounted" | fzf | cut -d " " -f 2-)"
	[ "$chosen_path" = "" ] && exit

	sudo umount "$chosen_path" && echo "Unmounted Successfully" || echo "Unmounting Failed"
}

case "$1" in
	m*)
		mount
		;;
	u*)
		unmount
		;;
	*)
		echo "Options:"
		echo "  m - mount"
		echo "  u - unmount"
		;;
esac
