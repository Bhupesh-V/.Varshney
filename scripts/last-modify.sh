#!/usr/bin/env bash

# Utility to list last commit date of each file in a git repo
#
# Usage
# 1. last_modify.sh : to get last commit log of each file
# 2. last_modify.sh --a <filepath> : to get all commits which modified this file
# 3. last_modify.sh <filepath> : to get latest commit which modified this file

[[ ! -d ".git" ]] && echo -e "Not a git repo" && exit 1

git_log="git log --follow --color=always --date=format:'%d %b %Y' --pretty=format:\"(%Cgreen%h%Creset)[%ad] %C(yellow bold)%s%Creset\" -q"
if [[ "$1" == "--all" || "$1" == "--a" ]]; then
  # print all commits that modified this file
  printf "%s\n" "$(eval $git_log -- "$2")"
elif [[ -f "$1" ]]; then
  # print only latest commit for this file
  last_modify_date=$(eval $git_log -- "$1" | head -1)
  echo -e "$last_modify_date"
else
  # print latest commit log of each file in repo
  tracked_files=$(du --exclude='.git' -a . | awk '{ print $2 }')
  for file in ${tracked_files[@]}; do
    if [[ -f "${file:2}" ]]; then
      last_modify_date=$(eval $git_log -- "${file:2}" | head -1)
      [[ "$last_modify_date" ]] && printf "\n%s\n%s" "${file:2}" "$last_modify_date"
    fi
  done
fi

