scd() {
    # [s]mart cd : find absolute paths & automatically switch to them

    if [[ $1 != "" ]]; then
        case $1 in
            [".."]* ) cd .. || exit;;
            ["-"]* ) cd -  || exit;;
            ["/"]* ) cd /  || exit;;
            * ) while read -r value; do
					files+=($value)
                done < <( locate -e -r "/$1$" | grep "$HOME" )
                if [[ ${#files} == 0 ]]; then
                	# do loose search
                	while read -r value; do
						files+=($value)
                	done < <( locate -e -r "$1" | grep "$HOME" )
	            fi
                for file_match in "${files[@]}"; do
           			if [[ -d $file_match ]]; then
           				printf "%s\n" "Hit 🎯: $file_match"
                		cd "$file_match" || exit
           			fi
           		done ;;
        esac
    else
        cd "$HOME" || exit
    fi
}

urlencode() {
    # Encode string to URL safe version

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
    # Invoke browser directly with search strings
    #
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

netu() {
    # [net]work [u]sage: check network usage stats

    net_device=$(route | awk '/default/ {print $8}')
    TRANSMITTED=$(ifconfig "$net_device" | awk '/TX packets/ {print $6$7}')
    RECEIVED=$(ifconfig "$net_device" | awk '/RX packets/ {print $6$7}')

    pc_uptime=$(uptime -p | awk '{for (i=2; i<NF; i++) printf $i " "; if (NF >= 1) print $NF; }')
    printf "%s\n\n" "Network Usage since $pc_uptime"
    printf "%s\n" "$(tput bold)🔼 TRANSMITTED $(tput sgr0): $TRANSMITTED"
    printf "%s\n" "$(tput bold)🔽 RECEIVED    $(tput sgr0): $RECEIVED"
}

