#!/bin/bash

_tg_completion()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(tg showargs)"

    case "${prev}" in
        using|-t|--template)
            tmpls=$(tg list)
            COMPREPLY=( $(compgen -W "${tmpls}" -- ${cur}) )
            return 0
            ;;
        esac

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F _tg_completion tg;

