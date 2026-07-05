#!/usr/bin/env bash

site="$1"
user_name="$2"
repo_name="$3"

if [[ "$site" == "github" ]] || [[ "$site" == "gh" ]]; then
	latest_tag=$(curl -w "%{redirect_url}" https://github.com/${user_name}/${repo_name}/releases/latest/ | sed 's/.*\///g')
	echo https://github.com/${user_name}/${repo_name}/archive/refs/tags/${latest_tag}.zip
elif [[ "$site" == "codeberg" ]] || [[ "$site" == "cb" ]]; then
	latest_tag=$(curl -w "%{redirect_url}" https://codeberg.org/${user_name}/${repo_name}/releases/latest/ | sed -nE 's/.*tag\/([^"]*)">.*/\1/p')
	echo https://codeberg.org/${user_name}/${repo_name}/archive/${latest_tag}.zip
fi
