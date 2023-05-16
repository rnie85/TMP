#------------------------------------//
# FUNCTIONS
#------------------------------------//

echo "* loading functions"

fdp()
{
    #fd -iaH "$1" "${PROJECT_PATH}"
    fd -iH "$1" "${PROJECT_PATH}"
    echo
    echo "executed: fd -iH "$1" "${PROJECT_PATH}""
}

fdpa()
{
    fd -iIH "$1" "${PROJECT_PATH}"
    echo
    echo "executed: fd -iIH "$1" "${PROJECT_PATH}""
}

rgp()
{
    rg -i --hidden "$1" "${PROJECT_PATH}"
    echo
    echo "executed: rg -i --hidden "$1" "${PROJECT_PATH}""
}

rgpa()
{
    rg -i --hidden -u "$1" "${PROJECT_PATH}"
    echo
    echo "executed: rg -i --hidden -u "$1" "${PROJECT_PATH}""
}

# vim: syn=sh
