#### Start Substitute - Video_Player
# Open video(s) with vlc
mp () {
	setsid /usr/bin/vlc "$@" 2> /dev/null &
}
#### End Substitute
