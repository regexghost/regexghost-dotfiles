#!/usr/bin/env bash

# This script is quite ugly and needs re-writing, but it works for now

theme=$(cat "$XDG_CONFIG_HOME/regexghost/current_theme.txt")

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

if [[ "$theme" == "dracula" ]]; then
	whiteColour="f8f8f1"
	greyColour="a1a3ac"
	redColour="e64747"
	yellowColour="ffff80"
	blueColour="8be9fd"
elif [[ "$theme" == "christmas" ]]; then
	whiteColour="F8F8F0"
	greyColour="a1a3ac"
	redColour="DD4D44"
	yellowColour="F1C769"
	blueColour="8be9fd"
elif [[ "$theme" == "tube" ]]; then
	whiteColour="ffffff"
	greyColour="737171"
	redColour="ee2e24"
	yellowColour="ffd204"
	blueColour="009ddc"
fi

curLocationFile="$XDG_CONFIG_HOME/regexghost/current_location.csv"

lat=$(cat "$curLocationFile" | cut -d "|" -f 1)
lon=$(cat "$curLocationFile" | cut -d "|" -f 2)
geohash=$(geohash $lat $lon 9)
today_string="$(date "+%Y-%m-%d")"
tomorrow_string="$(date -d tomorrow "+%Y-%m-%d")"
second_day_string="$(date -d "+2 days" "+%Y-%m-%d")"

curl -s -L "https://weather.metoffice.gov.uk/forecast/$geohash" > "/tmp/panel_i3_data/metoffice.html"
icon_name_today=$(cat "/tmp/panel_i3_data/metoffice.html" | grep -A 5 -B 5 -i "datetime=\"$today_string\"" | grep "class=\"tab-icon\"" | sed 's/;" class.*//g' | sed 's/.*alt="//g')
icon_name_tomorrow=$(cat "/tmp/panel_i3_data/metoffice.html" | grep -A 5 -B 5 -i "datetime=\"$tomorrow_string\"" | grep "class=\"tab-icon\"" | sed 's/;" class.*//g' | sed 's/.*alt="//g')
icon_name_second_day=$(cat "/tmp/panel_i3_data/metoffice.html" | grep -A 5 -B 5 -i "datetime=\"$second_day_string\"" | grep "class=\"tab-icon\"" | sed 's/;" class.*//g' | sed 's/.*alt="//g')

function format() {
	icon_name="$1"
	if [[ "$2" == "conky" ]]; then
		if [[ "$icon_name" == "Sunny day" ]]; then
			echo "\${color #$yellowColour}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Light shower day" ]]; then
			echo "\${color #$whiteColour}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Sunny intervals" ]]; then
			echo "\${color #$yellowColour}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Light rain" ]]; then
			echo "\${color #$greyColour}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Heavy rain" ]]; then
			echo "\${color #$blueColour}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Cloudy" ]]; then
			echo "\${color #$whiteColour}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Overcast" ]]; then
			echo "\${color #$greyColour}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Light snow shower day" ]]; then
			echo "\${color #$whiteColour}\${font4}  \${font}\${color}"
		else
			echo "\${color #$redColour}\${font4}  \${font}\${color}"
		fi
	elif [[ "$2" == "lemonbar" ]]; then
		if [[ "$icon_name" == "Sunny day" ]]; then
			echo "%{F#$yellowColour}  %{F-}"
		elif [[ "$icon_name" == "Light shower day" ]]; then
			echo "%{F#$whiteColour}  %{F-}"
		elif [[ "$icon_name" == "Sunny intervals" ]]; then
			echo "%{F#$yellowColour}  %{F-}"
		elif [[ "$icon_name" == "Light rain" ]]; then
			echo "%{F#$greyColour}  %{F-}"
		elif [[ "$icon_name" == "Heavy rain" ]]; then
			echo "%{F#$blueColour}  %{F-}"
		elif [[ "$icon_name" == "Cloudy" ]]; then
			echo "%{F#$whiteColour}  %{F-}"
		elif [[ "$icon_name" == "Overcast" ]]; then
			echo "%{F#$greyColour}  %{F-}"
		elif [[ "$icon_name" == "Light snow shower day" ]]; then
			echo "%{F#$whiteColour}  %{F-}"
		else
			echo "%{F#$redColour}  %{F-}"
		fi
	else
		if [[ "$icon_name" == "Sunny day" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$yellowColour'>  </span>"
		elif [[ "$icon_name" == "Light shower day" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$whiteColour'>  </span>"
		elif [[ "$icon_name" == "Sunny intervals" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$yellowColour'>  </span>"
		elif [[ "$icon_name" == "Light rain" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$greyColour'>  </span>"
		elif [[ "$icon_name" == "Heavy rain" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$blueColour'>  </span>"
		elif [[ "$icon_name" == "Cloudy" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$whiteColour'>  </span>"
		elif [[ "$icon_name" == "Overcast" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$greyColour'>  </span>"
		elif [[ "$icon_name" == "Light snow shower day" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$whiteColour'>  </span>"
		else
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$redColour'>  </span>"
		fi
	fi
}

if [[ "$1" == "--conky" ]]; then
	echo "0:$(format "$icon_name_today" conky) 1:$(format "$icon_name_tomorrow" conky) 2:$(format "$icon_name_second_day" conky)"
elif [[ "$1" == "--lemonbar" ]]; then
	echo "0:$(format "$icon_name_today" lemonbar) 1:$(format "$icon_name_tomorrow" lemonbar) 2:$(format "$icon_name_second_day" lemonbar)"

else
	echo "0:$(format "$icon_name_today") 1:$(format "$icon_name_tomorrow") 2:$(format "$icon_name_second_day")"
fi

# moon rain 
# heavy showers 
# snow 
# lightning 
# bolt 
# sun 
# moon 
# smog 
# tornado 
# cloud showers water 
# cloud moon 
# hurricane 
# water 
# wind 
# bolt lightning 
# umbrella 
# volcano 
# temperature half 
# temperature three quarters 
# temperature quarter 
# temperature low 
# temperature high 
# temperature full 
# temperature empty 
# temperature arrow up 
# temperature arrow down 
# sun plant wilt 
# rainbow 
# icicles 
# house tsunami 
