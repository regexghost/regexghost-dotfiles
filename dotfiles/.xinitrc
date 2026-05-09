# Notifications
dunst & disown

# Increase key rate (delay = 250, repeat rate = 40)
xset r rate 250 40

# No screen timeout/auto sleep
xset s off
xset dpms 0 0 0

(sleep 10 && ~/.local/share/regexghost/panel/lemonbar-runner.sh) & disown

# Window manger
exec jwm 2> ~/.cache/xsession-errors
