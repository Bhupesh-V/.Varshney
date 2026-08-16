# Contains history rules, shopt flags, and terminal pager/grep color settings.

# History settings
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=2000
HISTFILESIZE=2000

# Shell options
shopt -s autocd
shopt -s histappend
shopt -s cdspell
shopt -s checkwinsize
# shopt -s globstar

# Pager (less) integration
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export LESS='--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Grep formatting colors
export GREP_COLORS='ms=1;38;5;214:fn=1;38;5;154:ln=1;38;5;111'