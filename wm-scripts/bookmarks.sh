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
# Ctrl+a - add new
elif [ $status -eq 11 ]; then
	new_bookmark="$(echo "" | "${DMENU_SCRIPT}" "Enter new bookmark:" -pa)"
	new_alias="$(echo "" | "${DMENU_SCRIPT}" "Enter alias (blank for none):" -pa)"
	[ "$new_alias" = "" ] && new_alias="$new_bookmark"
	echo "${new_alias}DELIM${new_bookmark}" >> "$BOOKMARKS_FILE"
# Ctrl+w - delete
elif [ $status -eq 12 ]; then
	yes_or_no="$(echo "No\nYes" | "${DMENU_SCRIPT}" "Delete Bookmark ${output} (?):")"
	if [ "$yes_or_no" = "Yes" ]; then
		line="$(grep -n "${output}DELIM${real_bookmark}" $BOOKMARKS_FILE | sed 's/:.*//g')"
		sed "${line}d" $BOOKMARKS_FILE > /tmp/out
		mv /tmp/out $BOOKMARKS_FILE
	fi
fi
