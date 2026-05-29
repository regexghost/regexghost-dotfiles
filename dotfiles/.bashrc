# regexghost's .bashrc file
# Hopefully in a coherent order

PROMPT_COMMAND=
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi

# Add my directory_bookmarks program to the prompt when relevant
PS1='\[\033[1;30m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;34m\]$(directory_bookmarks current)\[\033[1;31m\]\$\[\033[0m\] '

## Function to remove things which aren't useful from bash history
trim_history () {
	sed -i -r '/^(history|hs|qalc|vis|cava|nethogs|btop|htop|gitl|gitd|gits|x|rm|cd|c|exit|lsa|ls|l|q)$/d' ~/.bash_history
	# Remove any usage of fasd z autojump command
	sed -i '/^z .*/d' ~/.bash_history
	sed -i '/^zz .*/d' ~/.bash_history
	# Remove any usage of rm command
	sed -i '/^rm .*/d' ~/.bash_history
	sed -i '/^youtube .*/d' ~/.bash_history
	sed -i '/^to .*/d' ~/.bash_history
	
	# Remove any usage of cd, ls and mpv when only going one folder deeper in file structure
	sed -i -r '/^(cd|ls|mpv|mpv) [^\/\>\<|:&]*\/? ?$/d' ~/.bash_history
	# Remove any usage of m, rs and pdf when not going into a different folder
	sed -i -r '/^(m|rs|pdf) [^\/\>\<|:&]* ?$/d' ~/.bash_history
	# Remove anything in all caps, as it will basically always be a mistype
	sed -i '/^[A-Z0-9 ]*$/d' ~/.bash_history
	# Remove all duplicates, keeping most recent
	tac ~/.bash_history | awk '!x[$0]++' | tac > ~/.bash_history_no_dupes && command mv ~/.bash_history_no_dupes ~/.bash_history
	#sed --in-place 's/[[:space:]]\+$//' .bash_history && awk -i inplace '!seen[$0]++' .bash_history
}

# Basic Aliases
alias grep='grep -i --color=auto'
alias greps='/usr/bin/grep --color=auto' # Case sensitive
alias grepa='grep -i -I -A 5 -B 5 --color=auto'
alias diff='diff --color'
alias hs='history'
alias n='nano'
alias ra='ranger'
alias py='python3'
alias nf='fastfetch'
alias sq='ncdu --color off' # Not sure why this is "sq" but I'm used to it now
alias bat='batcat --theme=base16'
alias mv='mv -i'
alias cp='cp -r -i'
alias cmatrix='cmatrix -u 6' # Cool fake hacker program
alias duf='duf -hide special'
alias gtop='sudo intel_gpu_top'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias rm='rm-trash'
alias cheat='cheat -c'
alias zbr='zig build run'
alias bluey='bluetui'
alias fontsreload='sudo fc-cache -fv'
alias trash-size='du ~/.local/share/Trash/files/ -s -h | cut -f 1'
alias sync='echo "Syncing"; sync; echo "Done"; lsblk'

# Not POSIX compliant
function grepc () {
	grep -oP ".{0,100}${1}.{0,100}"
}

function nnn () {
	export NNN_FIFO=/tmp/nnn.fifo
	export NNN_PLUG=v:preview-tui
	tmux new-session -d -s mys "nnn -P v"
	tmux attach
}

function rss () {
	command cp "$XDG_DATA_HOME/newsraft/newsraft.sqlite3" "/tmp/newsraft.sqlite3"
	newsraft -d "/tmp/newsraft.sqlite3"
	command mv  "/tmp/newsraft.sqlite3" "$XDG_DATA_HOME/newsraft/newsraft.sqlite3"
}

# Aliases to Specific Commands

