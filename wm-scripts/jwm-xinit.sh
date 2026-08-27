#!/bin/sh

# lemonbar
(sleep 10 && ~/.local/share/regexghost/panel/lemonbar-runner.sh) &

# Wallpaper
(sleep 8 && feh --bg-fill --no-fehbg ~/.config/regexghost/wallpaper.jpg) &

# Compositor
#(sleep 6 && xcompmgr -n) &
(sleep 6 && picom --backend xrender --vsync) &

# Night-shift
(sleep 16 && gammastep -O 5200) &

# Alt Tab
. ~/.config/regexghost/current-theme.sh
(sleep 6 && alttab -font "xft:Fira Code-11" -bg "#${BACKGROUND_GREY}" -fg "#${FOREGROUND_WHITE}" -frame "#${GREEN}" -t 110x80) &

# Window manager
exec jwm 2> ~/.cache/xsession-errors
