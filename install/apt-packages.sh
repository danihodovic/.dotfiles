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

# If we are root, don't use sudo.
sudo_cmd="sudo"
if [ $EUID -eq 0 ]; then
  sudo_cmd=""
fi

$sudo_cmd apt-get update
$sudo_cmd apt-get install -y \
    parcellite \
    xfce4-terminal \
    zsh \
    tmux \
    silversearcher-ag \
    xclip \
    jq \
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
    apt-file \
    direnv \
    xautolock \
    caffeine \
    asciinema

$sudo_cmd add-apt-repository ppa:peterlevi/ppa -y
$sudo_cmd apt-get update
$sudo_cmd apt-get install variety -y
