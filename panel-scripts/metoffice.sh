#!/usr/bin/env bash

# This script is quite ugly and needs re-writing, but it works for now

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

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

echo "$icon_name_today"
echo "$icon_name_tomorrow"
echo "$icon_name_second_day"
