#!/usr/bin/env bash

read -p "Install Scala? [y/n]"  PARAM_SCALA
read -p "Install SBT? [y/n]"    PARAM_SBT
read -p "Enter Scala version:"  VERSION
#-------------------
# Scala
#-------------------

case $PARAM_SCALA in
    [yY])
        echo "Installing scala..."
        sudo apt-get remove scala scala-library -y
        SITE="http://www.scala-lang.org/files/archive/"
        DEBFILE="scala-$VERSION.deb"

        wget "$SITE$DEBFILE"
        sudo dpkg -i $DEBFILE
        rm $DEBFILE
        ;;
esac

#-------------------
# SBT
#-------------------

case $PARAM_SBT in
    [yY])
        echo "Installing SBT..."
        echo "deb http://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
        sudo apt-get update
        sudo apt-get install sbt --force-yes
        ;;
esac

