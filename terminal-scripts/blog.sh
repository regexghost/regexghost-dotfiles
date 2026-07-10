#!/bin/sh

blog () {
	dir="$HOME/Programs/websites/personal-website/blog/$(date +%Y/%B | awk '{print tolower($0)}')"
	[ -d "$dir" ] || mkdir -p "$dir"
	month_num="$(date "+%m")"
	year="$(date "+%Y")"
	date="$(date "+%d")"
	read -p "Enter filename: " filename
	read -p "Enter title: " title
	if ! echo "$filename" | grep -q ".md$"; then
		filename="${filename}.md"
	fi
	echo "+++" >> "$filename"
	echo "title = \"${title}\"" >> "$filename"
	echo "datePublished = ${year}-${month_num}-${date}" >> "$filename"
	echo "template = \"blog-page.html\"" >> "$filename"
	echo "+++" >> "$filename"
	"${VISUAL:-${EDITOR:-vi}}" "$filename"
}

devlog () {
	month_num="$(date "+%m")"
	month_name="$(date "+%B")"
	year="$(date "+%Y")"
	date="$(date "+%d")"
	filename="$HOME/Programs/websites/personal-website/devlog/${year}-${month_num}-${month_name}.md"

	if [ -f "$filename" ]; then
		"${VISUAL:-${EDITOR:-vi}}" "$filename"
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
		blog
		;;
	d*)
		devlog
		;;
esac
