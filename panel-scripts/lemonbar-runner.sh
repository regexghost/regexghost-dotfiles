#!/bin/sh

. "$XDG_CONFIG_HOME"/regexghost/current-theme.sh

"$XDG_DATA_HOME/regexghost/panel/lemonbar-bar.sh" | lemonbar -o +1 -f "${FONT_FAMILY} Medium:size=10" -o -1 -f "Font Awesome 7 Free Solid:size=10" -g 1260x25+660+0 -B "#${BACKGROUND_BLACK}" -F "#${FOREGROUND_WHITE}"
