#!/bin/sh

. "$XDG_CONFIG_HOME"/regexghost/current-theme.sh

"$XDG_DATA_HOME/regexghost/panel/lemonbar-bar.sh" | lemonbar -o +0 -f "${FONT_FAMILY} Medium:size=10:style=bold" -o -2 -f "Noto Sans Mono CJK KR:size=10" -o -3 -f "Font Awesome 7 Free Solid:size=10" -g 1428x26+492+0 -B "#${BACKGROUND_BLACK}" -F "#${FOREGROUND_WHITE}"