alias x='chmod +x'
alias copy='xclip -selection c'
alias batl='find . -maxdepth 1 | sort | tail -n 1 | xargs bat --theme=base16'
alias watchlc="watch 'ls | wc -l'"
alias watchdu="watch 'du -s -h *'"
alias lastyear='log -d $(date -d "-1 year" +"%y%m%d")' # Interacts with my log program
alias fatmount='sudo mount -o rw,users,umask=000' # Mount FAT formatted drive correctly
alias rmedir='find . -type d -empty -delete'
alias balance='aacgain -r -m 1 *.m4a'
alias vol='pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -d "/" -f 2 | sed "s/ //g"'
alias clearlogs='sudo journalctl --vacuum-time=2d'
alias q='trim_history && exit'
alias reload='. ~/.bashrc'

# Git Aliases

alias gd='git diff'
alias gdc='git diff --word-diff-regex=.'
alias gits='git status'
alias gs='git status .'
alias gpl='git pull'
alias gl='git log'
alias giturl='git config --get remote.origin.url'
alias gp='git push'
alias ga='git add'

# Get password and push (GitHub)
function gpp () {
	keepassxc-cli show ~/Downloads/passwords.kdbx "GitHub" | grep Notes | cut -d " " -f 2 | xclip -selection clipboard
	git push -u origin
	echo " " | xclip -selection clipboard
}

function gpa () {
	gpp
	git push -u codeberg
	git push -u mine
}

#### Start Substitute - Package_Manager

# Other random aliases

alias as='echo "Use \as to run as command, disabled as too easy to type accidentally, creating unnecessary a.out file in home directory"'
alias todo='$VISUAL ~/Documents/todo.md'
alias durationr='media-file-duration . -r'
alias durationi='media-file-duration . -i'

## Functions to basic programs

# fzf -> editor
function qfi () {
	file="$(find ~/* | grep -E '.py$|.go$|.txt$|.md$|.java$|.js$|.html$|.css$|.c$|.cc$|.conf$|.lua$|.rs$|.sh$|.bash$|.csv$' | sed 's|'"$HOME"'|~|g' | fzf --bind 'ctrl-backspace:backward-kill-word' --bind 'ctrl-delete:kill-word' --bind 'ctrl-right:forward-word' --bind 'ctrl-left:backward-word')"
	[[ "$file" == "" ]] && return
	$VISUAL "$file"
}

alias m='micro -clipboard terminal'
alias v='vim'

function batf () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	batcat --theme=base16 "$result"
}

function lsblk () {
	if [[ "$1" == "-a" ]]; then
		/usr/bin/lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS
	else
		/usr/bin/lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
	fi
}

function do_pkill () {
	pkill "$@"
	[ "$?" == "0" ] || echo "Program not found"
}

alias pkill='do_pkill'

function storage () {
	root_line=$(df -h | grep ' /$' | tr -s " ")
	used=$(echo "$root_line" | cut -d " " -f 3)
	free=$(echo "$root_line" | cut -d " " -f 4)
	echo "Used: ${used}"
	echo "Free: ${free}"
}

function trash-empty() {
	echo "Trash is $(trash-size)"
	/usr/bin/trash-empty
}

# Only use this if the history in the current terminal is suddenly way shorter than it should be
function restorebashhistory () {
	history | sed 's/^[ ]*[0-9]*[ ]*//g' > /tmp/new_history
	cat "$HOME/Downloads/.bash_history_backup" /tmp/new_history > /tmp/all_history
	mv /tmp/all_history "$HOME/.bash_history"
}

function cal () {
	MAGENTA_COLOUR='\033[0;35m\033[1m'
	RED_COLOUR='\033[0;34m\033[1m'
	BLUE_COLOUR='\033[0;36m\033[1m'
	RESET_COLOUR='\033[0m'
	
	function suffix () {
		if [[ "$1" == "1" ]] || [[ "$1" == "21" ]] || [[ "$1" == "31" ]]; then
			echo "st"
		elif [[ "$1" == "2" ]] || [[ "$1" == "22" ]]; then
			echo "nd"
		elif [[ "$1" == "3" ]] || [[ "$1" == "23" ]]; then
			echo "rd"
		else
			echo "th"
		fi
	}

	unbuffer cal -w -n 3 "$@" | sed '/^ *$/d'
	
	day="$(date +'%A')"
	date="$(date +'%d')"
	week="$(date +'%W')"
	
	echo -e "${RED_COLOUR}Day:${RESET_COLOUR}  ${day}"
	echo -e "${BLUE_COLOUR}Date:${RESET_COLOUR} ${date}$(suffix $date)"
	echo -e "${MAGENTA_COLOUR}Week:${RESET_COLOUR} ${week}"
}

