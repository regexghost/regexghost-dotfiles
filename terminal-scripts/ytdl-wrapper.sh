#!/usr/bin/env bash

# yt-dlp wrapper script

aria_args=()
metadata_args=()
cookies_args=()
archive_args=()
other_args=()
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
		--json)
			other_args=("--flat-playlist" "--skip-download" "-J")
			shift
			;;
		--best)
			format_args=("-f" "bestvideo[protocol=https][vcodec*=avc]+bestaudio[ext=m4a]")
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

all_args=("${output_format_args[@]}" "${aria_args[@]}" "${metadata_args[@]}" "${cookies_args[@]}" "${format_args[@]}" "${archive_args[@]}" "${other_args[@]}" "$@")
~/.local/bin/yt-dlp "${all_args[@]}"
