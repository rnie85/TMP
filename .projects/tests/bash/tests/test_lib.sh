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

test_verbose_echo_off()
{
    local out=$(__echov "Hello debug")
    assert_equals "" "$out"
}

test_verbose_echo_on()
{
    export TMP_VERBOSE=1
    local out=$(__echov "Hello debug")
    assert_equals "Hello debug" "$out"
    export TMP_VERBOSE=0
}

test_list_project_name()
{
    local expected="myProject"

    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'create-project "myOtherProject"'
    assert_status_code 0 'create-project "myProject_A"'
    assert_status_code 0 'create-project "myProject_B"'

    echo
    local out=$(__list_projects_name <<< 2)
    echo 2
    assert_equals "$expected" "$out"
}

test_list_project_name_quit()
{
    local expected="Quit"

    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'create-project "myOtherProject"'
    assert_status_code 0 'create-project "myProject_A"'
    assert_status_code 0 'create-project "myProject_B"'

    echo
    local out=$(__list_projects_name <<< q {ERROR_OUT}>&1)
    echo q
    #assert "diff <(echo $expected) <(echo $out)"
    assert_matches "$expected" "$out"
}

test_list_project_name_quit_return()
{
    local expected="Quit"

    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'create-project "myOtherProject"'
    assert_status_code 0 'create-project "myProject_A"'
    assert_status_code 0 'create-project "myProject_B"'

    assert_status_code 1 '__list_projects_name <<< q'
}

test_list_project_name_invalid_number()
{
    local expected="ERROR: No valid project selected!"

    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'create-project "myOtherProject"'
    assert_status_code 0 'create-project "myProject_A"'
    assert_status_code 0 'create-project "myProject_B"'

    echo
    local out=$(__list_projects_name <<< 8 {ERROR_OUT}>&1)
    echo q
    assert_matches "$expected" "$out"
}

test_list_project_name_invalid_number_return()
{
    local expected="ERROR: No valid project selected!"

    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'create-project "myOtherProject"'
    assert_status_code 0 'create-project "myProject_A"'
    assert_status_code 0 'create-project "myProject_B"'

    assert_status_code 2 '__list_projects_name <<< 8'
}

test_list_project_path()
{
    local expected="${ALT_HOME}/projects/myProject_A"

    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'create-project "myOtherProject"'
    assert_status_code 0 'create-project "myProject_A"'
    assert_status_code 0 'create-project "myProject_B"'

    echo
    local out=$(__list_projects <<< 3)
    echo 3
    assert_equals "$expected" "$out"
}

test_list_options()
{
    local expected="four"

    echo
    local out=$(__list_options one two three four five <<< 4)
    echo 4
    assert_equals "$expected" "$out"
}