function pyweb () {
	$(sleep 0.5 && firefox "http://0.0.0.0:8000/") &
	python3 -m http.server -d "$1"
}

## Function to show time in various locations
function t () {
	MAGENTA_COLOUR='\033[0;35m\033[1m'
	RESET_COLOUR='\033[0m'
	curDateZone=$(date +"%a, %b %d (%Z)")
	TZ="America/Los_Angeles" date +"  Los Angeles:    %H:%M:%S - %a, %b %d (%Z)"
	TZ="America/New_York" date +"  New York:       %H:%M:%S - %a, %b %d (%Z)"
	date -u +"  UTC:            %H:%M:%S - %a, %b %d (%Z)"
	TZ="Europe/London" date +"  London:         %H:%M:%S - %a, %b %d (%Z)"
	TZ="Europe/Paris" date +"  Paris:          %H:%M:%S - %a, %b %d (%Z)"
	TZ="Asia/Seoul" date +"  Seoul:          %H:%M:%S - %a, %b %d (%Z)"
	TZ="Australia/Sydney" date +"  Sydney:         %H:%M:%S - %a, %b %d (%Z)"
}

# External program openers

#### Start Substitute - Image_Viewer

#### Start Substitute - Video_Player

#### Start Substitute - PDF_Viewer

# Power Management Functions

#### Start Substitute - Power_Management

# yt-dlp helper function
do_yt-dlp () {
	local aria_args=()
	local metadata_args=()
	local cookies_args=()
	local archive_args=()
	local other_args=()
	output_format_args=(-o "%(title)s.%(ext)s")
	format_args=()
	
	while [[ $# -gt 0 ]]; do
		case "$1" in
			--aria)
				aria_args+=("--external-downloader" "aria2c" "--external-downloader-args" "aria2c:-x 16 -j 16 -s 16 -k 1M")
				shift
				;;
			--aria-limit)
				download_limit="3"
				num_re='^[0-9]+M*$'
				if [[ "$2" =~ $num_re ]]; then
					download_limit="${2//M}"
					shift
				fi
				aria_args+=("--external-downloader" "aria2c" "--external-downloader-args" "aria2c:-x 16 -j 16 -s 16 -k 1M --max-overall-download-limit=${download_limit}M")
				shift
				;;
			--all-metadata)
				metadata_args+=("--embed-chapters" "--embed-thumbnail" "--embed-metadata")
				shift
				;;
			--music)
				output_format_args=(-o "%(title)s -- %(channel)s -- %(album)s.%(ext)s")
				format_args=(-f 140)
				shift
				;;
			--playlist-order)
				output_format_args=(-o "%(playlist_index)s-%(title)s.%(ext)s")
				shift
				;;
			--standard)
				format_args=(-f "22/bestvideo[height<=720]+bestaudio")
				shift
				;;
			--firefox-cookies)
				cookies_args=("--cookies-from-browser" "firefox")
				shift
				;;
			--archive)
				archive_args=("--download-archive" "archive.txt")
				shift
				;;
			--1080p)
				format_args=("-f" "bestvideo[height<=1080][protocol=https][vcodec*=avc]+bestaudio[ext=m4a]")
				shift
				;;
			--720p)
				format_args=("-f" "bestvideo[height<=720][protocol=https][vcodec*=avc]+bestaudio[ext=m4a]")
				shift
				;;
			--480p)
				format_args=("-f" "bestvideo[height<=480][protocol=https][vcodec*=avc]+bestaudio[ext=m4a]")
				shift
				;;
			--360p)
				format_args=("-f" "bestvideo[height<=360][protocol=https][vcodec*=avc]+bestaudio[ext=m4a]")
				shift
				;;
			*)
				other_args+=("$1")
				shift
				;;
		esac
	done
	
	local all_args=("${output_format_args[@]}" "${aria_args[@]}" "${metadata_args[@]}" "${cookies_args[@]}" "${format_args[@]}" "${archive_args[@]}" "${other_args[@]}" "$@")
	/usr/bin/yt-dlp "${all_args[@]}"
}

