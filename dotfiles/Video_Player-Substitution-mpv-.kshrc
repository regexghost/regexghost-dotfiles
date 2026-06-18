#### Start Substitute - Video_Player
# Open video(s) with mpv
mp () {
	/usr/bin/mpv --really-quiet --save-position-on-quit "$@" & disown
}
#### End Substitute
