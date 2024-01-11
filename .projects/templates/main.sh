#------------------------------------//
# Main
#------------------------------------//

echo "loading main of project \"$PROJECT_NAME\""

. "$PROJECT_PATH/.env/exports.sh"
. "$PROJECT_PATH/.env/aliases.sh"
. "$PROJECT_PATH/.env/functions.sh"

export PATH=${PROJECT_PATH}/.env/bin:${PATH}

echo

# vim: syn=sh
