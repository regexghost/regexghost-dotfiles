# regexghost's .kshrc file
# Hopefully in a coherent order

PROMPT_COMMAND=
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load bash completion
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#	. /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#	. /etc/bash_completion
#  fi
#fi

#. /usr/share/bash-completion/completions/git

# Add my directory_bookmarks program to the prompt when relevant
PS1='\[\033[1;30m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;34m\]$(directory_bookmarks current)\[\033[1;31m\]\$\[\033[0m\] '

# Basic Aliases
alias grep='grep -i'
alias greps='/usr/bin/grep' # Case sensitive
alias grepa='grep -i -I -A 5 -B 5'
alias diff='diff --color'
alias hs='history'
alias n='nano'
alias ra='ranger'
alias py='python3'
alias nf='fastfetch'
alias sq='ncdu --color off' # Not sure why this is "sq" but I'm used to it now
alias bat='bat --wrap word --theme=base16'
alias mv='mymv'
alias cp='cp -r -i'
alias cmatrix='cmatrix -u 6' # Cool fake hacker program
alias duf='duf -hide special'
alias gtop='sudo intel_gpu_top'
alias wget='wget --hsts-file="$XDG_STATE_HOME/wget-hsts"'
alias rm='rm-trash'
alias cheat='cheat -c'
alias zbr='zig build run'
alias bluey='bluetui'
alias fontsreload='sudo fc-cache -fv'
alias trash-size='du ~/.local/share/Trash/files/ -s -h | cut -f 1'
alias sync='echo "Syncing"; sync; echo "Done"; lsblk'
alias alpine='alpine -p ~/.config/alpine/pinerc -passfile ~/.config/alpine/pine-passfile'
alias man='MANWIDTH=$(($(stty size | cut -d " " -f 2)-20)) man'

# Not POSIX compliant
grepc () {
	grep -oP ".{0,100}${1}.{0,100}"
}

nnn () {
	export NNN_FIFO=/tmp/nnn.fifo
	export NNN_PLUG=v:preview-tui
	tmux new-session -d -s mys "nnn -P v"
	tmux attach
}

rss () {
	command cp "$XDG_DATA_HOME/newsraft/newsraft.sqlite3" "/tmp/newsraft.sqlite3"
	newsraft -d "/tmp/newsraft.sqlite3"
	command mv  "/tmp/newsraft.sqlite3" "$XDG_DATA_HOME/newsraft/newsraft.sqlite3"
}

# Aliases to Specific Commands

alias x='chmod +x'
alias copy='tr -d "\n" | xclip -selection c'
alias batl='ls | sort | tail -n 1 | xargs bat --theme=base16'
alias watchlc="watch 'ls | wc -l'"
alias watchdu="watch 'du -s -h *'"
alias lastyear='log -d $(date -d "-1 year" +"%y%m%d")' # Interacts with my log program
alias fatmount='sudo mount -o rw,users,umask=000' # Mount FAT formatted drive correctly
alias rmedir='find . -type d -empty -delete'
alias balance='aacgain -r -m 1 *.m4a'
alias vol='pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -d "/" -f 2 | sed "s/ //g"'
alias clearlogs='sudo journalctl --vacuum-time=2d'
alias q='exit'
alias reload='. ~/.kshrc'
alias pong='ping -c 2 -W 2'
alias wp='feh --bg-fill --no-fehbg ~/.config/regexghost/wallpaper.jpg'
alias capture-window='echo "Focus window to capture" && sleep 1 && id="$(xdotool getactivewindow)" && echo "Got id"  && sleep 1 && import -frame -window "$id"'
alias da='download-vids && download-pods'

# Bug todo

alias bgl='bug ls'
alias bglc='bug ls | wc -l'
alias bgr='bug rm'
alias bgv='bug view'
alias bge='bug edit'
alias bga='bug add'

# Git Aliases

alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff-regex=.'
alias gs='git status .'
alias gsa='git status'
alias gpl='git pull'
alias gl='git log'
alias glc='echo $(git rev-list --count HEAD) commits'
alias giturl='git config --get remote.origin.url'
alias gp='git push'
alias ga='git add'
alias gc='git commit'

alias gitpass='keepassxc-cli show ~/Downloads/passwords.kdbx "GitHub" | grep Notes | cut -d " " -f 2 | xclip -selection clipboard'

gpa () {
	git push -u origin
	git push -u codeberg
	git push -u mine
}

#### Start Substitute - Package_Manager

# Other random aliases

alias as='echo "Use \as to run as command, disabled as too easy to type accidentally, creating unnecessary a.out file in home directory"'
alias todo='$VISUAL ~/Documents/todo.md'
alias durationr='media-file-duration . -r'
alias durationi='media-file-duration . -i'
alias kb='~/.local/share/regexghost/wm-scripts/keyboard-settings.sh'

## Functions to basic programs

# fzf -> editor
qfi () {
	file="$(find ~/* | grep -E '.py$|.go$|.txt$|.md$|.java$|.js$|.html$|.css$|.c$|.cc$|.conf$|.lua$|.rs$|.sh$|.bash$|.csv$' | sed 's|'"$HOME"'|~|g' | fzf --bind 'ctrl-backspace:backward-kill-word' --bind 'ctrl-delete:kill-word' --bind 'ctrl-right:forward-word' --bind 'ctrl-left:backward-word')"
	[[ "$file" == "" ]] && return
	$VISUAL "$file"
}

