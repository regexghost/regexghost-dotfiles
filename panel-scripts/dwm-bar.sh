#!/bin/sh

echo "$$" > ~/.cache/bar_pid

. "$XDG_CONFIG_HOME/regexghost/current-theme.sh"

COLOUR_RESET="\x01"
sunset_colour="\x02"
sunrise_colour="\x04"
network_down_colour="\x06"
cpu_colour="\x05"
cpu_temp_colour="\x02"
memory_colour="\x04"
uptime_colour="\x03"
muted_colour="\x02"
volume_colour="\x03"
music_stopped_colour="\x02"
music_playing_colour="\x03"
music_paused_colour="\x04"
wifi_up_colour="\x03"
wifi_down_colour="\x02"
stream_live_colour="\x02"
stream_not_live_colour="\x03"
stream_error_colour="\x02"

update_time () {
	current_time="$(date +"%a %d %b - %H:%M")"
}

update_cpu () {
	cpu="${cpu_colour}$(~/.local/share/regexghost/panel/cpu)%${COLOUR_RESET}"
}

update_network_down () {
	network_down="${network_down_colour}"$(~/.local/share/regexghost/panel/network_down)"${COLOUR_RESET}"
}

update_vol () {
	if [ $(cat ~/.cache/muted) = "yes" ]; then
		vol="${muted_colour}Muted${COLOUR_RESET}"
	else
		vol="${volume_colour}$(cat ~/.cache/volume)%%${COLOUR_RESET}"
	fi
}

update_wifi () {
	con="$(nmcli -t -f NAME c show --active | grep -v "^lo$" | string-trunc 6 ".." | sed 's/ $//g')"
	if [ "$con" = "" ]; then
		wifi="${wifi_down_colour}N/A${COLOUR_RESET}"

	else
		wifi="${wifi_up_colour}${con}${COLOUR_RESET}"
	fi
}

update_mem () {
	memory="${memory_colour}"$(free -m | awk '/Mem:/ {print $3}')MiB"${COLOUR_RESET}"
}

update_cpu_temp () {
	temp=$(($(cat /sys/class/thermal/thermal_zone2/temp)/1000))
	cpu_temp="${cpu_temp_colour}""${temp}°C""${COLOUR_RESET}"
}

update_uptime () {
	uptime="${uptime_colour}"$(~/.local/share/regexghost/panel/uptime)"${COLOUR_RESET}"
}

update_sunrise () {
	sunrise="${sunrise_colour}"$(~/.local/share/regexghost/panel/sunrise.sh --sunrise --blank)"${COLOUR_RESET}"
}

update_sunset () {
	sunset="${sunset_colour}"$(~/.local/share/regexghost/panel/sunrise.sh --sunset --blank)"${COLOUR_RESET}"
}

#update_weather () {
#	weather_days="$(~/.local/share/regexghost/panel/metoffice.sh)"
#	weather_today="$(~/.local/share/regexghost/panel/weather-formatter.sh --lemonbar "$(echo "$weather_days" | sed '1q;d')")"
#	weather_tomorrow="$(~/.local/share/regexghost/panel/weather-formatter.sh --lemonbar "$(echo "$weather_days" | sed '2q;d')")"
#	weather_2_days="$(~/.local/share/regexghost/panel/weather-formatter.sh --lemonbar "$(echo "$weather_days" | sed '3q;d')")"
#	weather="0${weather_today} 1${weather_tomorrow} 2${weather_2_days}"
#}

# This is done by index so I can change the streams checked by just altering the order in the config file
stream_live () {
	streamer_name="$(sed -n "${1}p" "$XDG_CONFIG_HOME/regexghost/streams.csv" | cut -d "," -f 1)"
	first_char="$(echo "$streamer_name" | cut -c 1-1)"
	live="$(stream-check -yn "$streamer_name")"
	if [ "$live" = "y" ]; then
		echo "${first_char} ${stream_live_colour}L ${COLOUR_RESET}"
	elif [ "$live" = "w" ]; then
		echo "${first_char} ${stream_not_live_colour}U ${COLOUR_RESET}"
	elif [ "$live" = "n" ]; then
		echo "${first_char} ${stream_not_live_colour}O ${COLOUR_RESET}"
	else
		echo "${first_char} ${stream_error_colour}E ${COLOUR_RESET}"
	fi
}

update_streams () {
	stream="$(stream_live 1) $(stream_live 2) $(stream_live 3)"
}

update_music () {
	state="$(mpc status | grep "^\[")"
	song="$(mpc current -f '%title% - %artist%' | string-trunc 16 ".." | sed 's/ $//g')"
	if [ "$state" = "" ]; then
		music="${music_stopped_colour}N/A${COLOUR_RESET}"
	elif echo "$state" | grep -q "playing"; then
		music="${music_playing_colour}${song}${COLOUR_RESET}"
	elif echo "$state" | grep -q "paused"; then
		music="${music_paused_colour}${song}${COLOUR_RESET}"
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
# 
# 
# 
# 
# 
# 

display () {
	printf " ${music} | ${stream}| ${sunset} | ${sunrise} | ${vol} | ${network_down} | ${wifi} | ${cpu} | ${uptime} | ${cpu_temp} | ${memory} | ${current_time} "
}

display

update_vol
update_wifi
update_time
update_sunrise
update_sunset
#update_weather
update_streams
update_music

i=1

trap "update_vol;display" "RTMIN"
trap "update_music;display" "RTMIN+1"

mpd () {
	mpc idleloop player | while read -r _; do
		kill -35 $(cat ~/.cache/bar_pid)
	done &
}

mpd &

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
		[ $((i % 600)) -eq 0 ] && update_streams
#		[ $((i % 360)) -eq 0 ] && update_weather
		i=$((i+1))
		[ $i -gt 900 ] && i=0
		display
	}
done
