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
    unset PROJECT_NAME
    source ${ALT_PROJECTS}/source_me.sh
    echo
}

teardown_suite()
{
    rm -rf $ALT_HOME
}

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

test_import_project_no_name()
{
    assert_status_code 1 'import-project'
}

test_import_project()
{
    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'delete-project <<< 1'
    assert_status_code 0 'import-project $HOME/projects_backup/*/*'
}

test_import_project_already_exists()
{
    assert_status_code 0 'create-project "myProject"'
    assert_status_code 0 'backup-project <<< 1'
    assert_status_code 1 'import-project $HOME/projects_backup/*/*'
}

test_import_project_empty_archive()
{
    archive="/tmp/archive.tar.gz"
    empty_folder="/tmp/empty_folder"
    mkdir -p "${empty_folder}"
    tar -zcvf "${archive}" -C "${empty_folder}" .

    assert_status_code 1 "import-project ${archive}"

    rm -rf "${empty_folder}"
    rm -rf "${archive}"
}

test_import_project_multiple_files_in_root_archive()
{
    archive="/tmp/archive.tar.gz"
    folder="/tmp/folder"
    mkdir -p "${folder}"
    touch "${folder}/foo"
    touch "${folder}/bar"
    mkdir -p "${folder}/projA"
    tar -zcvf "${archive}" -C "${folder}" .

    assert_status_code 1 "import-project ${archive}"

    rm -rf "${folder}"
    rm -rf "${archive}"
}

test_import_project_file_in_root_archive()
{
    archive="/tmp/archive.tar.gz"
    folder="/tmp/folder"
    mkdir -p "${folder}"
    touch "${folder}/foo"
    tar -zcvf "${archive}" -C "${folder}" .

    assert_status_code 1 "import-project ${archive}"

    rm -rf "${folder}"
    rm -rf "${archive}"
}
