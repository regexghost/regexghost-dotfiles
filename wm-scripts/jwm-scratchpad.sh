#!/bin/sh

scratchpad="$(xdotool search --class "scratchpad")"
old_focus="$(cat ~/.cache/old_window)"

launch_window () {
	tmux new-session -d -s "buffer_tmux" 'nano ~/Downloads/buffer.md; oksh'
	setsid /usr/local/bin/st -c "scratchpad" -t "buffer" -e tmux attach -t "buffer_tmux" &
	sleep 0.5
	scratchpad="$(xdotool search --class "scratchpad")"
	xdotool windowmove "$scratchpad" 610 300
}

hide_window () {
	xdotool windowmove "$scratchpad" -1000 -1000
#	xdotool windowactivate "$old_focus"
#	xdotool set_desktop_for_window "$scratchpad" 5
	xdotool windowminimize "$scratchpad"
}

show_window () {
#	xdotool getactivewindow > ~/.cache/old_window
	desktop="$(xdotool get_desktop)"
	xdotool set_desktop_for_window "$scratchpad" "$desktop"
	xdotool windowactivate "$scratchpad"
	xdotool windowmove "$scratchpad" 610 300
}

if [ "$scratchpad" = "" ]; then
	launch_window
	exit
fi

focus="$(xdotool getwindowfocus)"
if [ "$focus" = "$scratchpad" ]; then
	hide_window
else
	show_window
fi

