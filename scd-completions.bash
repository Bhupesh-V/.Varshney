#!/usr/bin/env bash

_scd_completions(){
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
      	return
	fi
	local cur=${COMP_WORDS[COMP_CWORD]}
	local IFS=$'\n'
	# handle space separated dir names
	dqc='"'
	while read -r file_path; do
		if [[ -d $file_path ]]; then
			search_results+=( "$dqc$file_path$dqc" )
		fi
    done < <( locate -e -r "/$cur$" )
    if [[ ${#search_results} == 0 ]]; then
    	# do loose search
    	while read -r file_path; do
        	if [[ -d $file_path ]]; then
        		search_results+=( "$dqc$file_path$dqc" )
        	fi
    	done < <( locate -e -b -r "$cur" )
    fi

    COMPREPLY=("${search_results[@]}")
    unset search_results
}

complete -F _scd_completions scd