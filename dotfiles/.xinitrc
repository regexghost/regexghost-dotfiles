# Notifications
dunst & disown

# No screen timeout/auto sleep
xset s off
xset dpms 0 0 0

# Keyboard settings
~/.local/share/regexghost/wm-scripts/keyboard-settings.sh

# Ctrl+Alt+Arrows to Home, End, PageUp and PageDown
xkbcomp -I$XDG_CONFIG_HOME/xkb $XDG_CONFIG_HOME/xkb/keymap/mykbd $DISPLAY

#### Start Substitute - xinit script
