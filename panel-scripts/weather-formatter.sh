#!/usr/bin/env bash

# Formatter for weather conditions
# Takes string (e.g. "Overcast Sunny") and outputs icon with colour formatting

source "$XDG_CONFIG_HOME/regexghost/current-theme.sh"

function format() {
	icon_name="$1"
	if [[ "$2" == "conky" ]]; then
		if [[ "$icon_name" == "Sunny day" ]]; then
			echo "\${color #$YELLOW}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Light shower day" ]]; then
			echo "\${color #$WHITE}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Heavy shower day" ]]; then
			echo "\${color #$WHITE}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Sunny intervals" ]]; then
			echo "\${color #$YELLOW}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Light rain" ]]; then
			echo "\${color #$BRIGHT_BLACK}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Heavy rain" ]]; then
			echo "\${color #$BLUE}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Cloudy" ]]; then
			echo "\${color #$WHITE}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Overcast" ]]; then
			echo "\${color #$BRIGHT_BLACK}\${font4}  \${font}\${color}"
		elif [[ "$icon_name" == "Light snow shower day" ]]; then
			echo "\${color #$WHITE}\${font4}  \${font}\${color}"
		else
			echo "\${color #$RED}\${font4}  \${font}\${color}"
		fi
	elif [[ "$2" == "lemonbar" ]]; then
		if [[ "$icon_name" == "Sunny day" ]]; then
			echo "%{F#$YELLOW}  %{F-}"
		elif [[ "$icon_name" == "Light shower day" ]]; then
			echo "%{F#$WHITE}  %{F-}"
		elif [[ "$icon_name" == "Heavy shower day" ]]; then
			echo "%{F#$WHITE}  %{F-}"
		elif [[ "$icon_name" == "Sunny intervals" ]]; then
			echo "%{F#$YELLOW}  %{F-}"
		elif [[ "$icon_name" == "Light rain" ]]; then
			echo "%{F#$BRIGHT_BLACK}  %{F-}"
		elif [[ "$icon_name" == "Heavy rain" ]]; then
			echo "%{F#$BLUE}  %{F-}"
		elif [[ "$icon_name" == "Cloudy" ]]; then
			echo "%{F#$WHITE}  %{F-}"
		elif [[ "$icon_name" == "Overcast" ]]; then
			echo "%{F#$BRIGHT_BLACK}  %{F-}"
		elif [[ "$icon_name" == "Light snow shower day" ]]; then
			echo "%{F#$WHITE}  %{F-}"
		else
			echo "%{F#$RED}  %{F-}"
		fi
	else
		if [[ "$icon_name" == "Sunny day" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$YELLOW'>  </span>"
		elif [[ "$icon_name" == "Light shower day" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$WHITE'>  </span>"
		elif [[ "$icon_name" == "Heavy shower day" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$WHITE'>  </span>"
		elif [[ "$icon_name" == "Sunny intervals" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$YELLOW'>  </span>"
		elif [[ "$icon_name" == "Light rain" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$BRIGHT_BLACK'>  </span>"
		elif [[ "$icon_name" == "Heavy rain" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$BLUE'>  </span>"
		elif [[ "$icon_name" == "Cloudy" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$WHITE'>  </span>"
		elif [[ "$icon_name" == "Overcast" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$BRIGHT_BLACK'>  </span>"
		elif [[ "$icon_name" == "Light snow shower day" ]]; then
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$WHITE'>  </span>"
		else
			echo "<span font='Font Awesome 7 Free Solid 9' foreground='#$RED'>  </span>"
		fi
	fi
}

if [[ "$1" == "--conky" ]]; then
	echo "$(format "$2" conky)"
elif [[ "$1" == "--lemonbar" ]]; then
	echo "$(format "$2" lemonbar)"
else
	echo "$(format "$1")"
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
