#!/bin/sh

mount_points="~/Downloads/USBDrive
~/Downloads/BackupMount"
root_device="$(/usr/bin/lsblk -l -n --output NAME,MOUNTPOINTS | grep '/$' | sed 's/p[0-9] \///g; s/[0-9] \///g')"

mount () {
	unmounted="$(/usr/bin/lsblk -l -n --output NAME,FSTYPE,SIZE,MOUNTPOINTS,TYPE | grep "part" | grep -v "/" | grep -v "$root_device" | tr -s " " | cut -d " " -f 1-3)"

	[ "$unmounted" = "" ] && echo "No drives to mount" && exit

	chosen="$(echo "$unmounted" | fzf)"
	chosen_partition="$(echo "$chosen" | cut -d " " -f 1)"
	chosen_fstype="$(echo "$chosen" | cut -d " " -f 2)"
	[ "$chosen_partition" = "" ] && exit
	chosen_mount_point="$(echo "$mount_points" | fzf | sed "s|~|$HOME|")"
	[ "$chosen_mount_point" = "" ] && exit
	args=""
	if [ "$chosen_fstype" = "vfat" ]; then
		args="-o rw,users,umask=000"
	fi
	sudo mount $args "/dev/${chosen_partition}" "$chosen_mount_point" && notify-send "Mounted Successfully" || notify-send "Mount Failed"
}

unmount () {
	mounted="$(/usr/bin/lsblk -l -n --output NAME,MOUNTPOINTS | grep "/" | grep -v "$root_device" | tr -s " ")"
	[ "$unmounted" = "" ] && echo "No drives to unmount" && exit

	chosen_path="$(echo "$mounted" | fzf | cut -d " " -f 2-)"
	[ "$chosen_path" = "" ] && exit
	sudo umount "$chosen_path" && notify-send "Unmounted Successfully" || notify-send "Unmounting Failed"
}

case "$1" in
	m*)
		mount
		;;
	u*)
		unmount
		;;
esac
