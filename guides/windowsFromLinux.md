# Windows Install from Linux

https://serverfault.com/questions/1191017/how-to-make-windows-10-11-usb-flash-install-media-from-linux/1191018#1191018

https://nixaid.com/archive/article/bootable-usb-windows-linux?era=ghost

How to make a USB drive with a Windows ISO, that can install Windows, from a Linux system. You can use WoeUSB or Ventoy but this is the lower-level, fewer-dependancies way of doing it

Note that while this works to get a bootable USB, often the USB can't see my drives and asks for extra drivers. This seems to be a problem with Windows USBs made from Linux, so it's still best to make them from Windows where possible.

## Partition Setup

`sudo fdisk /dev/<drive>`

```
o
w
```

`sudo fdisk /dev/<drive>`

```
n
p
1
<enter>
+1G
n
p
2
<enter>
<enter>
w
```

`sudo mkfs.fat -F32 -n "BOOT" /dev/<drive>`  
`sudo mkfs.ntfs -Q -L "INSTALL /dev/<drive>"`

## Mount ISO

`sudo modprobe loop`  
`mkdir isomount`  
`sudo mount windows.iso isomount/`

https://askubuntu.com/questions/634501/cant-mount-iso-file-as-loop-device-error-failed-to-setup-loop-device

## BOOT Partition

`sudo mount -o rw,users,umask=000 /dev/<drive>1 usbmount/`

Copy all but `sources/`

`cp -r isomount/boot isomount/efi isomount/support isomount/autorun.inf isomount/bootmgfw.efi isomount/bootmgr isomount/bootmgr.efi isomount/__chunk_data isomount/setup.exe usbmount/`

Then copy only `boot.wim` from `sources/`

`mkdir usbmount/sources`  
`cp isomount/sources/boot.wim usbmount/sources`

`sudo umount usbmount/`

## INSTALL Partition

`sudo mount /dev/<drive>2 usbmount/`  
`cp isomount/* usbmount/`  
`sudo umount usbmount/`

`sudo umount isomount/`

`sync`

`udisksctl power-off -b /dev/<drive>`