## Alias to allow escaping with backslash
alias yt-dlp='do_yt-dlp'

function yt-playlist () {
	quality_option="--720p"
	if [[ "$1" == "--1080p" ]]; then
		quality_option="--1080p"
		shift
	fi
	do_yt-dlp --playlist-order --all-metadata --firefox-cookies --aria --archive "$quality_option" "$@"
}

function archivevideo() {
	for url in "$@"; do
		yt-dlp --cookies-from-browser firefox -o "%(title)s.%(ext)s" --embed-chapters --embed-thumbnail --embed-metadata -f "bestvideo[protocol=https][vcodec*=avc]+bestaudio[ext=m4a]" "$url"
	done
}

function archiveplaylist() {
	if [[ "$1" == "-t" ]]; then
		yt-dlp --cookies-from-browser firefox --flat-playlist --skip-download -J "$2" | jq '{title, videos: [.entries[] | {title, channel, id}]}' | yq -t
	else
		yt-dlp --cookies-from-browser firefox -J --flat-playlist "$1" | jq '.entries[] | [.title,.channel,.url]| @csv'
	fi
}

# Search commands

alias hs='history'
alias his='history | grep'

## Search root directory
findr () {
	find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

alias findh='find ~ -iname'
alias fig='find . | sort | grep'
alias psg='ps -aux | grep'

# Load my other aliases and functions

source "$HOME/.local/share/regexghost/terminal/autocompletion.bash"
source "$HOME/.local/share/regexghost/terminal/ls_aliases.bash"
[ -f ~/Programs/localStuff/aliases.sh ] && source ~/Programs/localStuff/aliases.sh
[ -f ~/.profile ] && source ~/.profile

# Set variables

HISTSIZE=80000
HISTFILESIZE=80000

export HISTCONTROL=ignoreboth:erasedups
export MICRO_TRUECOLOR=1
export PASSWORD_STORE_CLIP_TIME=120

# Quick file/directory access

alias doc='cd ~/Documents/'
alias dow='cd ~/Downloads/'
alias mus='cd ~/Music/'
alias vid='cd ~/Videos/'
alias pic='cd ~/Pictures/'
alias pro='cd ~/Programs/'
alias wor='cd ~/Work/'
alias loc='cd ~/.local/share/'
alias bin='cd ~/.local/bin/'
alias con='cd ~/.config/'

function to {
	cd "$(directory_bookmarks get "$1")"
}
alias bm='directory_bookmarks add'
alias bmr='directory_bookmarks remove'
alias bml='directory_bookmarks list'
alias bmc='directory_bookmarks current'

alias cdp='cd - > /dev/null'

export _FASD_NOCASE=1
eval "$(fasd --init auto)"

function do_z () {
	command="fasd_cd -d"
	if [[ "$1" == "--choice" ]]; then
		command="fasd_cd -d -i"
		shift
	fi

	if [[ "$1" == ".." ]]; then
		last_dir="$(cat /tmp/fasd_last_dir)"
		pwd > /tmp/fasd_last_dir
		cd "$last_dir"
		return
	fi
	pwd > /tmp/fasd_last_dir
	$command "$1"
}

function qf {
	file="$(directory_bookmarks file get "$1")"
	[[ "$file" == "" ]] && return
	"${VISUAL:-${EDITOR}}" "$file"
}

alias qfa="directory_bookmarks file add"
alias qfr="directory_bookmarks file remove"
alias qfl="directory_bookmarks file list"

unalias z
unalias zz

alias z='do_z'
alias zz='do_z --choice'

unalias a
unalias s
unalias sd
unalias sf
unalias d
unalias f
