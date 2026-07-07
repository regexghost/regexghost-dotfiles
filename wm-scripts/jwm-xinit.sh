#!/bin/sh

# lemonbar
(sleep 10 && ~/.local/share/regexghost/panel/lemonbar-runner.sh) &

# Wallpaper
(sleep 8 && feh --bg-fill --no-fehbg ~/.config/regexghost/wallpaper.jpg) &

# Compositor
#(sleep 6 && xcompmgr -n) &
(sleep 6 && picom --backend xrender --vsync) &

# Window manager
exec jwm 2> ~/.cache/xsession-errors
