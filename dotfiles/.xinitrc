# Notifications
dunst & disown

# Increase key rate (delay = 200, repeat rate = 40)
xset r rate 200 40

# No screen timeout/auto sleep
xset s off
xset dpms 0 0 0

# Swap caps lock and escape
setxkbmap -option caps:escape

# lemonbar
(sleep 10 && ~/.local/share/regexghost/panel/lemonbar-runner.sh) & disown

# Wallpaper
(sleep 8 && feh --bg-fill --no-fehbg ~/.config/regexghost/background.jpg) & disown

# Compositor
(sleep 6 && xcompmgr -n) & disown

# Ctrl+Alt+Arrows to Home, End, PageUp and PageDown
xkbcomp -I$XDG_CONFIG_HOME/xkb $XDG_CONFIG_HOME/xkb/keymap/mykbd $DISPLAY

# Window manger
exec jwm 2> ~/.cache/xsession-errors
# exec awesome 2> ~/.cache/xsession-errors
# exec i3 2> ~/.cache/xsession-errors
