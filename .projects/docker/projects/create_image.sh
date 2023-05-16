#!/bin/sh

#cd "${TMP_PROJECTS}/.projects/docker/projects" || exit 1
docker build -t projects/debian_zsh:latest .
