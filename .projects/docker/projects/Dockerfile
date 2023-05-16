FROM debian:bullseye-slim

ENV RUNNING_IN_DOCKER true

RUN set -ex \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
                    zsh git tmux \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir /home/me \
 && chmod a+rw home/me

#docker build -t projects/debian_zsh:latest .
