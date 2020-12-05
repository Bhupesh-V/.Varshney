#!/usr/bin/env bash

# md.sh: watch a MD file & build its HTML preview using commonmarker

catch_ctrl+c() {
	printf "\n%s" "Removing $1"
  rm "$1"
	exit
}

build_preview() {
	echo -e "\nBuilding HTML preview ..."
	if commonmarker "$1" >"$html_preview"; then
		echo -e "Preview at: $(tput bold)file://$PWD/$html_preview$(tput sgr0)"
	else
		echo -e "commonmarker not found or some error occured"
	fi
}

watch_changes() {
	while true; do
		echo -en "\rWatching file $(tput bold)$1$(tput sgr0) ..."
		last_modify_time=$(date -d "@$(stat -c '%Y' "$1")" '+%T')
		sleep 0.1
    last_modify_time_2=$(date -d "@$(stat -c '%Y' "$1")" '+%T')

		[[ "$last_modify_time" != "$last_modify_time_2" ]] && build_preview "$1"

		[[ -f "$html_preview" ]] && trap 'catch_ctrl+c $html_preview' SIGINT
	done
}

if [[ -z "$1" ]]; then
  echo -e "md requires a .md file"
  exit 1
else
	html_preview="${1%.*}.html"
	build_preview "$1"
	echo -e "Opening preview in browser ..."
	# alternative is to directly invoke browser
	xdg-open "file://$PWD/$html_preview" &>/dev/null
	watch_changes "$1"
fi
