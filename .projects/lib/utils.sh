#!/bin/bash

exec {ERROR_OUT}>&2

__echov()
{
    [[ $TMP_VERBOSE == 1 ]] && echo "$@" || true
}

__echo_err()
{
    local color="\033[31m"
    local colorend="\033[0m"
    if [ $# -gt 0 ]; then
        echo "${@}" | awk '{ print "'$color'"$0"'$colorend'" }' >&${ERROR_OUT}
    fi
}

__echo_warn()
{
    local color="\033[33m"
    local colorend="\033[0m"
    if [ $# -gt 0 ]; then
        echo "${@}" | awk '{ print "'$color'"$0"'$colorend'" }' >&${ERROR_OUT}
    fi
}

# Not used
__list_projects()
{
    local projects=($(find "$TMP_PROJECTS" -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' | sort))
    PS3="Pick a number (q to quit)# "
    select project in ${projects[@]}; do break; done
    [[ "${REPLY}" == "q" ]] && __echo_warn "Quit" && return 1
    [[ "${project}" == "" ]] && __echo_err "ERROR: No valid project selected!" && return 2
    echo "$project"
    return 0
}

__list_projects_name()
{
    local projects=($(find "$TMP_PROJECTS" -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' -printf "%f\n" | sort))
    PS3="Pick a number (q to quit)# "
    select project in ${projects[@]}; do break; done
    [[ "${REPLY}" == "q" ]] && __echo_warn "Quit" && return 1
    [[ "${project}" == "" ]] && __echo_err "ERROR: No valid project selected!" && return 2
    echo "$project"
    return 0
}

# Not used
__list_options()
{
    local passed_options=("$@")
    PS3="Pick a number (q to quit)# "
    select option in ${passed_options[@]}; do break; done
    [[ "${REPLY}" == "q" ]] && __echo_warn "Quit" && return 1
    [[ "${option}" == "" ]] && __echo_err "ERROR: No valid option selected!" && return 2
    echo "$option"
    return 0
}

__tar()
{
    # Fix: Exclude content of `build` folder, not `build` as a file/command and folder.

    local archive="${1}"
    local folder="${2}"
    local name="${3}"
    tar -zcvf "${archive}" \
        -C "${folder}" \
        --exclude='.ccache' \
        --exclude='.venv' \
        --exclude='.mypy_cache' \
        --exclude='Debug' \
        --exclude='Release' \
        --exclude='debug' \
        --exclude='release' \
        --exclude='__pycache__' \
        --exclude='**/build/*' \
        --exclude='coverage' \
        --exclude='cscope.*' \
        --exclude='doxygen' \
        --exclude='external' \
        --exclude='tags' \
        "${name}"
}

# Not used
__list_tmux_sessions()
{
    local sessions=($(tmux list-sessions -F '#S'))
    PS3="Pick a number (q to quit)# "
    select session in ${sessions[@]}; do break; done
    [[ "${REPLY}" == "q" ]] && __echo_warn "Quit" && return 1
    [[ "${session}" == "" ]] && __echo_err "ERROR: No valid option selected!" && return 2
    echo "$session"
    return 0
}

__list_tmux_sessions_filter()
{
    local filter="${1}"
    local sessions
    #IFS=$'\n' read -d '' -ra sessions < <(tmux list-sessions -F '#S' | grep "${filter}")
    readarray -t sessions< <(tmux list-sessions -F '#S' | grep "${filter}")
    #mapfile -t sessions < <(tmux list-sessions -F '#S' | grep "${filter}")
    PS3="Pick a number (q to quit)# "
    select session in "${sessions[@]}"; do break; done
    [[ "${REPLY}" == "q" ]] && __echo_warn "Quit" && return 1
    [[ "${session}" == "" ]] && __echo_err "ERROR: No valid option selected!" && return 2
    echo "$session"
    return 0
}

