#!/usr/bin/env bash

# Utility to list last commit date of each file in a git repo

if [[ -d ".git" ]]; then
	for file in $(du --exclude='.git' -a . | awk '{ print $2 }'); do
		if [[ -f "${file:2}" ]]; then
			last_modify_date=$(git log --follow -p -- "${file:2}" | awk '/Date/ { print $4,$3,$6 }' | head -1)
			printf "%40s %s\n" "${file:2}" "$last_modify_date"
		fi
	done
else
	echo -e "Not a git repo"
	exit 1
fi
