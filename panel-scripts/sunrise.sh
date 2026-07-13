#!/usr/bin/env bash

curLocationFile="$XDG_CONFIG_HOME/regexghost/current_location.csv"

lat=$(cat "$curLocationFile" | cut -d "|" -f 1)
lon=$(cat "$curLocationFile" | cut -d "|" -f 2)

theme=$(cat "$XDG_CONFIG_HOME/regexghost/current-theme.txt")

if [[ "$theme" == "dracula" ]]; then
	sunsetColour="8be9fd"
	sunriseColour="ffff80"
	goldenHourColour="ffff80"
elif [[ "$theme" == "christmas" ]]; then
	sunsetColour="FD971F"
	sunriseColour="F1C769"
	goldenHourColour="F1C769"
elif [[ "$theme" == "tube" ]]; then
	sunsetColour="e67823"
	sunriseColour="ffd204"
	goldenHourColour="ffd204"
fi

if [[ "$1" == "--sunrise" ]]; then
	#json_tomorrow=$(curl -s "https://api.sunrisesunset.io/json?lat=${lat}&lng=${lon}&date=tomorrow&time_format=24")
	json_tomorrow=$(curl --connect-timeout 5 -s "https://api.sunrise-sunset.org/json?lat=${lat}&lng=${lon}&date=tomorrow&formatted=0")
	sunrise=$(echo "$json_tomorrow" | jq -r .results.sunrise | sed 's/.*T//g' | sed 's/:[0-9]*+.*//g')
	[ "$sunrise" = "" ] && sunrise="?"
	astro_twilight=$(echo "$json_tomorrow" | jq -r .results.astronomical_twilight_begin | sed 's/.*T//g' | sed 's/:[0-9]*+.*//g')
	if [[ "$2" == "--conky" ]]; then
		echo "\${color #$sunriseColour}$astro_twilight - $sunrise \${color}"
	elif [[ "$2" == "--blank" ]]; then
		echo "$sunrise"
	else
		echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$sunriseColour'> </span> <span foreground='#$sunriseColour'>$astro_twilight - $sunrise </span>"
	fi
elif [[ "$1" == "--sunset" ]]; then
	#json_today=$(curl -s "https://api.sunrisesunset.io/json?lat=${lat}&lng=${lon}&time_format=24")
	json_today=$(curl --connect-timeout 5 -s "https://api.sunrise-sunset.org/json?lat=${lat}&lng=${lon}&date=today&formatted=0")
	sunset=$(echo "$json_today" | jq -r .results.sunset | sed 's/.*T//g' | sed 's/:[0-9]*+.*//g')
	[ "$sunset" = "" ] && sunset="?"
	astro_twilight=$(echo "$json_today" | jq -r .results.astronomical_twilight_end | sed 's/.*T//g' | sed 's/:[0-9]*+.*//g')
	if [[ "$2" == "--conky" ]]; then
		echo "\${color #$sunsetColour}$sunset - $astro_twilight \${color}"
	elif [[ "$2" == "--blank" ]]; then
		echo "$sunset"
	else
		echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$sunsetColour'> </span> <span foreground='#$sunsetColour'>$sunset - $astro_twilight </span>"
	fi
#elif [[ "$1" == "--golden-hour" ]]; then
#	json_today=$(curl -s "https://api.sunrisesunset.io/json?lat=${lat}&lng=${lon}&time_format=24")
#	golden_hour=$(echo "$json_today" | jq -r .results.golden_hour | sed 's/:[0-9]*$//g')
#	echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$goldenHourColour'> </span> <span foreground='#$goldenHourColour'>$golden_hour </span>"
fi


