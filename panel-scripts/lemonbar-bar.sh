#!/bin/sh

echo "$$" > ~/.cache/bar_pid

COLOUR_RESET="%{F-}"
sunset_colour="%{F#EF2F27}"
sunrise_colour="%{F#FBB829}"
network_down_colour="%{F#E02C6D}"
cpu_colour="%{F#2C78BF}"
cpu_temp_colour="%{F#EF2F27}"
memory_colour="%{F#FBB829}"
uptime_colour="%{F#519F50}"
muted_colour="%{F#EF2F27}"
volume_colour="%{F#519F50}"

update_time () {
	current_time="$(date +"%b, %a %d - %H:%M")"
}

update_cpu () {
	cpu="$(~/.local/share/regexghost/panel/cpu)%"
}

update_network_down () {
	network_down=$(~/.local/share/regexghost/panel/network_down)
}

update_vol () {
	if [ $(cat ~/.cache/muted) = "yes" ]; then
		vol="${muted_colour} : Muted${COLOUR_RESET}"
	else
		vol="${volume_colour} : $(cat ~/.cache/volume)%%${COLOUR_RESET}"
	fi
}

update_mem () {
	memory=$(free -m | awk '/Mem:/ {print $3}')MiB
}

update_cpu_temp () {
	cpu_temp=$(vcgencmd measure_temp | cut -d "=" -f 2)
}

update_uptime () {
	uptime=$(~/.local/share/regexghost/panel/uptime)
}

update_sunrise () {
	sunrise=$(~/.local/share/regexghost/panel/sunrise.sh --sunrise --blank)
}

update_sunset () {
	sunset=$(~/.local/share/regexghost/panel/sunrise.sh --sunset --blank)
}

update_weather () {
	weather="$(~/.local/share/regexghost/panel/metoffice.sh --lemonbar)"
}

# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 

display () {
	echo "%{r} ${sunset_colour}: ${sunset}${COLOUR_RESET} | ${sunrise_colour} : ${sunrise}${COLOUR_RESET} | ${weather} | ${vol} | ${network_down_colour} ${network_down}${COLOUR_RESET} | ${cpu_colour} : ${cpu}${COLOUR_RESET} | ${uptime_colour} : ${uptime}${COLOUR_RESET} | ${cpu_temp_colour}: ${cpu_temp}${COLOUR_RESET} | ${memory_colour} : ${memory}${COLOUR_RESET} | ${current_time}  "
}

update_vol
update_time
update_sunrise
update_sunset
update_weather

i=1

trap "update_vol;display" "RTMIN"

while true; do
	sleep 2 & wait && {
		update_network_down
		update_cpu
		update_mem
		update_uptime
		update_cpu_temp
		update_vol
		[ $((i%3)) -eq 0 ] && update_time
		[ $((i % 180)) -eq 0 ] && update_sunset
		[ $((i % 300)) -eq 0 ] && update_sunrise
		[ $((i % 360)) -eq 0 ] && update_weather
		i=$((i+1))
		[ $i -gt 900 ] && i=0
		display
	}
done
