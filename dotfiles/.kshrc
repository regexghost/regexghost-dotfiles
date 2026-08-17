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
alias grep='/usr/bin/grep -i --color=auto' # standard grep
alias grepa='grep -i -I -A 5 -B 5 --color=auto' # grep surrounding lines
alias gi='/usr/bin/grep -ir --color=auto' # recursive grep
alias diff='diff --color'
alias n='nano'
alias sq='ncdu --disable-delete --disable-shell' # not sure why this is "sq" but I'm used to it now
alias b='bat --wrap word --theme=base16'
alias mv='mymv' # sbase mv doesn't have -i option
alias cp='cp -r -i'
alias cl='ln -s'
alias duf='duf -hide special' # removes /tmp and /run stuff
alias rm='rm-trash'
alias nnn='files'
alias q='exit'
alias pve='pipe-viewer'
alias vp='vid-play' # normal vids
alias vps='vid-play -s' # shorts
alias pd='podcast-play' # podcasts

# I originally used this on the Pi, because the storage being slow meant newsraft
# lagged when accessing the database
rss () {
	pgrep newsraft > /dev/null && echo "Newsraft already open" && return
	command cp "$XDG_DATA_HOME/newsraft/newsraft.sqlite3" "/tmp/newsraft.sqlite3"
	newsraft -d "/tmp/newsraft.sqlite3"
	command mv  "/tmp/newsraft.sqlite3" "$XDG_DATA_HOME/newsraft/newsraft.sqlite3"
}

# Aliases to Specific Commands

alias dud='du -s -h *' # file/dir sizes in current directory
alias buf='cat /proc/meminfo | grep --color=no -e Writeback -e Dirty' # data waiting to be written to disk
alias x='chmod +x'
alias copy="sed 's/\n$//g' | xclip -selection c"
alias watchlc="watch 'ls | wc -l'" # for monitoring progress of file copy
alias watchdu="watch 'du -s -h *'" # similar to above
alias watchbuf="watch 'cat /proc/meminfo | /usr/bin/grep --color=no -e Writeback -e Dirty'" # for monitoring sync/umount
alias fatmount='sudo mount -o rw,users,umask=000' # mount FAT formatted drive correctly
alias balance='aacgain -r -m 1 *.m4a'
alias reload='. ~/.kshrc'
alias pong='ping -c 2 -W 2'
alias wl='feh --bg-fill --no-fehbg ~/.config/regexghost/wallpaper.jpg'
alias capture-window='echo "Focus window to capture" && sleep 1 && id="$(xdotool getactivewindow)" && echo "Got id"  && sleep 1 && import -frame -window "$id"'
alias da='download-vids; download-pods'
alias qv='~/.config/newsraft/queue-vid.sh'
alias trash-size='du -s -h ~/.local/share/Trash/files/ | cut -f 1'
alias sync='echo "Syncing"; sync; echo "Done"; lsblk'
alias man='MANWIDTH=$(($(stty size | cut -d " " -f 2)-20)) man' # fixs a bug with word wrapping in bat by limiting man size
alias dff='df -h | grep -e Filesystem -e "^/dev" -e "$HOME" | grep -v efi' # show size of proper filesystems
alias hltb='~/.local/share/regexghost/.venv/bin/python3 ~/.local/share/regexghost/terminal/howlongtobeat.py'
alias wttr='curl wttr.in'
alias im='iphone-mount'

# Build and deploy my main website
web () {
	case "$1" in
		b*)
			~/Programs/websites/personal-website/scripts/build.sh
			;;
		p*)
			push-website /tmp/personal-website/build/
			;;
		f*)
			~/Programs/websites/personal-website/scripts/build.sh
			push-website /tmp/personal-website/build/
			;;
		*)
			echo "Usage: case [build|push]"
			;;
	esac
}

# Mount android phone/tablet
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
alias gdc='git diff --cached' # show diff for things `git add`'ed
alias gdw='git diff --word-diff-regex=.'
alias gs='git status .' # only show files in current dir
alias gsa='git status' # status for whole git repo
alias gl='git log'
alias glc='echo "$(git rev-list --count HEAD) commits"'
alias ga='git add'
alias gc='git commit'

# Push to GitHub, Codeberg and my website/server
gpa () {
	git push -u origin
	git push -u codeberg
	git push -u mine
}

# Python venv

alias py='~/.local/share/regexghost/.venv/bin/python3'
alias pip='~/.local/share/regexghost/.venv/bin/pip'

#### Start Substitute - Package_Manager

