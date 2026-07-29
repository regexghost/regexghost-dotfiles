#!/bin/sh

DMENU_SCRIPT="$XDG_DATA_HOME/regexghost/wm-scripts/dmenu-runner.sh"
SNIPPETS_DIR="$XDG_DATA_HOME/regexghost/snippets"

output="$(ls "$SNIPPETS_DIR" | "$DMENU_SCRIPT" "Select Snippet:")"
status=$?
file="${SNIPPETS_DIR}/${output}"

if [ -x "$file" ]; then
	result="$("$file")"
else
	result="$(cat "$file")"
fi

echo -n "$result" | xclip -selection clipboard
