#!/usr/bin/env bash

read -p "Install bro?"                          INSTALL_BRO
read -p "Install howdoi?"                       INSTALL_HOWDOI
read -p "Install commandlinefu?"                INSTALL_CLF

case $INSTALL_BRO in
    y|Y)
        sudo apt-get install ruby ruby-dev -y
        sudo gem install bropages
        ;;
esac

case $INSTALL_HOWDOI in
    y|Y)
        sudo apt-get install libxml2-dev libxslt1-dev -y
        sudo pip install howdoi
        ;;
esac

case $INSTALL_CLF in
    y|Y)
        sudo pip install clf
        ;;
esac
