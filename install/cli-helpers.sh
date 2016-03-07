#!/usr/bin/env bash

read -p "Install tldr? User defined summaries of man pages. Requires NodeJS" INSTALL_TLDR
read -p "Install how2? Retrieves answers from stackoverflow. Requires NodeJS" INSTALL_HOW2

case $INSTALL_TLDR in
    y|Y) npm install tldr -g;;
esac

case $INSTALL_HOW2 in
    y|Y) npm install how2 -g;;
esac

