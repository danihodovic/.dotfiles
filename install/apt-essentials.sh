#!/usr/bin/env bash
set -e
set -u

# cmake, python-dev, build-essentials required by YCM

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
    build-essential \
    xdotool wmctrl \
    colortest \
    tig \
    vnstat \
    gparted \
    -y
