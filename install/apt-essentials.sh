#!/usr/bin/env bash
set -e

sudo apt-get update
sudo apt-get install \
    zsh \
    tmux \
    silversearcher-ag \
    xclip \
    git-extras \
    curl \
    sshfs \
    cmake \
    python-dev \
    xdotool wmctrl \
    colortest \
    -y
