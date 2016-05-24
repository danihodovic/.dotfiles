#!/usr/bin/env bash

read -p "Install dasht? Cli tool for reading docs [y/n] " INSTALL_DASHT
read -p "Install tldr? User defined summaries of man pages. Requires NodeJS [y/n] " INSTALL_TLDR
read -p "Install how2? Retrieves answers from stackoverflow. Requires NodeJS [y/n] " INSTALL_HOW2

case $INSTALL_DASHT in
  y|Y)
    sudo apt-get install sqlite3 w3m wget -y
    git clone git@github.com:sunaku/dasht.git "${HOME}/.dasht"
    ;;
esac

case $INSTALL_TLDR in
    y|Y) npm install tldr -g;;
esac

case $INSTALL_HOW2 in
    y|Y) npm install how2 -g;;
esac

