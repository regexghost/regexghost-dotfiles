#!/bin/sh

# Helper scripts for my blog and devlog

blog () {
	# Get dir, make if doesn't exist
	dir="$HOME/Programs/websites/personal-website/blog/$(date +%Y/%B | awk '{print tolower($0)}')"
	[ -d "$dir" ] || mkdir -p "$dir"
	# If cd argument given just echo the dir and exit (a function in shell rc picks this up and does the actual cd)
	[ "$1" = "cd" ] && echo "$dir" && exit

	# Get date in proper format
	month_num="$(date "+%m")"
	year="$(date "+%Y")"
	date="$(date "+%d")"
	# Prompt for filename and title
	read -p "Enter filename: " filename
	read -p "Enter title: " title
	if ! echo "$filename" | grep -q ".md$"; then
		filename="${filename}.md"
	fi
	# Add header to document and open
	fullpath="${dir}/${filename}"
	echo "+++" >> "$fullpath"
	echo "title = \"${title}\"" >> "$fullpath"
	echo "datePublished = ${year}-${month_num}-${date}" >> "$fullpath"
	echo "template = \"blog-page.html\"" >> "$fullpath"
	echo "+++" >> "$fullpath"
	"${VISUAL:-${EDITOR:-vi}}" "$fullpath"
}

devlog () {
	# Get date and form filename
	month_num="$(date "+%m")"
	month_name="$(date "+%B")"
	year="$(date "+%Y")"
	date="$(date "+%d")"
	filename="$HOME/Programs/websites/personal-website/devlog/${year}-${month_num}-${month_name}.md"

	# If the file exists, just open it
	if [ -f "$filename" ]; then
		"${VISUAL:-${EDITOR:-vi}}" "$filename"
	# Otherwise make and add header
	else
		echo "+++" >> "$filename"
		echo "title = \"${month_name} ${year} Devlog\"" >> "$filename"
		echo "datePublished = ${year}-${month_num}-${date}" >> "$filename"
		echo "template = \"blog-page.html\"" >> "$filename"
		echo "+++" >> "$filename"
		"${VISUAL:-${EDITOR:-vi}}" "$filename"
	fi
}

case "$1" in
	b*)
		blog "$2"
		;;
	d*)
		devlog
		;;
esac
