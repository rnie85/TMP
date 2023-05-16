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

test_delete_invalid_project()
{
    local expected="ERROR: No valid project selected!"
    assert_status_code 0 'create-project "myProject"'
    local out=$(delete-project <<< 5 2>&1)
    # select outputs menu to &2, $out includes the menu and the error message
    #assert 'diff <(echo $expected) <(echo $out)'
    assert_matches "$expected" "$out"
}

test_delete_invalid_project_return()
{
    assert_status_code 0 'create-project "myProject"'
    assert_status_code 2 'delete-project <<< 5'
}

test_delete_project_backup()
{
    assert_status_code 0 'create-project "myProject"'
    # check if folder exists
    assert "test -d $HOME/projects/myProject"

    assert_status_code 0 'delete-project <<< 1'

    # check if folder is deleted
    assert "test ! -d $HOME/projects/myProject"
    # check if backup is made
    DATE="$(date +"%Y%m%d")"
    assert "test -d $HOME/projects_backup/${DATE}"
}

# delete-project sources `utils.sh` which contains `backup-project` 
# so its first faked and then overwritten
todo_test_delete_project_backup_fail()
{
    fake backup-project return 1
    fake backup-project << EOF
echo HELP!
return 1
EOF
    local expected="ERROR: backup of project failed"
    assert_status_code 0 'create-project "myProject"'

    local out=$(delete-project <<< 1 2>&1)
    # select outputs menu to &2, $out includes the menu and the error message
    assert 'diff <(echo $expected) <(echo $out)'
    assert_matches "$expected" "$out"
}

todo_test_delete_project_backup_fail_return()
{
    fake backup-project false
    assert_status_code 0 'create-project "myProject"'
    assert_status_code 1 'delete-project <<< 1'
}

