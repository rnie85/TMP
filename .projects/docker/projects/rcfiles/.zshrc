echo "Docker container started, setting up the environment"
echo "* Loading: zshrc file"

. ~/projects/source_me.zsh
echo

alias q='exit'
alias ll='ls -la --group-directories-first --human-readable --color'

color_prompt=yes

cd ${HOME}
