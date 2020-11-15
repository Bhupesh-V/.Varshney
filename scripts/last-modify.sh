#!/usr/bin/env bash

# Utility to list last commit date of each file in a git repo

[[ ! -d ".git" ]] && echo -e "Not a git repo" && exit 1

for file in $(du --exclude='.git' -a . | awk '{ print $2 }'); do
	if [[ -f "${file:2}" ]]; then
		last_modify_date=$(git log --follow -p -- "${file:2}" | awk '/Date/ { print $4,$3,$6 }' | head -1)
		if [[ "$last_modify_date" ]]; then
			printf "%s : %s\n" "$last_modify_date" "${file:2}"
		fi
	fi
done
