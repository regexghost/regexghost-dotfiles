#!/bin/sh

# Increase key rate (delay = 200, repeat rate = 40)
xset r rate 200 40

# Caps lock -> Escape
setxkbmap -option caps:escape
