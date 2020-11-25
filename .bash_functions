wib() {
	# words in blog
	# determine total words in my blog
	blog_dir="$HOME"/Desktop/Bhupesh-V.github.io/
	printf "Total Blogs: %s" "$(ls "$blog_dir"/_posts/ | wc -l)"
	printf "\n%s" "Total Words: "
	grep -nir -o -P '.{0,5} totalwords' --exclude-dir=tag --exclude "feed.xml" "$blog_dir/"_site | awk '{print $2}' | awk '{s+=$0} END {print s}'
}

gdl() {
	# Get actual drive public link
	# Read More: bhupesh-v.github.io/extract-file-id-from-drive-shareable-link/
	str="$1"
	# remove everything after the last /
	remove_last=${str%/*}
	# get everything after the last /
	get_last=${remove_last##*/}
	echo "https://drive.google.com/uc?export=view&id=$get_last"
}

alarm() {
	# Set an alarm
	#
	# Usage: alarm 10 drink-water (for minutes use 'm' e.g alarm 15m "go piss")
	#
	# set +m disables monitor mode for bg jobs. Another way to deactivate it: set +o monitor
	# Use 'help set' to see more options

	set +m
	(
		sleep "$1"
		notify-send -a "CLI Alarm" -u critical -i time "$2" "Alarm Notification Alert"
	) &
}


vcd() {
	# [v]irtual [cd] automatically activates/deactivates python virtual environments on cd
	#
	# WARNING: vcd right now only works for following python project setup
	#
	# virtual-env-folder
	# ├── bin
	# ├── include
	# ├── lib
	# └── your-project-folder-or-repo
	#     ├── .git
	#     └── .. other files/folders ..

	userpath=$1

	# deactivate any existing virtual env
	[[ $VIRTUAL_ENV ]] && deactivate

	if [[ $userpath != "" ]]; then
		case $1 in
		"..") cd .. && return ;;
		"-") cd - && return ;;
		"/") cd / && return ;;
		*) cd "$userpath" || return ;;
		esac
		current_dir=$(pwd)
		while [[ "$current_dir" != "$HOME" ]]; do
			# check if current dir contains an activate script (the venv folder)
			if [[ -f "$current_dir/bin/activate" ]]; then
				source "$current_dir/bin/activate"
				break
			fi
			# remove base directory name
			current_dir="${current_dir%/*}"
		done
	fi

}

scd() {
	# [s]mart [cd] : find absolute paths & automatically switch to them
	# Also see scd-completions.bash for automatic tab suggestions

	if [[ "$1" ]]; then
		case $1 in
		"..") cd .. || return ;;
		"-") cd - || return ;;
		"/") cd / || return ;;
		*) if [[ $1 = /* ]]; then
			# match absolute path
			cd "$1" || return
		else
			# redo work if tab suggestions are not used
			while read -r value; do
				files+=($value)
			done < <(locate -e -r "/$1$" | grep "$HOME")
			if [[ ${#files} == 0 ]]; then
				# do loose search
				while read -r value; do
					files+=($value)
				done < <(locate -e -b -r "$1" | grep "$HOME")
			fi
			for file_match in "${files[@]}"; do
				if [[ -d $file_match ]]; then
					printf "%s\n" "Hit 🎯: $file_match"
					cd "$file_match" || return
				fi
			done
			unset files
		fi ;;
		esac
	else
		cd ~ || return
	fi
	# why tf is this not working
	# [[ -z "$1" ]] && cd "$HOME" || exit
}

urlencode() {
	# Encode string to URL safe version

	local string="${1}"
	local encoded=""
	local pos c o

	for ((pos = 0; pos < ${#string}; pos++)); do
		c=${string:$pos:1}
		case "$c" in
		[-_.~a-zA-Z0-9])
			# these characters are url safe (permitted)
			o="${c}"
			;;
		*)
			# Encode special characters
			# Assign output to o, instead of printing to console
			# %02x converts the character into hexadecimal notation.
			printf -v o '%%%02x' "'$c"
			;;
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
	[f/F]*) firefox --new-tab "duckduckgo.com/?q=$(urlencode "${search_term}")" ;;
	[c/C]*) chromium-browser "duckduckgo.com/?q=$(urlencode "${search_term}")" ;;
	*) printf "\n%s\n" "[❌]Invalid Input 🙄, Try Again" ;;
	esac
}

netu() {
	# [net]work [u]sage: check network usage stats

	net_device=$(ip route | awk '/via/ {print $5}')
	TRANSMITTED=$(ifconfig "$net_device" | awk '/TX packets/ {print $6$7}')
	RECEIVED=$(ifconfig "$net_device" | awk '/RX packets/ {print $6$7}')

	pc_uptime=$(uptime -p | awk '{for (i=2; i<NF; i++) printf $i " "; if (NF >= 1) print $NF; }')
	printf "%s\n\n" "Network Usage since $pc_uptime"
	printf "%s\n" "$(tput bold)🔼 TRANSMITTED $(tput sgr0): $TRANSMITTED"
	printf "%s\n" "$(tput bold)🔽 RECEIVED    $(tput sgr0): $RECEIVED"
}

extract() {
	# Extract different archives
	# FROM: https://tldp.org/LDP/abs/html/sample-bashrc.html

	if [ -f "$1" ]; then
		case "$1" in
		*.tar.bz2) tar xvjf "$1"  ;;
		*.tar.gz) tar xvzf "$1"  ;;
		*.tgz) tar xvzf "$1" ;;
		*.tar) tar xvf "$1"  ;;
		*.zip) unzip "$1" ;;
		*) echo "'$1' is not a valid archive file!" ;;
		esac
	else
		echo "extract requires a filepath"
	fi
}

myip() {
	# Show my IP
	echo -e "$(ip route | awk '/via/ {print $3}')"
}

perm() {
	# Show file permissions
	ls -l "$1" | awk '{ print $1}'
}

hg() {
	# [h]istory [g]rep searches history for patterns (unique commands)
	if [[ "$1" ]]; then
		# cut uses ' ' as a delimiter & prints everything from
		# the 3 field to the end of line
		history | grep "$1" --color=always | cut -d' ' -f3- | uniq -u
	else
		echo -e "hg needs a pattern to look for"
	fi
}

eye() {
	# custom file viewer
	filename=$(basename -- "$1")
	extension="${filename##*.}"
	if [[ $extension == "md" ]]; then
		glow "$1"
	elif [[ $extension == "json" ]]; then
		python3 -m json.tool "$1"
	else
		less "$1"
	fi
}

cb() {
	# copy stuff from terminal to clipboard
	# TODO: way to handle -a

	# clear the cliboard
	xsel -bc

	# add to clipboard
	xsel -b <"$1"
}

h() {
	# Combined help lookup
	#
	# man -k == apropos
	# man -f == whatis
	if [[ -z "$1" ]]; then
		echo "h needs an argument to look 👀"
	else
		type "$1"
		whereis "$1"
		whatis "$1"
		apropos "$1"
	fi
}
