#!/usr/bin/env bash

_xd_completions(){
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
    	return
  	fi
  	local cur=${COMP_WORDS[COMP_CWORD]}
  	local IFS=$'\n'
  	dc='"'
  	while read -r file_path; do
  		if [[ -d $file_path ]]; then
  			search_results+=( "$dc$file_path$dc" )
  		fi
    done < <( locate -e -r "/$cur$" )
    if [[ ${#search_results} == 0 ]]; then
    	# do loose search
    	while read -r file_path; do
			if [[ -d $file_path ]]; then
  				search_results+=( "$dc$file_path$dc" )
  			fi
    	done < <( locate -e -b -r "$cur" )
    fi

	COMPREPLY=("${search_results[@]}")
	unset search_results
}

complete -F _xd_completions xd