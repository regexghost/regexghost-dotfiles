#!/usr/bin/env sh

DMENU_SCRIPT="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"
BOOKMARKS_FILE="$XDG_DATA_HOME/regexghost/script-data/bookmarks.txt"

output="$(cat "$BOOKMARKS_FILE" | sed 's/DELIM.*//g' | "${DMENU_SCRIPT}" "Select Bookmark:")"
status=$?

real_bookmark=$(cat "$BOOKMARKS_FILE" | grep "${output}DELIM" | sed 's/.*DELIM//g')

# Return - default
if [ $status -eq 0 ]; then
	echo -n $real_bookmark | xclip -selection clipboard
# Shift+Return - type/open url
elif [ $status -eq 10 ]; then
	if echo "$real_bookmark" | grep -q "^http"; then
		$BROWSER "$real_bookmark"
	else
		xdotool type "$real_bookmark"
	fi
fi
