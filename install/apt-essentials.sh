#!/usr/bin/env bash

# Notes

# Why xfce4-terminal?
# 1. Can copy paste with both C-c and mouse
# 2. Can seamlessly use the xdotool script to switch windows with i3/vim
# 3. Doesn't have to reload xrdb ~/.Xresources to change fonts

# Use gnome-settings daemon instead of keychain because of reasons
set -e
set -u

# cmake, python-dev, build-essentials required by YCM

sudo apt-get update
sudo apt-get install \
    parcellite \
    xfce4-terminal \
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
    shellcheck \
    rofi \
    ranger \
    gnome-settings-daemon \
    -y

