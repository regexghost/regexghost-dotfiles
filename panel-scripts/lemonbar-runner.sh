#!/bin/sh

. "$XDG_CONFIG_HOME"/regexghost/current-theme.sh

"$XDG_DATA_HOME/regexghost/panel/lemonbar-bar.sh" | lemonbar -o -0 -f "${FONT_FAMILY} Regular:size=11" -o -2 -f "Font Awesome 7 Free Solid:size=10" -g 1200x26+720+0 -B "#${BACKGROUND_BLACK}" -F "#${FOREGROUND_WHITE}"
