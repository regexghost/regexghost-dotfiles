#!/bin/sh

mount_points="~/Downloads/USBDrive
~/Downloads/BackupMount"
root_device="$(/usr/bin/lsblk -l -n --output NAME,MOUNTPOINTS | grep '/$' | sed 's/p[0-9] \///g; s/[0-9] \///g')"

if [ "$1" = "mount" ]; then
	unmounted="$(/usr/bin/lsblk -l -n --output NAME,FSTYPE,SIZE,MOUNTPOINTS,TYPE | grep "part" | grep -v "/" | grep -v "$root_device" | tr -s " " | cut -d " " -f 1-3)"

	chosen_partition="$(echo "$unmounted" | fzf | cut -d " " -f 1)"
	chosen_mount_point="$(echo "$mount_points" | fzf | sed "s|~|$HOME|")"

	sudo mount "/dev/${chosen_partition}" "$chosen_mount_point" && notify-send "Mounted Successfully" || notify-send "Mount Failed"
elif [ "$1" = "unmount" ]; then
	mounted="$(/usr/bin/lsblk -l -n --output NAME,MOUNTPOINTS | grep "/" | grep -v "$root_device" | tr -s " ")"
	chosen_path="$(echo "$mounted" | fzf | cut -d " " -f 2-)"
	sudo umount "$chosen_path" && notify-send "Unmounted Successfully" || notify-send "Unmounting Failed"
fi
