PREFIX="${XDG_DATA_HOME}/regexghost"

normal:
	mkdir -p "${PREFIX}/terminal"
	cp ls_aliases.sh "${PREFIX}/terminal/ls_aliases.sh"
#	cp autocompletion.bash "${PREFIX}/terminal/autocompletion.bash"
	sudo cp 50-inateck-touchpad.conf /etc/X11/xorg.conf.d/50-inateck-touchpad.conf
	mkdir -p ~/.config/keepassxc
	cp keepassxc.ini ~/.config/keepassxc/keepassxc.ini
	cp Xmodmap "${PREFIX}/wm-scripts/Xmodmap"
	sudo cp no-wifi-powersave.conf /etc/NetworkManager/conf.d/no-wifi-powersave.conf
	sudo systemctl restart NetworkManager
