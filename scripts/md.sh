#!/usr/bin/env bash

# md.sh: watch a MD file & build its HTML preview using commonmarker

catch_ctrl+c() {
    printf "\n%s" "Removing $1"
    rm "$1"
    exit
}

while true
do
    echo -en "\rWatching file $(tput bold)$1$(tput sgr0) ..."
    last_modify_time=$(date -d "@$(stat -c '%Y' "$1")" '+%T')
    sleep 0.1
    last_modify_time_2=$(date -d "@$(stat -c '%Y' "$1")" '+%T')

    html_preview="${1%.*}.html"

    if [[ "$last_modify_time" != "$last_modify_time_2" ]]; then
        echo -e "\nBuilding HTML preview ..."
        if commonmarker "$1" > "$html_preview"; then
            echo -e "Open: $(tput bold)file://$PWD/$html_preview$(tput sgr0)"
        else
            echo -e "commonmarker not found or some error occured"
        fi
    fi

    if [[ -f "$html_preview" ]]; then
        trap 'catch_ctrl+c $html_preview' SIGINT
    fi
done