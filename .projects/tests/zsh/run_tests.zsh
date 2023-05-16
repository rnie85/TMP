#!/bin/zsh

trap 'full_cleanup' INT TERM EXIT

echo "==== Setup test environment ===="

ALT_HOME="/tmp/projects_test"
export HOME=$ALT_HOME

ALT_PROJECTS="${ALT_HOME}/projects"
CUR_PROJECTS="${PWD}/../../../"

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

#----------------------------------------------------------
# Test functions
#----------------------------------------------------------
GREEN="\e[32m"
RED="\e[31m"
NOCOLOR="\e[0m"

SUCCESS="${GREEN}Success${NOCOLOR}"
FAILED="${RED}Failed${NOCOLOR}"

assert_eq()
{
    [[ $1 == $2 ]] && echo "${SUCCESS}" || { echo "${FAILED} [ $1 != $2 ]" && exit 1 }
}

assert_not_eq()
{
    [[ $1 != $2 ]] && echo "${SUCCESS}" || { echo "${FAILED} [ $1 != $2 ]" && exit 1 }
}

assert_eq_str()
{
    [[ "$1" == "$2" ]] && echo "${SUCCESS}" || { echo "${FAILED} [ $1 != $2 ]" && exit 1 }
}

assert_dir_exists()
{
    [[ -d $1 ]] && echo "${SUCCESS}" || { echo "${FAILED} [ directory $1 does not exist ]" && exit }
}

assert_dir_not_exists()
{
    [[ ! -d $1 ]] && echo "${SUCCESS}" || { echo "${FAILED} [ directory $1 exist ]" && exit }
}

assert_file_exists()
{
    [[ -f $1 ]] && echo "${SUCCESS}" || { echo "${FAILED} [ file $1 does not exist ]" && exit }
}

#assert_env_eq()
#{
    #[[ $1 == $2 ]] "/tmp/nono"
#}

run_test()
{
    echo "========== $1 =========="
    $@
    cleanup
    echo
}

cleanup()
{
    echo "Cleanup"
    find ${ALT_PROJECTS} -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' -exec rm -rf {} \;
    rm -rf $ALT_HOME/projects_backup
}

full_cleanup()
{
    echo "Full Cleanup"
    rm -rf $ALT_HOME
}

#----------------------------------------------------------
# Tests
#----------------------------------------------------------
test_echov_verbose_0()
{
    local VERBOSE=0
    __echov "test 0"
}

test_echov_verbose_1()
{
    local VERBOSE=1
    __echov "test 1"
}

test_create-project-no-name()
{
    create-project <<< "jow"
    assert_eq $? 0
}

test_create-project-already-exists()
{
    create-project "myProject"
    assert_eq $? 0
    echo

    create-project "myProject"
    assert_eq $? 1
}

test_create-project-with-name()
{
    create-project "myProject"
    assert_eq $? 0
    assert_dir_exists "$HOME/projects/myProject"
    assert_dir_exists "$HOME/projects/myProject/notes"
    assert_dir_exists "$HOME/projects/myProject/doc"
    assert_dir_exists "$HOME/projects/myProject/.env"

    assert_file_exists "$HOME/projects/myProject/.env/main.sh"
    assert_file_exists "$HOME/projects/myProject/.env/aliases.sh"
    assert_file_exists "$HOME/projects/myProject/.env/functions.sh"
    assert_file_exists "$HOME/projects/myProject/.env/exports.sh"
}

test_list-projects-no-name()
{
    expected="${ALT_HOME}/projects/myPersonalProject"
    create-project "myProject"
    create-project "myOtherProject"
    create-project "myPersonalProject"
    create-project "myProject_a"
    create-project "myProject_b"
    echo

    #for project in $projects; do
    #    echo "this: $project"
    #done
    echo
    local out=$(__list_projects <<< 2)
    echo "${out}"
    assert_eq "${out}" "${expected}"
}

test_list-options()
{
    test_options=("option_1" "option_2" "option_3" "option_4" "option_5")
    expected="option_3"
    local out=$(__list_options $test_options <<< 3)
    echo "${out}"
    assert_eq "${out}" "${expected}"
}

test_backup-project-no-name()
{
    create-project "myProject"
    assert_eq $? 0
    echo

    backup-project
    assert_eq $? 1
}

test_backup-project()
{
    create-project "myProject"
    assert_eq $? 0
    echo

    backup-project "myProject"
    assert_eq $? 0
    DATE="$(date +"%Y%m%d")"
    assert_dir_exists "$HOME/projects_backup/${DATE}"
}

test_backup-project-code()
{
    create-project "myProjectCode"
    assert_eq $? 0
    echo

    touch "$HOME/projects/myProjectCode/code/aFile"
    touch "$HOME/projects/myProjectCode/code/someFile"

    backup-project-code "myProjectCode"
    assert_eq $? 0
    DATE="$(date +"%Y%m%d")"
    assert_dir_exists "$HOME/projects_backup/${DATE}"
}

test_backup-all-project()
{
    create-project "myProject_1"
    assert_eq $? 0
    echo
    create-project "myProject_2"
    assert_eq $? 0
    echo
    create-project "myProject_3"
    assert_eq $? 0
    echo

    backup-all-projects
    assert_eq $? 0
    DATE="$(date +"%Y%m%d")"
    assert_dir_exists "$HOME/projects_backup/${DATE}"
}

test_init-project()
{
    create-project "myProject"
    create-project "myOtherProject"
    create-project "myPersonalProject"

    init-project <<< 3
    assert_eq "$PROJECT_NAME" "myProject"
}

test_init-project-with-existing-name()
{
    create-project "existingProject"
    echo

    local name="existingProject"
    init-project "${name}"
    assert_eq "$PROJECT_NAME" "${name}"
}

test_init-project-with-invalid-name()
{
    local name="NewProject"
    init-project "${name}"
    assert_dir_not_exists "$HOME/projects/${name}"
    assert_not_eq "$PROJECT_NAME" "${name}"
}

test_delete-project()
{
    create-project "myProject"
    create-project "myOtherProject"
    create-project "myPersonalProject"
    echo

    delete-project <<< 1
    assert_dir_not_exists "${HOME}/projects/myOtherProject"
}

test_deinit-project()
{
    create-project "myProject"
    echo

    local name="myProject"
    init-project "${name}"
    assert_eq "$PROJECT_NAME" "${name}"

    # to reset / unset i would have to do
    # unset exports
    unset PROJECT_NAME
    # unset aliases (regular expression iod on aliases.sh)
    unalias cdd
    # reset prompt
    # PS1="$OLD_PS1"
    # unset functions

    echo "============= $PROJECT_NAME =========="
    assert_eq "$PROJECT_NAME" ""
}

#----------------------------------------------------------
# Execute Tests
#----------------------------------------------------------

echo "ALT_HOME: ${ALT_HOME}"
echo "TMP_PROJECTS: ${TMP_PROJECTS}"
echo "TMP_PROJECTS_BACKUP: ${TMP_PROJECTS_BACKUP}"


run_test test_echov_verbose_0
run_test test_echov_verbose_1

run_test test_create-project-no-name
run_test test_create-project-already-exists
run_test test_create-project-with-name

run_test test_list-projects-no-name
run_test test_list-options

#run_test test_backup-project-no-name
run_test test_backup-project
run_test test_backup-project-code
run_test test_backup-all-project

run_test test_init-project
run_test test_init-project-with-existing-name
run_test test_init-project-with-invalid-name

run_test test_delete-project
run_test test_deinit-project

echo "======== All tests passed! ========"
echo
