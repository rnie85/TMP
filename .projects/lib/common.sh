#!/bin/bash

export PATH="${TMP_PROJECTS}/.projects/bin:${PATH}"
alias tmp='init-tmux-project'

# tmux colors are not 24-bit if TERM is set to st.
[[ "${TERM}" == "st-256color" ]] && export TERM=xterm-256color

init-project()
{
    echo "* Initialize a project"
    local name="$1"
    local skip_ps1_change="$2"
    if [[ $name == "" ]]; then
        echo
        echo "Choose a project:"
        name=$(__list_projects_name) || return $?
        echo
    else
        echo "  * Project name is ${name}"
        if [[ -d "${TMP_PROJECTS}/${name}" ]]; then
            echo "  * Use existing project"
        else
            __echo_err "ERROR: Unknown project \"${name}\""
            return 1
        fi
    fi

    echo "* Set history file"
    update-history

    local project="${TMP_PROJECTS}/$name"
    if [[ $project != "" ]]; then
        echo "* Initializing environment"
        echo
        cd "${project}"
        source "envrc"
        cd - > /dev/null
        if [[ "${skip_ps1_change}" != true ]]; then
            if [[ ! "${PS1}" = *"[${name}]"* ]]; then
                PS1="[${name}] $PS1"
            fi
        fi
    else
        __echo_err "Something wong!"
    fi
}

refresh-tmux-environment()
{
    if [ -n "$TMUX" ]; then
        echo "Refresh tmux evironment variables"
        tmux show-environment
        tmux show-environment -s > /tmp/tmsetenv
        . /tmp/tmsetenv
        # It updates all environment variables. To only update specific ones:
        #export $(tmux show-environment | grep "^DISPLAY")
    else
        echo "No tmux session running"
    fi
}
alias tmr='refresh-tmux-environment'

__init-project-if-project-name-is-set()
{
    echo "* Initialize a project if PROJECT_NAME is set"
    [[ -z "${PROJECT_NAME}" ]] && echo "  * PROJECT_NAME Not set, nothing to do" && return 0
    init-project "${PROJECT_NAME}" true
}
