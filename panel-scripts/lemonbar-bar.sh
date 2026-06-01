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
music_stopped_colour="%{F#${RED}}"
music_playing_colour="%{F#${GREEN}}"
music_paused_colour="%{F#${YELLOW}}"
wifi_up_colour="%{F#${GREEN}}"
wifi_down_colour="%{F#${RED}}"

update_time () {
	current_time="$(date +"%a %d %b - %H:%M")"
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

update_wifi () {
	con="$(nmcli -t -f NAME c show --active | grep -v "^lo$" | head -c 6 | sed 's/ $//g')"
	if [ "$con" = "" ]; then
		wifi="${wifi_down_colour} N/A${COLOUR_RESET}"

	else
		wifi="${wifi_up_colour} ${con}${COLOUR_RESET}"
	fi
}

update_mem () {
	memory="${memory_colour} "$(free -m | awk '/Mem:/ {print $3}')MiB"${COLOUR_RESET}"
}

update_cpu_temp () {
	cpu_temp="${cpu_temp_colour} "$(vcgencmd measure_temp | cut -d "=" -f 2 | cut -d "." -f 1)°C"${COLOUR_RESET}"
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
	weather="0${weather_today} 1${weather_tomorrow} 2${weather_2_days}"
}

update_music () {
	state="$(mocp -i)"
	song="$(echo "$state" | grep -e "SongTitle" -e "Artist" | tac  | paste -sd "-" | sed 's/-Artist: / - /g' | sed 's/^SongTitle: //g; s/"//g' | head -c 16 | sed 's/ $//g')"
	pause="$(echo "$state" | grep -e "State" | cut -d " " -f 2)"
	if [ "$song" = "" ]; then
		music="${music_stopped_colour} N/A${COLOUR_RESET}"
	elif [ "$pause" = "PLAY" ]; then
		music="${music_playing_colour} ${song}${COLOUR_RESET}"
	else
		music="${music_paused_colour} ${song}${COLOUR_RESET}"
	fi
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
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 

display () {
	echo "%{r} ${music} | ${sunset} | ${sunrise} | ${weather}| ${vol} | ${network_down} | ${wifi} | ${cpu} | ${uptime} | ${cpu_temp} | ${memory} | ${current_time} "
}

update_vol
update_wifi
update_time
update_sunrise
update_sunset
update_weather
update_music

i=1

trap "update_vol;display" "RTMIN"
trap "update_music;display" "RTMIN+1"

while true; do
	sleep 2 & wait && {
		update_network_down
		update_cpu
		update_mem
		update_uptime
		update_cpu_temp
		update_vol
		[ $((i%3)) -eq 0 ] && update_time
		[ $((i%3)) -eq 0 ] && update_wifi
		[ $((i%3)) -eq 0 ] && update_music
		[ $((i % 180)) -eq 0 ] && update_sunset
		[ $((i % 300)) -eq 0 ] && update_sunrise
		[ $((i % 360)) -eq 0 ] && update_weather
		i=$((i+1))
		[ $i -gt 900 ] && i=0
		display
	}
done
