#!/bin/sh

# Increase key rate (delay = 200, repeat rate = 40)
xset r rate 230 30

# Caps lock -> Escape
setxkbmap -option caps:escape

# Remap some keys (currently swapping ¬ and \, £ and |)
xmodmap "$XDG_DATA_HOME/regexghost/wm-scripts/Xmodmap"
