#!/usr/bin/env bash

# This script is quite ugly and needs re-writing, but it works for now

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

curLocationFile="$XDG_CONFIG_HOME/regexghost/current_location.csv"

lat=$(cat "$curLocationFile" | cut -d "|" -f 1)
lon=$(cat "$curLocationFile" | cut -d "|" -f 2)
geohash=$(geohash $lat $lon 9)
today_string="$(date "+%Y-%m-%d")"
tomorrow_string="$(date -d $(($(date +%s)+86400)) "+%Y-%m-%d")"
second_day_string="$(date -d $(($(date +%s)+86400+86400)) "+%Y-%m-%d")"

curl --connect-timeout 5 -s -L "https://weather.metoffice.gov.uk/forecast/$geohash" > "/tmp/panel_i3_data/metoffice.html"
# awk instead of grep -A/-B - https://superuser.com/questions/298123/how-to-grep-and-print-the-next-n-lines-after-the-hit/298127#298127
icon_name_today=$(awk -v var="$today_string" '$0 ~ "datetime=\"" var "\"" {p = 5} p > 0 {print $0; p--}' "/tmp/panel_i3_data/metoffice.html" | grep "class=\"tab-icon\"" | sed 's/;" class.*//g' | sed 's/.*alt="//g')
icon_name_tomorrow=$(awk -v var="$today_string" '$0 ~ "datetime=\"" var "\"" {p = 5} p > 0 {print $0; p--}' "/tmp/panel_i3_data/metoffice.html" | grep "class=\"tab-icon\"" | sed 's/;" class.*//g' | sed 's/.*alt="//g')
icon_name_second_day=$(awk -v var="$today_string" '$0 ~ "datetime=\"" var "\"" {p = 5} p > 0 {print $0; p--}' "/tmp/panel_i3_data/metoffice.html" | grep "class=\"tab-icon\"" | sed 's/;" class.*//g' | sed 's/.*alt="//g')

echo "$icon_name_today"
echo "$icon_name_tomorrow"
echo "$icon_name_second_day"


