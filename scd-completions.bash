#!/usr/bin/env bash

_scd_completions(){
	local cur=${COMP_WORDS[COMP_CWORD]}
	local IFS=$'\n'
	# handle space separated dir names
	dqc='"'
	while read -r file_path; do
    [[ -d $file_path ]] && search_results+=( "$dqc$file_path$dqc" )
    done < <( locate -er "/$cur$" )
    if [[ ${#search_results} == 0 ]]; then
    	while read -r file_path; do
            [[ -d $file_path ]] && search_results+=( "$dqc$file_path$dqc" )
        # do loose search
    	done < <( locate -ebr "$cur" )
    fi

    COMPREPLY=("${search_results[@]}")
    unset search_results
}

complete -F _scd_completions scd