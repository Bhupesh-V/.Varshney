#!/usr/bin/env bash

wib() {
    # words in blog
    # determine total words in my blog
    blog_dir="$HOME"/Desktop/Bhupesh-V.github.io/
    printf "Total Blogs: %s" "$(ls "$blog_dir"/_posts/ | wc -l)"
    printf "\n%s" "Total Words: "
    words_blogs=$(grep -nir -o -P '.{0,5} totalwords' --exclude-dir=tag --exclude "feed.xml" "$blog_dir/"_site | awk '{print $2}' | awk '{s+=$0} END {print s}')
    echo $words_blogs
    til_data=("CleanCode" "Python" "Shell" "Go" "WebDev" "Miscellaneous")

    for dir in ${til_data[@]}; do
        files=$(ls "$HOME/Documents/til/$dir")
        for til in ${files[@]}; do
            words=$(wc -w "$HOME/Documents/til/$dir/$til" | awk '{print $1}')
            let total_words+=$words
            # printf "%s%s\n" "words = ${words}, total = ${total_words}"
        done
    done
    printf "\n%s\n" "Total TILs: $(awk '/count/ {print $2}' Documents/til/count.json)"
    printf "%s" "Total Words: ${total_words}"
    printf "\n\n%s" "Grand Total: $((total_words + words_blogs))"

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

# gcd() {
# cd "$1" || return
 
# default_branch=$(git remote show origin | awk '/HEAD/ {print $3}')

# remote_commit=$(git ls-remote --head --exit-code origin "$default_branch" | cut -f 1 | head -1)
# local_commit=$(git --no-pager log --pretty=tformat:"%H" -1)

# if [[ $remote_commit != $local_commit ]]; then
# printf "%s\n" "Your repository seems to be out of sync with remote"
# printf "%s\n" "Please take a git pull"
        # fi
        # }

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
    # [h]istory [g]rep searches history for unique commands
    if [[ "$1" ]]; then
        # cut uses ' ' as a delimiter & prints everything from
        # the 3 field to the end of line
        history | grep "$1" --color=always | cut -c 8- | uniq -u
        # Other variations:
        # history | grep "$1" --color=always | cut -d' ' -f3- | uniq -u
    else
        echo -e "hg needs a pattern to look for"
    fi
}

eye() {
    # custom text file viewer
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    if [[ $extension == "md" ]]; then
        glow -w "$COLUMNS" "$1"
    elif [[ $extension == "json" ]]; then
        python3 -m json.tool "$1"
    elif [[ $(file --mime "$1" | awk '{print $3}') == "video/mp4;" ]]; then
        browse "$1"
    else
        batcat "$1"
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

hl () { 
    # FROM: http://www.wassen.net/highlight-output.html
    # Use: tail file.txt | hl word-to-highlight
    if [[ $1 = '-i' ]]; then
        ARGS='--ignore-case'
        shift
    fi
    egrep $ARGS --color=always -e '' $(echo $* | xargs -n1 printf "-e%s "); 
}

fino() {
    # get data if piped
    declare filepath=${1:-$(</dev/stdin)};
    if [[ -f "$filepath" ]]; then
        echo -e "$(basename "$filepath")"
        info=$(file "$filepath" | awk -F ":" '{print $2}')
        echo -e "$info"
        ls -alh "$filepath" | awk '{print $1 "\nSize: " $5 "\nLast Modify: " $6 " " $7 " " $8}'
    fi
    # printf "Created: %s" "$(sudo debugfs -R "stat <$(ls -i "$1" | awk '{ print $1}')>" /dev/sda1 | grep 'crtime')"
}
export -f fino

lk() {
    grep -wnirI --color=always --exclude='*.gitignore' --exclude-dir={_site,.git,.github} "$@" | awk '{$1=$1};1' | awk -f ~/Documents/.Varshney/scripts/pretty-grep.awk
}

fcd() {
    cd "$(xfi | fzf --cycle --preview "[[ -d {} ]] && tree -C {} || head -200" --height 40% --reverse)"
    # cd "$(find ~ -maxdepth 5 -not -path '*/\.git/*' -type d | fzf --preview 'tree -C {} | head -200' --height 40% --reverse)"
}

todo() {
    if [[ $# -gt 1 ]]; then
        local key="$1"
        case "$key" in
            --remove|-r)
                grep -v -- "$2" ~/todo.md > tmpfile && mv tmpfile ~/todo.md
                ;;
            *)
                printf "%s\n" "ERROR: Unrecognized argument $key"
                exit 1
                ;;
        esac

    elif [[ -z "$1" ]]; then
        cat ~/todo.md 
    else
        xargs -I TODO  echo "- [ ] TODO" >> ~/todo.md <<< "$1"
    fi
}


epoch() {
    # script to ouput current unix epoch and convert to readable datetime

    # TODO: check if gdate is available on Mac if not use date
    # case "$(uname)" in
    # Linux ) echo "on Linux" ;;
    # Darwin ) echo "on Mac" ;;
    # esac
    case "$1" in
        now)
            date +'%s'
            [ $(uname) == "Darwin" ] && date -r $(date -u +%s) || date --date="@$(date -u +%s)" ;;
        later)
            # e.g epoch later "10 days"
            [ -z "$2" ] && echo "argument missing, 'epoch later <modifier>'" && return
            date -d "$2"
            date -u +%s -d "$2";;
        *)
            [ -z $1 ] && echo "argument missing, 'epoch <unix-timestamp>'" && return
            [ $(uname) == "Darwin" ] && date -r "$1" || date --date="@$1";;
    esac
}

pp() {
    # pretty print $PATH
    echo "${PATH//:/$'\n'}"
}

gga() {
    gists -au Bhupesh-V | fzf | awk -F  "," '{print $2}' | xargs -0 browse > /dev/null 2>&1
}

gg() {
    gists -u Bhupesh-V | fzf | awk -F  "," '{print $2}' | xargs -0 browse > /dev/null 2>&1
}
