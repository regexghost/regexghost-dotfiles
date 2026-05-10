#!/bin/sh

echo "$$" > ~/.cache/bar_pid

. "$XDG_CONFIG_HOME/regexghost/current-theme.sh"

COLOUR_RESET="%{F-}"
sunset_colour="%{F#${RED}}"
sunrise_colour="%{F#${YELLOW}}"
network_down_colour="%{F#${MAGENTA}}"
cpu_colour="%{F#${BLUE}}"
cpu_temp_colour="%{F#${RED}}"
memory_colour="%{F#${YELLOW}}"
uptime_colour="%{F#${GREEN}}"
muted_colour="%{F#${RED}}"
volume_colour="%{F#${GREEN}}"

update_time () {
	current_time="$(date +"%b, %a %d - %H:%M")"
}

update_cpu () {
	cpu="${cpu_colour} $(~/.local/share/regexghost/panel/cpu)%${COLOUR_RESET}"
}

update_network_down () {
	network_down="${network_down_colour} "$(~/.local/share/regexghost/panel/network_down)"${COLOUR_RESET}"
}

update_vol () {
	if [ $(cat ~/.cache/muted) = "yes" ]; then
		vol="${muted_colour} Muted${COLOUR_RESET}"
	else
		vol="${volume_colour} $(cat ~/.cache/volume)%%${COLOUR_RESET}"
	fi
}

update_mem () {
	memory="${memory_colour} "$(free -m | awk '/Mem:/ {print $3}')MiB"${COLOUR_RESET}"
}

update_cpu_temp () {
	cpu_temp="${cpu_temp_colour} "$(vcgencmd measure_temp | cut -d "=" -f 2)"${COLOUR_RESET}"
}

update_uptime () {
	uptime="${uptime_colour} "$(~/.local/share/regexghost/panel/uptime)"${COLOUR_RESET}"
}

update_sunrise () {
	sunrise="${sunrise_colour} "$(~/.local/share/regexghost/panel/sunrise.sh --sunrise --blank)"${COLOUR_RESET}"
}

update_sunset () {
	sunset="${sunset_colour} "$(~/.local/share/regexghost/panel/sunrise.sh --sunset --blank)"${COLOUR_RESET}"
}

update_weather () {
	weather_days="$(~/.local/share/regexghost/panel/metoffice.sh)"
	weather_today="$(~/.local/share/regexghost/panel/weather-formatter.sh --lemonbar "$(echo "$weather_days" | sed '1q;d')")"
	weather_tomorrow="$(~/.local/share/regexghost/panel/weather-formatter.sh --lemonbar "$(echo "$weather_days" | sed '2q;d')")"
	weather_2_days="$(~/.local/share/regexghost/panel/weather-formatter.sh --lemonbar "$(echo "$weather_days" | sed '3q;d')")"
	weather="0 ${weather_today} 1 ${weather_tomorrow} 2 ${weather_2_days}"
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
	echo "%{r} ${sunset} | ${sunrise} | ${weather} | ${vol} | ${network_down} | ${cpu} | ${uptime} | ${cpu_temp} | ${memory} | ${current_time}  "
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
