#!/bin/sh

# Script using dmenu to search wikis

# Example config:
# `https://en.wikipedia.org/wiki,https://en.wikipedia.org/w/api.php,Wikipedia`
# `https://wiki.factorio.com,https://wiki.factorio.com/api.php,Factorio Wiki`
# Basically the format is base-url,api-url,name

WIKI_FILE="$XDG_CONFIG_HOME/regexghost/wiki-list.csv"

DMENU_RUNNER="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"

wiki_to_search="$(cat "$WIKI_FILE" | cut -d "," -f 3- | "$DMENU_RUNNER" "Select wiki to search" -ix)"

[ "$wiki_to_search" = "" ] && exit

wiki_to_search=$((wiki_to_search+1))

name="$(sed -n "${wiki_to_search}p" "$WIKI_FILE" | cut -d "," -f 3-)"
url="$(sed -n "${wiki_to_search}p" "$WIKI_FILE" | cut -d "," -f 1)"
api_url="$(sed -n "${wiki_to_search}p" "$WIKI_FILE" | cut -d "," -f 2)"

search_term="$(echo "" | "$DMENU_RUNNER" "Enter search term (or none for homepage)" -pa)"

status="$?"

[ "$status" = "0" ] || exit

if [ "$search_term" = "" ]; then
	"$BROWSER" "$url"
	exit
fi

search_term="$(echo "$search_term" | sed 's/ /+/g')"

results="$(curl "${api_url}?action=query&format=json&list=search&srsearch=${search_term}" | sed 's/\\n//g')"

titles="$(echo "$results" | jq -r .query.search.[].title)"

if [ "$titles" = "" ] || [ "$title" = "null" ]; then
	notify-send "No results"
	exit
fi

selected_page="$(echo "$titles" | "$DMENU_RUNNER" "Select page" | sed 's/ /_/g')"

[ "$selected_page" = "" ] && exit

"$BROWSER" "${url}/${selected_page}"
