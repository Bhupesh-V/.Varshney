#!/usr/bin/env bash

# Smart cd
scd() {
    if [[ $1 != "" ]]; then
        while read -r value; do
            paths+=($value)
        done < <( locate -r "/$1$" | grep "$HOME" )

        for result in "${paths[@]}"
        do
            if [[ -d $result ]]; then
                printf "%s\n" "Hit: $result"
                cd "$result" || exit
            fi
        done
    else
        cd "$HOME" || exit
    fi
}

# Encode string to URL
urlencode() {
    local string="${1}"
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<${#string} ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] )
                # these characters are url safe (permitted)
                o="${c}" ;;
        * )     
            # Encode special characters
            # Assign output to o, instead of printing to console
            # %02x converts the character into hexadecimal notation.
            printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
    done
    # return "encoded"
    echo "${encoded}" 
}

search() {
    # Browsers :
    # chromium-browser <url>
    # firefox --new-tab <url>
    #
    # Search Engines :
    # Google: https://www.google.com/search?q=<string to search>
    # DuckDuckGo: https://duckduckgo.com/?q=<search_term>
    # DuckDuckGo Lite: https://lite.duckduckgo.com/lite/?q=<search_term>
    # GitHub: https://github.com/search?q=<string to search>&ref=opensearch

    printf "%s" "Using search engine $(tput bold)DuckDuckGo.com$(tput sgr0)"
    printf "\n%s" "Search Query : " 
    read search_term

    printf "[F]irefox or [C]hromium ? : "
    read -n 1 BROWSER_CHOICE
    BROWSER_CHOICE=${BROWSER_CHOICE:-c}
    case $BROWSER_CHOICE in
      [f/F]* ) firefox --new-tab "duckduckgo.com/?q=$(urlencode "${search_term}")";;
      [c/C]* ) chromium-browser "duckduckgo.com/?q=$(urlencode "${search_term}")";;
      * )     printf "\n%s\n" "[❌]Invalid Input 🙄, Try Again";;
    esac
}