alias m='micro -clipboard terminal'
alias v='vim -u ~/.config/vim/vimrc -i ~/.config/vim/viminfo'

batf () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	bat --theme=base16 "$result"
}

lsblk () {
	if [[ "$1" == "-a" ]]; then
		/usr/bin/lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS
	else
		/usr/bin/lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
	fi
}

do_pkill () {
	pkill "$@"
	[ "$?" == "0" ] || echo "Program not found"
}

alias pkill='do_pkill'

storage () {
	root_line=$(df -h | grep ' /$' | tr -s " ")
	used=$(echo "$root_line" | cut -d " " -f 3)
	free=$(echo "$root_line" | cut -d " " -f 4)
	echo "Used: ${used}"
	echo "Free: ${free}"
}

trash-empty () {
	echo "Trash is $(trash-size)"
	/usr/bin/trash-empty
}

# Only use this if the history in the current terminal is suddenly way shorter than it should be
restorehistory () {
	history | sed 's/^[ ]*[0-9]*[ ]*//g' > /tmp/new_history
	cat "$HOME/Downloads/.history_backup" /tmp/new_history > /tmp/all_history
	mv /tmp/all_history "$HOME/.history"
}

cal () {
	MAGENTA_COLOUR='\033[0;35m\033[1m'
	RED_COLOUR='\033[0;34m\033[1m'
	BLUE_COLOUR='\033[0;36m\033[1m'
	RESET_COLOUR='\033[0m'

	suffix () {
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

pyweb () {
	$(sleep 0.5 && firefox "http://0.0.0.0:8000/") &
	python3 -m http.server -d "$1"
}

## Function to show time in various locations
t () {
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

## Wrapper script
alias yt-dlp='ytdl-wrapper'

yt-playlist () {
	quality_option="--720p"
	if [[ "$1" == "--1080p" ]]; then
		quality_option="--1080p"
		shift
	fi
	ytdl-wrapper --playlist-order --all-metadata --firefox-cookies --aria --archive "$quality_option" "$@"
}

archivevideo () {
	for url in "$@"; do
		yt-dlp --cookies-from-browser firefox -o "%(title)s.%(ext)s" --embed-chapters --embed-thumbnail --embed-metadata -f "bestvideo[protocol=https][vcodec*=avc]+bestaudio[ext=m4a]" "$url"
	done
}

archiveplaylist () {
	if [[ "$1" == "-t" ]]; then
		yt-dlp --cookies-from-browser firefox --flat-playlist --skip-download -J "$2" | jq '{title, videos: [.entries[] | {title, channel, id}]}' | yq -t
	else
		yt-dlp --cookies-from-browser firefox -J --flat-playlist "$1" | jq '.entries[] | [.title,.channel,.url]| @csv'
	fi
}

alias queue-vid='~/.config/newsraft/queue-vid.sh'

# Search commands

alias hs='nl ~/.history'
alias his='nl ~/.history | grep'

## Search root directory
findr () {
	find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

alias findh='find ~ -iname'
alias fig='find . | sort | grep'
alias psg='ps -aux | grep'

alias edit-bookmarks='${VISUAL:${EDITOR:-vi}} ~/.local/share/regexghost/script-data/bookmarks.txt'

# Load my other aliases and functions

#. "$HOME/.local/share/regexghost/terminal/autocompletion.sh"
. "$HOME/.local/share/regexghost/terminal/ls_aliases.sh"
[ -f ~/Programs/localStuff/aliases.sh ] && . ~/Programs/localStuff/aliases.sh
[ -f ~/.profile ] && . ~/.profile

# Set variables

export HISTSIZE=80000
export HISTFILESIZE=80000
export HISTFILE="$HOME/.history"

export HISTCONTROL=ignoredups:erasedups
export MICRO_TRUECOLOR=1
export PASSWORD_STORE_CLIP_TIME=120

#set +o emacs

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

blog () {
	dir="$HOME/Programs/websites/personal-website/blog/$(date +%Y/%B | awk '{print tolower($0)}')"
	[ -d "$dir" ] && cd "$dir" || mkdir -p "$dir" && cd "$dir"
}

to () {
	cd "$(directory_bookmarks get "$1")"
}

alias bm='directory_bookmarks add'
alias bmr='directory_bookmarks remove'
alias bml='directory_bookmarks list'
alias bmc='directory_bookmarks current'

alias cdp='cd - > /dev/null'

alias cdr='cd ..'
alias cdrr='cd ../..'
alias cdrrr='cd ../../..'

export _FASD_DATA="$XDG_CACHE_HOME/fasd"
export _FASD_NOCASE=1
fasd_cache="$XDG_CACHE_HOME/fasd-init"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
	echo "Caching fasd startup"
	fasd --init posix-alias posix-hook >| "$fasd_cache"
fi
. "$fasd_cache"
unset fasd_cache

#eval "$(fasd --init auto)"

do_z () {
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

qf () {
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
