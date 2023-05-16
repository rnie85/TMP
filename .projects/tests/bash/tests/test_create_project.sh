#!/bin/bash

setup_suite()
{
    echo
    echo "==== Setup test environment ===="

    ALT_HOME="/tmp/projects_test"
    export HOME=${ALT_HOME}

    ALT_PROJECTS="${ALT_HOME}/projects"
    CUR_PROJECTS="${PWD}/../../../../"

    echo "* Create an alternative projects folder to run tests on"
    if [ -d "${ALT_PROJECTS}" ]; then
        echo "* Remove existing \"${ALT_PROJECTS}\""
        rm -rf "${ALT_PROJECTS}"
    fi
    mkdir -p "${ALT_PROJECTS}"

    echo "* Copy projects files"
    cp -r "${CUR_PROJECTS}/.projects"     "${ALT_PROJECTS}"
    cp    "${CUR_PROJECTS}/source_me.sh" "${ALT_PROJECTS}"

    unset TMP_PROJECTS
    unset TMP_PROJECTS_BACKUP
    unset TMP_VERBOSE
    source ${ALT_PROJECTS}/source_me.sh
    echo
}

teardown_suite()
{
    rm -rf $ALT_HOME
}

#setup()
#{
#    true
#}

teardown()
{
    cleanup
    true
}

cleanup()
{
    find ${ALT_PROJECTS} -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' -exec rm -rf {} \;
    rm -rf $ALT_HOME/projects_backup
}

test_create_project()
{
    assert_status_code 0 'create-project "myProject"'
}

test_create_project_short_name()
{
    local expected="ERROR: invalid name, name is too short"
    local out=$(create-project "s" 2>&1)
    #assert 'diff <(echo $expected) <(echo $out)'
    assert_matches "$expected" "$out"
}

test_create_project_short_name_return()
{
    assert_status_code 1 'create-project "q"'
}

test_create_project_input_name()
{
    assert_status_code 0 'create-project <<< "myProject"'
}

test_create_multiple_projects()
{
    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'create-project "myOtherProject"'
}

test_create_project_that_already_exists()
{
    assert_status_code 0 'create-project "myProject"'
    assert_status_code 1 'create-project "myProject"'
}

test_create_project_check_files_and_folders()
{
    assert_status_code 0 'create-project "myProject"'

    assert "test -d $HOME/projects/myProject"
    assert "test -d $HOME/projects/myProject/notes"
    assert "test -d $HOME/projects/myProject/doc"
    assert "test -d $HOME/projects/myProject/.env"

    assert "test -e $HOME/projects/myProject/.env/main.sh"
    assert "test -e $HOME/projects/myProject/.env/aliases.sh"
    assert "test -e $HOME/projects/myProject/.env/functions.sh"
    assert "test -e $HOME/projects/myProject/.env/exports.sh"
}
