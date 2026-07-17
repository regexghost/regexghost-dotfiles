# Samba Setup

https://pimylifeup.com/raspberry-pi-samba/

`sudo apt install samba samba-common-bin`  
`sudo nano /etc/samba/smb.conf`  
`sudo smbpasswd -a <username>`  
`sudo systemctl restart smbd`

## Config File

``` conf
[pi-video-share]
path = /home/<username>/Videos
writeable = yes
browseable = yes
public = no
```

