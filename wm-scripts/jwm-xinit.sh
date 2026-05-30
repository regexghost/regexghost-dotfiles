#!/bin/sh

# lemonbar
(sleep 10 && ~/.local/share/regexghost/panel/lemonbar-runner) &

# Wallpaper
(sleep 8 && feh --bg-fill --no-fehbg ~/.config/regexghost/background.jpg) &

# Compositor
(sleep 6 && xcompmgr -n) &

# Window manager
exec jwm 2> ~/.cache/xsession-errors
