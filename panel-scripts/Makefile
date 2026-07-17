PREFIX=${XDG_DATA_HOME}/regexghost/panel

normal:
	mkdir -p ${PREFIX}
	gcc -o cpu cpu.c
	gcc -o network_up network.c -D UP_SPEED
	gcc -o network_down network.c
	cp sunrise.sh ${PREFIX}/sunrise.sh
	cp metoffice.sh ${PREFIX}/metoffice.sh
	cp weather-formatter.sh ${PREFIX}/weather-formatter.sh
	cp music-moc.sh ${PREFIX}/music-moc.sh
	cp lemonbar-bar.sh ${PREFIX}/lemonbar-bar.sh
	cp lemonbar-runner.sh ${PREFIX}/lemonbar-runner.sh
	gcc -o uptime uptime.c
	mv cpu network_up network_down uptime ${PREFIX}/
	cp music-mpd.sh ${PREFIX}/music-mpd.sh
	cp dwm-bar.sh ${PREFIX}/dwm-bar.sh
