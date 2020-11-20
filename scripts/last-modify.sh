#!/usr/bin/env bash

# Utility to list last commit date of each file in a git repo

[[ ! -d ".git" ]] && echo -e "Not a git repo" && exit 1

if [[ "$1" ]]; then
        last_modify_date=$(git log --follow -p -- "$1" | awk '/Date/ { print $4,$3,$6 }' | head -1)
        echo -e "$last_modify_date"
        if [[ "$2" == "--all" || "$2" == "--a" ]]; then
                git log --follow -p -- "$1" | awk '/Date/ { print $4,$3,$6 }' 
        else
                echo -e "Incorrect argument. Available arguments are : --a"
                exit 1
        fi
else
        for file in $(du --exclude='.git' -a . | awk '{ print $2 }'); do
            if [[ -f "${file:2}" ]]; then
                last_modify_date=$(git log --follow -p -- "${file:2}" | awk '/Date/ { print $4,$3,$6 }' | head -1)
                [[ "$last_modify_date" ]] && printf "%12s : %s\n" "$last_modify_date" "${file:2}"
            fi
        done
fi

