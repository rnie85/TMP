#------------------------------------//
# ALIASES
#------------------------------------//

echo "* loading aliases"

alias reload_project="cd $PROJECT_PATH && source ./envrc && cd - > /dev/null"

# make a general function for any of the mentioned actions to:
# (make build a function? with pre-setup)
# - redirect logging/action to file
# - time it took to build
# - log other metrics
alias build="echo build command not set"
alias clean="echo clean command not set"
alias testb="echo testb command not set"
alias flash="echo flash command not set"
alias scode="echo scode command not set"
alias update="echo update command not set"
# doxygen
# ctags / cscope
# auto generare picture of code structure

alias cdp="cd $PROJECT_PATH"
alias cdpp="cd $PROJECT_PATH/code"
alias cdc="cd $PROJECT_PATH/code"
alias cdd="cd $PROJECT_PATH/doc"
alias cdn="cd $PROJECT_PATH/notes"
alias cde="cd $PROJECT_PATH/.env"
#alias cdt="cd $PROJECT_PATH/tests"

alias showlinks="cat ${PROJECT_PATH}/bookmarks"
alias showcontactinfo="cat ${PROJECT_PATH}/contacts"

# vim: syn=sh
