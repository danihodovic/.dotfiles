#!/usr/bin/env bash

read -p "Install tldr? User defined summaries of man pages. Requires NodeJS" INSTALL_TLDR
read -p "Install how2? Retrieves answers from stackoverflow. Requires NodeJS" INSTALL_HOW2

case $INSTALL_TLDR in
    y|Y) npm install tldr -g;;
esac

case $INSTALL_HOW2 in
    y|Y) npm install how2 -g;;
esac

# Unused below

# read -p "Install bro?"                          INSTALL_BRO
# read -p "Install howdoi?"                       INSTALL_HOWDOI
# read -p "Install commandlinefu?"                INSTALL_CLF

# case $INSTALL_BRO in
    # y|Y)
        # sudo apt-get install ruby ruby-dev -y
        # sudo gem install bropages
        # ;;
# esac

# case $INSTALL_HOWDOI in
    # y|Y)
        # sudo apt-get install libxml2-dev libxslt1-dev -y
        # sudo pip install howdoi
        # ;;
# esac

# case $INSTALL_CLF in
    # y|Y)
        # sudo pip install clf
        # ;;
# esac