alias as='echo "Use \\\as to run as command, disabled as too easy to type accidentally, creating unnecessary a.out file in home directory"'

# fzf -> cd
qcd () {
	dir="$(find "$HOME/Documents" "$HOME/Downloads" "$HOME/Music" "$HOME/Pictures" "$HOME/Programs" "$HOME/Videos" "$HOME/Work" "$HOME/.local/share/regexghost" -type d | fzf)"
	[ "dir" = "" ] && return
	cd "$dir"
}

## Functions to basic programs

# fzf -> editor
qfi () {
	# Only look for file types you might actually want to manually edit
	file="$(find ~/* | grep -E '.py$|.go$|.txt$|.md$|.java$|.js$|.html$|.css$|.c$|.cc$|.conf$|.lua$|.rs$|.sh$|.bash$|.csv$' | sed 's|'"$HOME"'|~|g' | fzf)"
	[ "$file" = "" ] && return
	"${VISUAL:-${EDITOR:-vi}}" "$file"
}

# Moving config out of ~/
alias vim='vim -u ~/.config/vim/vimrc -i ~/.config/vim/viminfo'
alias vi='vim'
alias v='vim'

# By default only show broadly useful info
lsblk () {
	if [[ "$1" == "-a" ]]; then
		/usr/bin/lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS
	else
		/usr/bin/lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
	fi
}

# Feedback for pkill
pkill () {
	command pkill "$@"
	[ "$?" == "0" ] || echo "Program not found/killed"
}

# Show trash size before empty
trash-empty () {
	echo "Trash is $(trash-size)"
	/usr/bin/trash-empty
}

# Aliases to scripts, calendar info and time zone display
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

# toml or csv
archiveplaylist () {
	if [[ "$1" == "-t" ]]; then
		ytdl-wrapper --firefox-cookies --json "$2" | jq '{title, videos: [.entries[] | {title, channel, id}]}' | yq -t
	else
		ytdl-wrapper --firefox-cookies --json "$1" | jq '.entries[] | [.title,.channel,.url]| @csv'
	fi
}

# Search commands

# History - run through filter to get rid of escape sequences, otherwise it messes up terminal
alias hs="fc -l 0 100000 | sed 's/[^[:print:]\n	]//g'"
alias his='hs | grep'

## Search root directory
findr () {
	/usr/bin/find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

alias findh='find ~ -iname' # search home
alias fig='find . | sort | grep' # search current dir
alias psg='pgrep -a' # search processes

# Load my other aliases and functions

. "$HOME/.local/share/regexghost/terminal/ls_aliases.sh"
[ -f ~/Programs/localStuff/aliases.sh ] && . ~/Programs/localStuff/aliases.sh
[ -f ~/.profile ] && . ~/.profile # ~/.profile should be loaded at login, but load it again here so any changes take place immediately

# Set variables

export HISTSIZE=200000
export HISTFILESIZE=200000
export HISTFILE="$HOME/.history"
export HISTCONTROL=ignoredups:erasedups

export MICRO_TRUECOLOR=1 # micro proper colourschemes
export PASSWORD_STORE_CLIP_TIME=120 # keep passwords in clipboard for longer (for "pass" cli password manager)

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

# cd to directories using my bookmarking program
to () {
	cd "$(directory-bookmarks get "$1")"
}

alias bm='directory-bookmarks add'
alias bmr='directory-bookmarks remove'
alias bml='directory-bookmarks list'
alias bmc='directory-bookmarks current'

# Hide output on cd -
alias cdp='cd - > /dev/null'

# Quickly go up X dirs
alias cdr='cd ..'
alias cdrr='cd ../..'
alias cdrrr='cd ../../..'

# Wrapper function for my blog post script
blog () {
	if [ "$1" = "cd" ]; then
		cd "$(blog-devlog blog "cd")"
	else
		blog-devlog blog
	fi
}

alias devlog='blog-devlog devlog' # devlog in blog script

export _FASD_DATA="$XDG_CACHE_HOME/fasd" # move out of ~/
export _FASD_NOCASE=1 # case insensitive
fasd_cache="$XDG_CACHE_HOME/fasd-init" # move out of ~
# Cache startup to speed up terminal load time
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
	echo "Caching fasd startup"
	fasd --init posix-alias posix-hook >| "$fasd_cache"
fi
. "$fasd_cache"
unset fasd_cache

# Wrapper function, allows going back to previous dir
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

# Open bookmarked file in editor
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

# Remove unused fasd aliases
unalias a
unalias s
unalias sd
unalias sf
unalias d
unalias f
