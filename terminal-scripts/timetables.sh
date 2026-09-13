#!/bin/sh

LOC="$HOME/Downloads/Files/timetables/"

timetable="$(find "$LOC" -type f | sed "s|$LOC||g" | sed 's/bus\//Bus - /g; s/train\//Train - /g' | fzf | sed 's/Bus - /bus\//g; s/Train - /train\//g')"

[ "$timetable" = "" ] && exit

"${PDF_VIEWER:-zathura}" "${LOC}/${timetable}"
