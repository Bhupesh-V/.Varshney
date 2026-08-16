# Color Definitions
RESET="\e[0m"
BOLD_BLACK_FG="\e[1;30m"
GRAY_BG="\e[48;5;234m"
GRAY_FG="\e[38;5;234m"
BOLD_L_YELLOW=$'\e[1;38;5;11m'
BOLD_RED_FG=$'\e[1;38;5;9m'
BOLD_GREEN_FG=$'\e[1;32m'
BOLD_BLUE_FG=$'\e[1;38;5;111m'
BOLD_ORANGE_FG="\e[1;38;5;208m"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color | *-256color) color_prompt=yes ;;
esac

force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

git_status() {
    status_data=$(git status --porcelain 2>/dev/null)
    untracked=0 modified=0 tracked=0 deleted=0

    while read -r line || [ -n "$line" ]; do
        [ -z "$line" ] && continue
        
        case "${line:0:2}" in
            *\?*) (( ++untracked )) ;;
            *M*)  (( ++modified )) ;;
            *A*)  (( ++tracked )) ;;
            *D*)  (( ++deleted )) ;;
        esac
    done <<< "$status_data"

    delete_symbol="✖ "
    tracked_symbol="✚"
    modified_symbol="●"
    GIT_STATUS_PROMPT=""

    if [[ $untracked != 0 ]]; then
        GIT_STATUS_PROMPT+=" ${BOLD_BLUE_FG}${tracked_symbol} ${untracked}"
    fi
    if [[ $tracked != 0 ]]; then
        GIT_STATUS_PROMPT+=" ${BOLD_GREEN_FG}${tracked_symbol} ${tracked}"
    fi
    if [[ $modified != 0 ]]; then
        GIT_STATUS_PROMPT+=" ${BOLD_L_YELLOW}${modified_symbol} ${modified}"
    fi
    if [[ $deleted != 0 ]]; then
        GIT_STATUS_PROMPT+=" ${BOLD_RED_FG}${delete_symbol}${deleted}"
    fi
    GIT_STATUS_PROMPT+=" ${RESET}"
    echo -e "${GIT_STATUS_PROMPT}"
}

random_emoji() {
    local count="${1:-1}"
    shuf -n "$count" -e \
        $(seq 128512 128591) \
        $(seq 127792 127866) \
        $(seq 128000 128062) \
        $(seq 129292 129338) \
        | while read -r code; do
            printf "\\U$(printf "%08X" "$code")"
        done
    echo ""
}

get_git_branch() {
    curr_branch=$(git branch 2> /dev/null | grep \\* | cut -d ' ' -f2)
    [ "$curr_branch" ] && printf "($BOLD_ORANGE_FG%s$RESET)" "$curr_branch"
}

virtualenv_ps1() {
    [ "$VIRTUAL_ENV" ] && printf "%s" "$(basename "$VIRTUAL_ENV")"
}

RIGHT_PROMPT="\n\$(tput sc; tput rc)"

custom_prompt() {
    EXIT="$?"

    RAND_COLOR=$((16 + RANDOM % 216))
    ARROW_FG="\e[38;5;${RAND_COLOR}m"
    ARROW_BG="\e[48;5;${RAND_COLOR}m"

    last_command_status=$([ "$EXIT" != 0 ] && printf "%s" "\[$BOLD_RED_FG\]✘")

    venv=$(virtualenv_ps1)
    [ -n "$venv" ] && venv=" $venv "
    arrp="\[$GRAY_BG\] $last_command_status $(random_emoji) \[$GRAY_FG\]\[$ARROW_BG\]\[$ARROW_BG\]\[$BOLD_BLACK_FG\]${venv}\[$RESET\]\[$ARROW_FG\]\[$RESET\]"
    PS1="\[$BOLD_L_YELLOW\]\[$RIGHT_PROMPT\]\[$RESET\]\[$BOLD_GREEN_FG\]\w\[$RESET\] $(get_git_branch)$(git_status)\n$arrp "
}

if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND=custom_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt