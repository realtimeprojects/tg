#!/bin/bash

_mksource_completion()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(mksource --show_args)"

    case "${prev}" in
        --template)
            tmpls=$(mksource --list)
            COMPREPLY=( $(compgen -W "${tmpls}" -- ${cur}) )
            return 0
            ;;
        esac

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F _mksource_completion mksource;

