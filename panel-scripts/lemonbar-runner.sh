#!/bin/sh

. "$XDG_CONFIG_HOME"/regexghost/current-theme.sh

"$XDG_DATA_HOME/regexghost/panel/lemonbar-bar.sh" | lemonbar -o +0 -f "${FONT_FAMILY} Medium:size=10" -o -2 -f "Font Awesome 7 Free Solid:size=10" -g 1310x26+610+0 -B "#${BACKGROUND_BLACK}" -F "#${FOREGROUND_WHITE}"
