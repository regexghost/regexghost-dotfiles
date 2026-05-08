PREFIX="${XDG_DATA_HOME}/regexghost/panel/"

normal:
	mkdir -p ${PREFIX}
	gcc -o cpu cpu.c
	gcc -o network_up network.c -D UP_SPEED
	gcc -o network_down network.c
	cp sunrise.sh ${PREFIX}/sunrise.sh
	cp metoffice.sh ${PREFIX}/metoffice.sh
	cp music.sh ${PREFIX}/music.sh
	gcc -o uptime uptime.c
	mv cpu network_up network_down uptime ${PREFIX}/
