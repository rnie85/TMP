#!/bin/bash

[[ -z "${TMP_PROJECTS}" ]] && export TMP_PROJECTS="$HOME/projects"
[[ -z "${TMP_PROJECTS_BACKUP}" ]] && export TMP_PROJECTS_BACKUP="$HOME/projects_backup"
[[ -z "${TMP_VERBOSE}" ]] && export TMP_VERBOSE=0

. ${TMP_PROJECTS}/.projects/lib/utils.sh
. ${TMP_PROJECTS}/.projects/lib/common.sh

echo
echo "* Loading projects \"${TMP_PROJECTS}\" (Bash)"

alias reload_projects=". ${TMP_PROJECTS}/source_me.sh"

update-history()
{
    export HISTFILE="${TMP_PROJECTS}/${name}/.env/HISTFILE"
    touch $HISTFILE
    history -c
    history -r $HISTFILE
}

__init-project-if-project-name-is-set

__echov "* TMP_VERBOSE is turned on"
