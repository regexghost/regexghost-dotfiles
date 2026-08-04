# regexghost's .kshrc file
# Hopefully in a coherent order

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Discipline function for relative present working directory
# by Martijn Dekker <martijn@inlv.org> 2020-08-09; public domain
function truncatedpwd
{
	v=$PWD keep=*/* # add /* for each element to keep
	[[ ($v == "$HOME" || $v == "$HOME"/*) && $HOME != / ]] && v=\~${v#"$HOME"} # Replace /home/<user> with "~"
	del=${v%/$keep}/
	[[ $v == /*/$keep ]] && v=.../${v#"$del"}
	[[ $v == \~/*/$keep ]] && v=.../${v#"$del"}
	echo $v
}

# Add my directory-bookmarks program to the prompt when relevant
PS1=' \[\033[1;35m\]'"\$(truncatedpwd)"'\[\033[1;34m\]$(directory-bookmarks current)\[\033[1;36m\] >\[\033[0m\] '

# Basic Aliases
alias grep='/usr/bin/grep -i --color=auto'
alias grepa='grep -i -I -A 5 -B 5 --color=auto'
alias gi='/usr/bin/grep -ir --color=auto'
alias diff='diff --color'
alias n='nano'
alias sq='ncdu' # Not sure why this is "sq" but I'm used to it now
alias b='bat --wrap word --theme=base16'
alias mv='mymv'
alias cp='cp -r -i'
alias cl='ln -s'
alias duf='duf -hide special'
alias rm='rm-trash'
alias nnn='files'
alias q='exit'
alias pve='pipe-viewer'
alias vp='vid-play'
alias vps='vid-play -s'

rss () {
	pgrep newsraft > /dev/null && echo "Newsraft already open" && return
	command cp "$XDG_DATA_HOME/newsraft/newsraft.sqlite3" "/tmp/newsraft.sqlite3"
	newsraft -d "/tmp/newsraft.sqlite3"
	command mv  "/tmp/newsraft.sqlite3" "$XDG_DATA_HOME/newsraft/newsraft.sqlite3"
}

# Aliases to Specific Commands

alias dud='du -s -h *'
alias buf='cat /proc/meminfo | grep --color=no -e Writeback -e Dirty'
alias x='chmod +x'
alias copy="sed 's/\n$//g' | xclip -selection c"
alias watchlc="watch 'ls | wc -l'"
alias watchdu="watch 'du -s -h *'"
alias watchbuf="watch 'cat /proc/meminfo | /usr/bin/grep --color=no -e Writeback -e Dirty'"
alias fatmount='sudo mount -o rw,users,umask=000' # Mount FAT formatted drive correctly
alias balance='aacgain -r -m 1 *.m4a'
alias reload='. ~/.kshrc'
alias pong='ping -c 2 -W 2'
alias wl='feh --bg-fill --no-fehbg ~/.config/regexghost/wallpaper.jpg'
alias capture-window='echo "Focus window to capture" && sleep 1 && id="$(xdotool getactivewindow)" && echo "Got id"  && sleep 1 && import -frame -window "$id"'
alias da='download-vids && download-pods'
alias sshr='ssh racknerd'
alias sshp='ssh piserver'
alias sshg='ssh gopherbox'
alias qv='~/.config/newsraft/queue-vid.sh'
alias trash-size='du -s -h ~/.local/share/Trash/files/ | cut -f 1'
alias sync='echo "Syncing"; sync; echo "Done"; lsblk'
alias man='MANWIDTH=$(($(stty size | cut -d " " -f 2)-20)) man'
alias dff='df -h | grep -e Filesystem -e "^/dev" | grep -v efi'
alias hltb='~/.local/share/regexghost/.venv/bin/python3 ~/.local/share/regexghost/terminal/howlongtobeat.py'
alias wttr='curl wttr.in'

web () {
	case "$1" in
		b*)
			~/Programs/websites/personal-website/scripts/build.sh
			;;
		p*)
			push-website /tmp/personal-website/build/
			;;
		*)
			echo "Usage: case [build|push]"
			;;
	esac
}

android () {
	case "$1" in
		m*)
			aft-mtp-mount ~/Downloads/USBDrive
			;;
		u*)
			fusermount -u ~/Downloads/USBDrive
			;;
		f*)
			fusermount -uz ~/Downloads/USBDrive
			;;
	esac
}

# Bug todo

alias bgl='bug ls'
alias bglc='bug ls | wc -l'
alias bgr='bug rm'
alias bgv='bug view'
alias bge='bug edit'
alias bga='bug add'

# Git Aliases

alias gd='git diff'
alias gdc='git diff --cached' # Show diff for things `git add`'ed
alias gdw='git diff --word-diff-regex=.'
alias gs='git status .'
alias gsa='git status'
alias gl='git log'
alias glc='echo "$(git rev-list --count HEAD) commits"'
alias ga='git add'
alias gc='git commit'

gpa () {
	git push -u origin
	git push -u codeberg
	git push -u mine
}

# Python venv

alias py='~/.local/share/regexghost/.venv/bin/python3'
alias pip='~/.local/share/regexghost/.venv/bin/pip'

#### Start Substitute - Package_Manager

# Other random aliases

alias as='echo "Use \as to run as command, disabled as too easy to type accidentally, creating unnecessary a.out file in home directory"'

## Functions to basic programs

# fzf -> editor
qfi () {
	file="$(find ~/* | grep -E '.py$|.go$|.txt$|.md$|.java$|.js$|.html$|.css$|.c$|.cc$|.conf$|.lua$|.rs$|.sh$|.bash$|.csv$' | sed 's|'"$HOME"'|~|g' | fzf)"
	[[ "$file" == "" ]] && return
	"${VISUAL:-${EDITOR:-vi}}" "$file"
}

alias v='vim -u ~/.config/vim/vimrc -i ~/.config/vim/viminfo'

lsblk () {
	if [[ "$1" == "-a" ]]; then
		/usr/bin/lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS
	else
		/usr/bin/lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
	fi
}

pkill () {
	command pkill "$@"
	[ "$?" == "0" ] || echo "Program not found"
}

trash-empty () {
	echo "Trash is $(trash-size)"
	/usr/bin/trash-empty
}

# Only use this if the history in the current terminal is suddenly way shorter than it should be
restorehistory () {
	if [ "$1" = "-o" ]; then
		cp "$HOME/Downloads/.history_backup" "$HOME/.history"
	else
		cat "$HOME/Downloads/.history_backup" "$HOME/.history" > /tmp/new_history
		mv /tmp/new_history "$HOME/.history"
	fi
}

alias cal='calendar'
alias t='date-time'

# External program openers

#### Start Substitute - Image_Viewer

#### Start Substitute - Video_Player

#### Start Substitute - PDF_Viewer

# Power Management Functions

#### Start Substitute - Power_Management

## Wrapper script
alias yt-dlp='ytdl-wrapper'

archiveplaylist () {
	if [[ "$1" == "-t" ]]; then
		ytdl-wrapper --firefox-cookies --json "$2" | jq '{title, videos: [.entries[] | {title, channel, id}]}' | yq -t
	else
		ytdl-wrapper --firefox-cookies --json "$1" | jq '.entries[] | [.title,.channel,.url]| @csv'
	fi
}

# Search commands

# History
alias hs="fc -l 0 100000 | sed 's/[^[:print:]\n	]//g'"
alias his='hs | grep'

## Search root directory
findr () {
	/usr/bin/find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

alias findh='find ~ -iname'
alias fig='find . | sort | grep'
alias psg='pgrep -a'

# Load my other aliases and functions

. "$HOME/.local/share/regexghost/terminal/ls_aliases.sh"
[ -f ~/Programs/localStuff/aliases.sh ] && . ~/Programs/localStuff/aliases.sh
[ -f ~/.profile ] && . ~/.profile

# Set variables

export HISTSIZE=200000
export HISTFILESIZE=200000
export HISTFILE="$HOME/.history"
export HISTCONTROL=ignoredups:erasedups

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

to () {
	cd "$(directory-bookmarks get "$1")"
}

alias bm='directory-bookmarks add'
alias bmr='directory-bookmarks remove'
alias bml='directory-bookmarks list'
alias bmc='directory-bookmarks current'

alias cdp='cd - > /dev/null'

alias cdr='cd ..'
alias cdrr='cd ../..'
alias cdrrr='cd ../../..'

blog () {
	if [ "$1" = "cd" ]; then
		cd "$(blog-devlog blog "cd")"
	else
		blog-devlog blog
	fi
}

alias devlog='blog-devlog devlog'

export _FASD_DATA="$XDG_CACHE_HOME/fasd"
export _FASD_NOCASE=1
fasd_cache="$XDG_CACHE_HOME/fasd-init"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
	echo "Caching fasd startup"
	fasd --init posix-alias posix-hook >| "$fasd_cache"
fi
. "$fasd_cache"
unset fasd_cache

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
	file="$(directory-bookmarks file get "$1")"
	[[ "$file" == "" ]] && return
	"${VISUAL:-${EDITOR}}" "$file"
}

alias qfa="directory-bookmarks file add"
alias qfr="directory-bookmarks file remove"
alias qfl="directory-bookmarks file list"

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
