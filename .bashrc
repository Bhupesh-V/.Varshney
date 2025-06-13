# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Gib me all the colors 
export TERM=xterm-256color
export DOTFILES_HOME="$HOME/Documents/.Varshney"
export PATH="$DOTFILES_HOME/scripts:$PATH"
export PATH="$DOTFILES_HOME/scripts/git:$PATH"
export PATH="$DOTFILES_HOME/scripts/github:$PATH"
export PATH="$DOTFILES_HOME/scripts/aws:$PATH"
# export PATH="$HOME/Documents/ugit:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000

shopt -s autocd

# append to the history file, don't overwrite it
shopt -s histappend

# Correct dir spellings
shopt -s cdspell

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

# color definitions
RESET="\e[0m"
BOLD_BLACK_FG="\e[1;30m"
GRAY_BG="\e[48;5;234m"
GRAY_FG="\e[38;5;234m"
BOLD_L_YELLOW=$'\e[1;38;5;11m'
BOLD_RED_FG=$'\e[1;38;5;9m'
BOLD_GREEN_FG=$'\e[1;32m'
BOLD_BLUE_FG=$'\e[1;38;5;111m'
BOLD_ORANGE_FG="\e[1;38;5;208m"

git_status() {
    status=$(git status --porcelain 2> /dev/null)
    untracked=$(echo "$status" | grep -c "??\s")
    modified=$(echo "$status" | grep -c "M\s")
    tracked=$(echo "$status" | grep -c "A\s")
    deleted=$(echo "$status" | grep -c "D\s")

    delete_symbol="✖ "
    tracked_symbol="✚"
    modified_symbol="●"
    GIT_STATUS_PROMPT=""

# GIT_STATUS_PROMPT+="${GRAY_BG}"
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
	# add a random emoticon (mostly face emojis)
	printf "%b" "\U1F$(shuf -i600-640 -n1)"
}

get_git_branch() {
    curr_branch=$(git branch 2> /dev/null | grep \\* | cut -d ' ' -f2)
    [ "$curr_branch" ] && printf "($BOLD_ORANGE_FG%s$RESET)" "$curr_branch"
}

pc_uptime() {
    uptime -p | awk '{for (i=2; i<NF; i++) printf $i " "; if (NF >= 1) print $NF; }'
}

virtualenv_ps1() {
    [ "$VIRTUAL_ENV" ] && printf "%s" " $(basename "$VIRTUAL_ENV")"
}

rightprompt() {
    # display stuff on right side of prompt
    printf '%*s' $COLUMNS "$(pc_uptime)"
}

# handles cursor position
RIGHT_PROMPT="\n\$(tput sc; rightprompt; tput rc)"

custom_prompt() {
	EXIT="$?"
    color_themes=("38" "112" "220" "196" "200" "208" "255")
    size=${#color_themes[@]}
    index=$(($RANDOM % $size))
    ARROW_FG="\e[38;5;${color_themes[$index]}m"
    ARROW_BG="\e[48;5;${color_themes[$index]}m"
	last_command_status=$([ "$EXIT" != 0 ] && printf "%s" "\[$BOLD_RED_FG\]✘")
    arrp="\[$GRAY_BG\] $last_command_status $(random_emoji) \[$GRAY_FG\]\[$ARROW_BG\]\[$ARROW_BG\]\[$BOLD_BLACK_FG\] $(virtualenv_ps1) \[$RESET\]\[$ARROW_FG\]\[$RESET\]"
    PS1="\[$BOLD_L_YELLOW\]\[$RIGHT_PROMPT\]\[$RESET\]\[$BOLD_GREEN_FG\]\w\[$RESET\] $(get_git_branch)$(git_status)\n$arrp "
}

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PROMPT_COMMAND=custom_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# Don't change the order, first load functions & then aliases
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

export CDPATH=".:/home/bhupesh"

# Make grep output sexy
# Default: ‘ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36’
# Read: https://www.gnu.org/software/grep/manual/grep.html#index-GREP_005fCOLORS-environment-variable
# Also: https://bhupesh-v.github.io/making-grep-searches-sexier/
export GREP_COLORS='ms=1;38;5;214:fn=1;38;5;154:ln=1;38;5;111'

# set options for less
export LESS='--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
# or the short version
# export LESS='-F -i -J -M -R -W -x4 -X -z-4'
# Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export DOT_REPO=https://github.com/Bhupesh-V/.Varshney DOT_DEST=Documents
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# source ~/.work_profile
# source /home/bhupesh/fzf-docker/docker-fzf

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(/opt/homebrew/bin/brew shellenv)"

# Setting PATH for Python 3.13
# The original version is saved in .bash_profile.pysave
export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
