#!/usr/bin/env bash

user_name="$1"
repo_name="$2"

latest_tag=$(curl -w "%{redirect_url}" https://github.com/${user_name}/${repo_name}/releases/latest/ | sed 's/.*\///g')

echo https://github.com/${user_name}/${repo_name}/archive/refs/tags/${latest_tag}.zip
